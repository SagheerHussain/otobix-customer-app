import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/services/notification_sevice.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/services/user_activity_log_service.dart';
import 'package:otobix_customer_app/utils/app_constants.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/views/bottom_navigation_bar_page.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class LoginPinCodeController extends GetxController {
  // Loaders
  RxBool isLoading = false.obs;

  // Send OTP
  Future<void> verifyOtp({
    required String requestId,
    required String otp,
    required String phoneNumber,
    bool? whatsappConsent,
  }) async {
    isLoading.value = true;
    try {
      final response = await ApiService.post(
        endpoint: AppUrls.loginOrRegisterUsingOtp,
        body: {
          "requestId": requestId,
          "otp": otp,
          "userRole": AppConstants.roles.customer,
          "testPhoneNumber": phoneNumber,
          if (whatsappConsent != null) "whatsappConsent": whatsappConsent,
        },
      );

      final data = jsonDecode(response.body);
      // debugPrint("Data: $data");

      if (response.statusCode == 409) {
        ToastWidget.show(
          context: Get.context!,
          toastDuration: 10,
          title: "User Already Exists",
          subtitle:
              "An account already exists with this phone number, Please try another number.",
          type: ToastType.error,
        );
        return;
      }

      if (response.statusCode == 200) {
        final String internalStatusCode = data['statusCode']?.toString() ?? '';

        if (internalStatusCode == "101") {
          final String token = data['token'];
          final Map<String, dynamic> user = data['user'];

          // ✅ OTP verified successfully
          // ToastWidget.show(
          //   context: Get.context!,
          //   title: "OTP Verified Successfully",
          //   type: ToastType.success,
          // );
          await _loginUser(token: token, user: user);
        } else if (internalStatusCode == "102") {
          // ❌ Invalid OTP
          ToastWidget.show(
            context: Get.context!,
            toastDuration: 5,
            title: "Invalid OTP",
            subtitle: "The OTP you entered is incorrect.",
            type: ToastType.error,
          );
        } else if (internalStatusCode == "104") {
          // ❌ Retry limit exceeded
          ToastWidget.show(
            context: Get.context!,
            toastDuration: 5,
            title: "Retry Limit Exceeded",
            subtitle: "You have exceeded the maximum verification attempts.",
            type: ToastType.error,
          );
        } else {
          // ❌ Unknown internal code
          ToastWidget.show(
            context: Get.context!,
            toastDuration: 5,
            title: "Verification Failed",
            subtitle: "Unexpected response code: $internalStatusCode",
            type: ToastType.error,
          );
        }
      } else {
        debugPrint(response.body);
        ToastWidget.show(
          context: Get.context!,
          toastDuration: 5,
          title: "Failed to verify OTP",
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      ToastWidget.show(
        context: Get.context!,
        toastDuration: 5,
        title: "Error Verifying OTP",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Login user helper
  Future<void> _loginUser({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    // isLoginLoading.value = true;
    try {
      final String userId = user['id'];
      final String userRole = user['userRole'];
      final String userName = user['userName'];
      final String phoneNumber = user['phoneNumber'];
      final String email = user['email'];
      final String approvalStatus = user['approvalStatus'];

      // Link current userid in OneSignal to receive push notifications
      await NotificationService.instance.login(userId);

      // Check if not customer
      if (userRole != AppConstants.roles.customer) {
        ToastWidget.show(
          context: Get.context!,
          toastDuration: 5,
          title: "No account found for this user.",
          type: ToastType.error,
        );
        return;
      }

      // Check if pending
      if (approvalStatus == 'Pending') {
        ToastWidget.show(
          context: Get.context!,
          toastDuration: 5,
          title: "Your Account is Pending Approval.",
          type: ToastType.warning,
        );

        // Log event
        UserActivityLogService.logEvent(
          userId: userId,
          event: AppConstants.userActivityLogEvents.login,
          eventDetails: 'User status was pending',
          metadata: {'approvalStatus': approvalStatus},
        );

        return;
      }

      // Check if rejected
      if (approvalStatus == 'Rejected') {
        ToastWidget.show(
          context: Get.context!,
          toastDuration: 5,
          title: "Your Account did not get approved.",
          type: ToastType.error,
        );
        // Log event
        UserActivityLogService.logEvent(
          userId: userId,
          event: AppConstants.userActivityLogEvents.login,
          eventDetails: 'User status was rejected',
          metadata: {'approvalStatus': approvalStatus},
        );

        return;
      }

      // 🟢 Check if approved
      if (approvalStatus == 'Approved') {
        await SharedPrefsHelper.saveString(SharedPrefsHelper.tokenKey, token);
      }

      // Save user data in shared prefs
      await SharedPrefsHelper.saveString(
        SharedPrefsHelper.userKey,
        jsonEncode(user),
      );
      await SharedPrefsHelper.saveString(SharedPrefsHelper.userIdKey, userId);
      await SharedPrefsHelper.saveString(
        SharedPrefsHelper.userRoleKey,
        userRole,
      );
      await SharedPrefsHelper.saveString(
        SharedPrefsHelper.userNameKey,
        userName,
      );
      await SharedPrefsHelper.saveString(
        SharedPrefsHelper.userPhoneNumberKey,
        phoneNumber,
      );
      await SharedPrefsHelper.saveString(SharedPrefsHelper.userEmailKey, email);

      // Navigate to homepage
      Get.offAll(() => BottomNavigationBarPage());

      // Log event
      UserActivityLogService.logEvent(
        userId: userId,
        event: AppConstants.userActivityLogEvents.login,
        eventDetails: 'Logged in successfully',
        metadata: {'approvalStatus': approvalStatus},
      );
    } catch (e) {
      debugPrint("Error: $e");
      ToastWidget.show(
        context: Get.context!,
        toastDuration: 5,
        title: "Something went wrong. Please try again.",
        type: ToastType.error,
      );
    } finally {
      // isLoginLoading.value = false;
    }
  }
}
