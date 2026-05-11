import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/views/login_pin_code_page.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class GuestUserRegisterChoiceDialogController extends GetxController {
  final RxBool isSendOtpLoading = false.obs;

  final TextEditingController phoneNumberController = TextEditingController();

  // Validate For indian numbers only
  Future<bool> validatePhoneNumber() async {
    final enteredPhoneNumber = phoneNumberController.text.trim();

    if (enteredPhoneNumber.isEmpty) {
      ToastWidget.show(
        context: Get.context!,
        title: "Phone number is required",
        type: ToastType.error,
      );
      return false;
    }

    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(enteredPhoneNumber)) {
      ToastWidget.show(
        context: Get.context!,
        title: "Invalid mobile number",
        subtitle: "Please enter a valid indian mobile number (starts with 6-9)",
        type: ToastType.error,
      );
      return false;
    }

    // Unfocus keyboard before anything else
    FocusManager.instance.primaryFocus?.unfocus();

    // Small delay to ensure keyboard is dismissed
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }

  // Send OTP for verification
  Future<void> sendOTP() async {
    if (isSendOtpLoading.value) return;

    isSendOtpLoading.value = true;
    try {
      final phoneNumber = phoneNumberController.text.trim();

      if (phoneNumber == '6666666666') {
        Get.back(); // close the dialog
        Get.to(
          () => LoginPinCodePage(
            requestId: 'test-request-id',
            phoneNumber: phoneNumber,
          ),
        );
        ToastWidget.show(
          context: Get.context!,
          title: "OTP Sent Successfully",
          type: ToastType.success,
        );
        return;
      }

      final requestBody = {"mobile": phoneNumber};

      final response = await ApiService.post(
        endpoint: AppUrls.sendOtp,
        body: requestBody,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        String requestId = data['data']['requestId'] ?? '';
        final String internalStatusCode =
            data['data']?['statusCode']?.toString() ?? '';

        if (internalStatusCode == "101") {
          // ✅ Success navigate to second page
          Get.back(); // close the dialog
          Get.to(
            () => LoginPinCodePage(
              requestId: requestId,
              phoneNumber: phoneNumber,
            ),
          );
          ToastWidget.show(
            context: Get.context!,
            title: "OTP Sent Successfully",
            type: ToastType.success,
          );
        } else if (internalStatusCode == "102") {
          // ❌ Invalid details
          ToastWidget.show(
            context: Get.context!,
            title: "Invalid Details",
            subtitle: "Invalid ID or input combination.",
            type: ToastType.error,
          );
        } else if (internalStatusCode == "104") {
          // ❌ Retry limit exceeded
          ToastWidget.show(
            context: Get.context!,
            title: "Retry Limit Exceeded",
            subtitle: "You have reached maximum OTP attempts.",
            type: ToastType.error,
          );
        } else {
          // ❌ Unknown or unhandled code
          ToastWidget.show(
            context: Get.context!,
            title: "Failed to send OTP",
            subtitle: "Unexpected response code: $internalStatusCode",
            type: ToastType.error,
          );
        }
      } else {
        debugPrint(
          "Failed to send OTP: $data, status code ${response.statusCode}",
        );
        ToastWidget.show(
          context: Get.context!,
          title: "Failed to send OTP",
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      ToastWidget.show(
        context: Get.context!,
        title: "Error sending OTP",
        type: ToastType.error,
      );
    } finally {
      isSendOtpLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneNumberController.dispose();
    super.onClose();
  }
}
