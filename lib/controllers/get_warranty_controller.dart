import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/Models/cars_list_model.dart';
import 'package:otobix_customer_app/controllers/razorpay_payment_controller.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class GetWarrantyController extends GetxController {
  RxBool isGetWarrantyLoading = false.obs;

  // Warranty selection
  RxInt selectedWarrantyIndex = (-1).obs;

  void selectWarranty(int index) {
    selectedWarrantyIndex.value = index;
  }

  String warrantyCover = 'Will be provided'; // dummy for now
  String warrantyPeriod = 'Will be provided'; // dummy for now
  double paymentAmount = 2.0; // dummy for now

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

      // ✅ 2) Start payment and WAIT for success
      final RazorpayPaymentController paymentController =
          Get.isRegistered<RazorpayPaymentController>()
          ? Get.find<RazorpayPaymentController>()
          : Get.put(RazorpayPaymentController());

      final success = await paymentController
          .pay(
            amountRupees: paymentAmount,
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
        "warrantyPrice": paymentAmount,
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

      if (response.statusCode == 200) {
        // ✅ success after sale api
        congratulationsDialog(userEmail: userEmail);
      } else {
        // ✅ payment done but sale api failed
        errorDialog();
      }
    } catch (e) {
      // ✅ payment failed OR verification failed OR any error
      ToastWidget.show(
        context: Get.context!,
        title: "Failed",
        subtitle: e.toString().replaceAll("Exception: ", ""),
        type: ToastType.error,
      );
    } finally {
      isGetWarrantyLoading.value = false;
    }
  }
  // Future<void> submitGetWarranty1({required CarsListModel car}) async {
  //   if (isGetWarrantyLoading.value) return;

  //   isGetWarrantyLoading.value = true;
  //   try {
  //     final String userId =
  //         await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? "";

  //     final String userEmail =
  //         await SharedPrefsHelper.getString(SharedPrefsHelper.userEmailKey) ??
  //         "";

  //     final String userPhone =
  //         await SharedPrefsHelper.getString(
  //           SharedPrefsHelper.userPhoneNumberKey,
  //         ) ??
  //         "";

  //     // Stating payment api
  //     if (selectedWarrantyIndex.value == -1) {
  //       ToastWidget.show(
  //         context: Get.context!,
  //         title: 'Select Warranty Option',
  //         subtitle: 'Please select a warranty option to proceed.',
  //         type: ToastType.error,
  //       );
  //       return;
  //     }

  //     final RazorpayPaymentController razorpayPaymentController = Get.put(
  //       RazorpayPaymentController(),
  //     );

  //     razorpayPaymentController.onResultMessage = (msg) {
  //       // debugPrint(msg);
  //       ToastWidget.show(
  //         context: Get.context!,
  //         title: "Payment Result",
  //         subtitle: msg,
  //         type: msg.startsWith("✅") ? ToastType.success : ToastType.error,
  //       );
  //     };

  //     razorpayPaymentController.pay(
  //       amountRupees: paymentAmount,
  //       name: "Get Warranty", // Display name shown on Razorpay checkout sheet.
  //       description: "Warranty Purchase",
  //       email: userEmail,
  //       phone: userPhone,
  //       notes: {
  //         "userId": userId,
  //         "appointmentId": car.appointmentId,
  //         "warrantyCover": warrantyCover,
  //         "warrantyPeriod": warrantyPeriod,
  //         "warrantyIndex": selectedWarrantyIndex.value,
  //       },
  //       receipt: "warranty_${DateTime.now().millisecondsSinceEpoch}",
  //     );

  //     // Starting sale api
  //     final requestBody = {
  //       "carImageUrl": car.imageUrl,
  //       "appointmentId": car.appointmentId,
  //       "warrantyPrice": paymentAmount,
  //       "paymentId": "",
  //       "apiHitThrough": "Get Warranty",
  //       "userId": userId,
  //       "carId": car.id,

  //       "userName": "Otobix",
  //       "name": car.registeredOwner,
  //       "address": car.registeredAddressAsPerRc,
  //       "mobile": car.contactNumber,
  //       "email": car.emailAddress,

  //       "vehicleRegDate": car.registrationDate?.toIso8601String() ?? "",
  //       "dealerName": "Otobix",
  //       "areaOffice": car.inspectionLocation,
  //       "chassisNo": car.chassisNumber,
  //       "engineNo": car.engineNumber,
  //       "make": car.make,
  //       "model": car.model,
  //       "warrantyCover": warrantyCover,
  //       "warrantyPeriod": warrantyPeriod,
  //       "vehicleCc": car.cubicCapacity,
  //       "regNo": car.registrationNumber,
  //       "odometer": car.odometerReadingInKms,

  //       "policyHolderName": car.registeredOwner,
  //       "fullBillingAddress": "",
  //     };

  //     final response = await ApiService.post(
  //       endpoint: AppUrls.ewiSaleApi,
  //       body: requestBody,
  //     );

  //     if (response.statusCode == 200) {
  //       Get.back();
  //       congratulationsDialog(userEmail: userEmail);
  //     } else {
  //       Get.back();
  //       errorDialog();
  //     }
  //   } catch (error) {
  //     debugPrint('Error loading cars: $error');
  //     Get.back();
  //     errorDialog();
  //   } finally {
  //     isGetWarrantyLoading.value = false;
  //   }
  // }

  // Show congratulations dialog
  congratulationsDialog({required String userEmail}) {
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
                onTap: () {
                  // TODO: open PDF link
                },
                child: const Text(
                  "Click here to view policy (PDF)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue,
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
}
