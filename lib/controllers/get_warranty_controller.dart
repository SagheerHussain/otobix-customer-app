import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:otobix_customer_app/Models/cars_list_model.dart';
import 'package:otobix_customer_app/Models/warranty_options_model.dart';
import 'package:otobix_customer_app/controllers/get_warranty_cars_list_controller.dart';
import 'package:otobix_customer_app/controllers/razorpay_payment_controller.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/services/user_activity_log_service.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_constants.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';
import 'package:path_provider/path_provider.dart';

class GetWarrantyController extends GetxController {
  RxBool isGetWarrantyLoading = false.obs;
  RxBool isWarrantyOptionsLoading = false.obs;

  // Warranty selection
  RxInt selectedWarrantyIndex = (-1).obs;

  void selectWarranty(int index) {
    selectedWarrantyIndex.value = index;

    if (index < 0 || index >= warrantyOptions.length) return;
    final opt = warrantyOptions[index];

    warrantyCover = opt.warrantyCover;
    warrantyPeriod = opt.warrantyPeriod;

    // ✅ final payable
    warrantyPrice = opt.warrantyPriceAfterGst;
  }

  // ✅ dynamic list from API
  final RxList<WarrantyOptionsModel> warrantyOptions =
      <WarrantyOptionsModel>[].obs;

  // Selected option values used in payment + sale api
  String warrantyCover = '';
  String warrantyPeriod = '';
  double warrantyPrice = 0.0;

  // Fetch warranty options
  Future<void> fetchWarrantyOptions({
    required String carId,
    required String appointmentId,
    required String registrationNumber,
  }) async {
    if (isWarrantyOptionsLoading.value) return;

    isWarrantyOptionsLoading.value = true;
    try {
      final response = await ApiService.get(
        endpoint: AppUrls.getWarrantyOptions(
          registrationNumber: registrationNumber,
          // registrationNumber: "WB08Q9069",
        ),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        final List list = (body?['data'] ?? []) as List;
        final parsed = list
            .map(
              (e) => WarrantyOptionsModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();

        warrantyOptions.assignAll(parsed);

        // reset selection when new list comes
        selectedWarrantyIndex.value = -1;
        warrantyCover = '';
        warrantyPeriod = '';
        warrantyPrice = 0.0;

        if (parsed.isEmpty) {
          ToastWidget.show(
            context: Get.context!,
            title: "No Options",
            subtitle: "No warranty options available for this car.",
            type: ToastType.error,
          );
        }

        // Log event
        final String userId =
            await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ??
            '';
        UserActivityLogService.logEvent(
          userId: userId,
          event: AppConstants.userActivityLogEvents.warrantyPageOpened,
          eventDetails: 'User opened warranty page for a car',
          metadata: {
            'carId': carId,
            'appointmentId': appointmentId,
            'registrationNumber': registrationNumber,
            'warrantyOptions': warrantyOptions.toJson(),
          },
        );
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: "Failed",
          subtitle: 'Failed to fetch warranty options',
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint(error.toString());
      ToastWidget.show(
        context: Get.context!,
        title: "Error",
        subtitle: 'Error fetching warranty options',
        type: ToastType.error,
      );
    } finally {
      isWarrantyOptionsLoading.value = false;
    }
  }

  // Request Extended Warranty (ewi)
  Future<void> submitGetWarranty({required CarsListModel car}) async {
    if (isGetWarrantyLoading.value) return;

    // ✅ 1) Must select warranty first
    if (selectedWarrantyIndex.value == -1) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Select Warranty Option',
        subtitle: 'Please select a warranty option to proceed.',
        type: ToastType.error,
      );
      return;
    }

    isGetWarrantyLoading.value = true;

    try {
      final userId =
          await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? "";
      final userEmail =
          await SharedPrefsHelper.getString(SharedPrefsHelper.userEmailKey) ??
          "";
      final userPhone =
          await SharedPrefsHelper.getString(
            SharedPrefsHelper.userPhoneNumberKey,
          ) ??
          "";

      // Selected warranty option
      final selectedWarrantyOption =
          warrantyOptions[selectedWarrantyIndex.value];

      // ✅ 2) Start payment and WAIT for success
      final RazorpayPaymentController paymentController =
          Get.isRegistered<RazorpayPaymentController>()
          ? Get.find<RazorpayPaymentController>()
          : Get.put(RazorpayPaymentController());

      final success = await paymentController
          .pay(
            amountRupees: selectedWarrantyOption.warrantyPriceAfterGst,
            name: "Get Warranty",
            description: "Warranty Purchase",
            email: userEmail,
            phone: userPhone,
            notes: {
              "userId": userId,
              "appointmentId": car.appointmentId,
              "warrantyCover": warrantyCover,
              "warrantyPeriod": warrantyPeriod,
              "warrantyIndex": selectedWarrantyIndex.value,
            },
            receipt: "warranty_${DateTime.now().millisecondsSinceEpoch}",
            userId: userId,
            meta: {"appointmentId": car.appointmentId, "carId": car.id},
          )
          .timeout(
            const Duration(minutes: 3),
            onTimeout: () {
              throw Exception("Payment timed out. Please try again.");
            },
          );

      // ✅ 3) Payment success => now call Sale API with paymentId
      final requestBody = {
        "carImageUrl": car.imageUrl,
        "appointmentId": car.appointmentId,

        // ✅ base + markup + gst
        "warrantyPrice": selectedWarrantyOption.warrantyPrice, // base
        "warrantyPriceAfterMarkup":
            selectedWarrantyOption.warrantyPriceAfterMarkup, // base + markup
        "warrantyPriceAfterGst": selectedWarrantyOption
            .warrantyPriceAfterGst, // final = base + markup + gst

        "markupPercentage": 20, // 20%
        "gstPercentage": 18, // 18%

        "paymentId": success.paymentId, // ✅ IMPORTANT
        "apiHitThrough": "Get Warranty",
        "userId": userId,
        "carId": car.id,

        "userName": "Otobix",
        "name": car.registeredOwner,
        "address": car.registeredAddressAsPerRc,
        "mobile": car.contactNumber,
        "email": car.emailAddress,

        // Third party expects DD-MM-YYYY, don't use iso string.
        "vehicleRegDate": car.registrationDate != null
            ? formatDdMmYyyy(car.registrationDate!)
            : "",

        "dealerName": "Otobix",
        "areaOffice": car.inspectionLocation,
        "chassisNo": car.chassisNumber,
        "engineNo": car.engineNumber,
        "make": car.make,
        "model": car.model,
        "warrantyCover": warrantyCover,
        "warrantyPeriod": warrantyPeriod,
        "vehicleCc": car.cubicCapacity,
        "regNo": car.registrationNumber,
        "odometer": car.odometerReadingInKms,

        "policyHolderName": car.registeredOwner,
        "fullBillingAddress": "",
      };

      final response = await ApiService.post(
        endpoint: AppUrls.ewiSaleApiForGetWarranty,
        body: requestBody,
      );

      // debugPrint(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = _safeJson(response.body);

        // your backend may return either:
        // 1) { pdf_url, pdf_file }
        // 2) { ewiResponse: { pdf_url, pdf_file } }
        // 3) { success: true, ewiResponse: {...} }
        final Map<String, dynamic> data =
            (json['ewiResponse'] is Map<String, dynamic>)
            ? Map<String, dynamic>.from(json['ewiResponse'])
            : json;

        final String pdfUrl = (data['pdf_url'] ?? '').toString();
        final String pdfFileName = (data['pdf_file'] ?? '').toString();
        // debugPrint("PDF Link: ${data['pdf_url'].toString()}");

        Get.back();
        final GetWarrantyCarsListController getWarrantyCarsListController =
            Get.isRegistered<GetWarrantyCarsListController>()
            ? Get.find<GetWarrantyCarsListController>()
            : Get.put(GetWarrantyCarsListController());
        getWarrantyCarsListController.filteredCarsList.clear();
        getWarrantyCarsListController.fetchCarsList();

        congratulationsDialog(
          userEmail: userEmail,
          pdfUrl: pdfUrl,
          pdfFileName: pdfFileName,
          alreadyExists: false,
        );
        // Log event
        UserActivityLogService.logEvent(
          userId: userId,
          event: AppConstants.userActivityLogEvents.warrantyPurchased,
          eventDetails: 'Successfully purchased warranty',
          metadata: {
            "carId": car.id,
            "appointmentId": car.appointmentId,
            "regNo": car.registrationNumber,
            "paymentId": success.paymentId,
            "make": car.make,
            "model": car.model,
            "warrantyCover": warrantyCover,
            "warrantyPeriod": warrantyPeriod,
            "warrantyPrice": selectedWarrantyOption.warrantyPrice,
            "warrantyPriceAfterMarkup":
                selectedWarrantyOption.warrantyPriceAfterMarkup,
            "warrantyPriceAfterGst":
                selectedWarrantyOption.warrantyPriceAfterGst,
          },
        );
      } else if (response.statusCode == 409) {
        Get.back();
        final GetWarrantyCarsListController getWarrantyCarsListController =
            Get.isRegistered<GetWarrantyCarsListController>()
            ? Get.find<GetWarrantyCarsListController>()
            : Get.put(GetWarrantyCarsListController());
        getWarrantyCarsListController.filteredCarsList.clear();
        getWarrantyCarsListController.fetchCarsList();
        congratulationsDialog(
          userEmail: userEmail,
          pdfUrl: '',
          pdfFileName: '',
          alreadyExists: true,
        );
      } else {
        errorDialog();
      }
    } catch (error) {
      debugPrint('Error Claiming Warranty: $error');
      errorDialog();
    } finally {
      isGetWarrantyLoading.value = false;
    }
  }

  // Show congratulations dialog
  congratulationsDialog({
    required String userEmail,
    required String pdfUrl,
    required String pdfFileName,
    required bool alreadyExists,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                !alreadyExists
                    ? "Congratulations!"
                    : "Warranty Already Created!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                !alreadyExists
                    ? "Your EWI Warranty has been issued and a notification will shortly be received on your registered email."
                    : "Your EWI Warranty is already issued for this vehicle. A notification has already been sent to your registered email.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.35,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Email: $userEmail",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 22),

              if (pdfUrl.isNotEmpty && pdfFileName.isNotEmpty)
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await downloadAndOpenPdf(
                          pdfUrl: pdfUrl,
                          fileName: pdfFileName,
                        );
                      },
                      child: const Text(
                        "Click here to view policy (PDF)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.blue,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ButtonWidget(
                text: 'Close',
                isLoading: false.obs,
                elevation: 5,
                // width: double.infinity,
                backgroundColor: AppColors.red,
                onTap: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Error Dialog
  errorDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Attention!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.red,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "An issue occurred while processing your claim. Please contact our support team.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.35,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Phone: +91 9088 822999",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 22),

              ButtonWidget(
                text: 'Close',
                isLoading: false.obs,
                elevation: 5,
                // width: double.infinity,
                backgroundColor: AppColors.red,
                onTap: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  String formatDdMmYyyy(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}";

  /// Handles cases where API returns html warnings before JSON
  Map<String, dynamic> _safeJson(String body) {
    try {
      return Map<String, dynamic>.from(jsonDecode(body));
    } catch (_) {
      // try to extract the first JSON object from the response
      final int start = body.indexOf('{');
      final int end = body.lastIndexOf('}');
      if (start != -1 && end != -1 && end > start) {
        final String jsonPart = body.substring(start, end + 1);
        return Map<String, dynamic>.from(jsonDecode(jsonPart));
      }
      return {};
    }
  }

  // Download and open PDF
  Future<void> downloadAndOpenPdf({
    required String pdfUrl,
    required String fileName,
  }) async {
    try {
      if (pdfUrl.trim().isEmpty) {
        ToastWidget.show(
          context: Get.context!,
          title: 'PDF Missing',
          subtitle: 'PDF link not found.',
          type: ToastType.error,
        );
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/$fileName";

      // If already downloaded, open directly
      if (File(filePath).existsSync()) {
        await OpenFilex.open(filePath);
        return;
      }

      final dio = Dio();
      await dio.download(
        pdfUrl,
        filePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
        ),
        onReceiveProgress: (received, total) {
          // Optional: you can store progress in RxDouble and show in UI
          // final progress = total > 0 ? received / total : 0.0;
        },
      );

      ToastWidget.show(
        context: Get.context!,
        title: 'Downloaded',
        subtitle: 'PDF saved successfully.',
        type: ToastType.success,
      );

      await OpenFilex.open(filePath);
    } catch (e) {
      debugPrint("PDF download error: $e");
      ToastWidget.show(
        context: Get.context!,
        title: 'Download Failed',
        subtitle: 'Unable to download PDF. Please try again.',
        type: ToastType.error,
      );
    }
  }
}
