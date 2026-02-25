import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:otobix_customer_app/Models/cars_list_model.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';
import 'package:path_provider/path_provider.dart';

class ClaimRsaController extends GetxController {
  RxBool isClaimRsaLoading = false.obs;

  // Text Controllers
  final TextEditingController policyHolderNameCtrl = TextEditingController();
  final TextEditingController billingAddressCtrl = TextEditingController();

  String warrantyCover = ''; // not necessary for RSA
  String warrantyPeriod = ''; // not necessary for RSA

  // Request Extended Warranty (ewi) using RSA
  Future<void> submitRsa({required CarsListModel car}) async {
    if (isClaimRsaLoading.value) return;

    if (billingAddressCtrl.text.trim().isEmpty) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Billing Address Required',
        subtitle: 'Please enter billing address in the field',
        type: ToastType.error,
      );
      return;
    }

    isClaimRsaLoading.value = true;
    try {
      final String userId =
          await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? "";

      final String userEmail =
          await SharedPrefsHelper.getString(SharedPrefsHelper.userEmailKey) ??
          "";

      final requestBody = {
        "carImageUrl": car.imageUrl,
        "appointmentId": car.appointmentId,
        "warrantyPrice": 0,
        "paymentId": "",
        "apiHitThrough": "Claim RSA",
        "userId": userId,
        "carId": car.id,

        "userName": "Otobix",
        "name": car.registeredOwner,
        "address": car.registeredAddressAsPerRc,
        "mobile": car.contactNumber,
        "email": car.emailAddress,

        "vehicleRegDate": car.registrationDate != null
            ? formatDdMmYyyy(car.registrationDate!)
            : "",
        "dealerName": "Otobix",
        "areaOffice": car.inspectionLocation,
        // "chassisNo": car.chassisNumber,
        "chassisNo": "6",
        "engineNo": car.engineNumber,
        "make": car.make,
        "model": car.model,
        "warrantyCover": warrantyCover,
        "warrantyPeriod": warrantyPeriod,
        "vehicleCc": car.cubicCapacity,
        // "regNo": car.registrationNumber,
        "regNo": "DL01AB1242",
        "odometer": car.odometerReadingInKms,

        "policyHolderName": policyHolderNameCtrl.text.trim(),
        "fullBillingAddress": billingAddressCtrl.text.trim(),
        "warrantySaleDate": car.registrationDate != null
            ? formatDdMmYyyy(DateTime.now())
            : "",
      };

      final response = await ApiService.post(
        endpoint: AppUrls.ewiSaleApiForRSA,
        body: requestBody,
      );
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = _safeJson(response.body);

        debugPrint("Response Data: ${json.toString()}");

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

        if (pdfUrl.isNotEmpty && pdfFileName.isNotEmpty) {
          // Get.back();
          congratulationsDialog(
            userEmail: userEmail,
            pdfUrl: pdfUrl,
            pdfFileName: pdfFileName,
          );
        } else {
          // Get.back();
          errorDialog();
        }
      } else {
        // Get.back();
        errorDialog();
      }
    } catch (error) {
      debugPrint('Error loading cars: $error');
      // Get.back();
      errorDialog();
    } finally {
      isClaimRsaLoading.value = false;
    }
  }

  // Show congratulations dialog
  congratulationsDialog({
    required String userEmail,
    required String pdfUrl,
    required String pdfFileName,
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
              const Text(
                "Congratulations!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "Your EWI RSA has been\nissued and a notification will\nshortly be received on your\nregistered email.",
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
                "Phone: +91 9830 300300",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 22),

              // GestureDetector(
              //   onTap: () {
              //     // TODO: open PDF link
              //   },
              //   child: const Text(
              //     "Click here to view policy (PDF)",
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       fontSize: 13,
              //       color: Colors.blue,
              //       // decoration: TextDecoration.underline,
              //     ),
              //   ),
              // ),

              // const SizedBox(height: 28),
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

  @override
  void onClose() {
    policyHolderNameCtrl.dispose();
    billingAddressCtrl.dispose();
    super.onClose();
  }
}
