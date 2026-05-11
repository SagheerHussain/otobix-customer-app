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
import 'package:otobix_customer_app/views/login_pin_code_page.dart';
import 'package:otobix_customer_app/views/waiting_for_approval_page.dart';

import 'package:otobix_customer_app/widgets/toast_widget.dart';

class LoginController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    clearFields();
  }

  // Loaders
  RxBool isSendOtpLoading = false.obs;
  RxBool isVerifyOtpLoading = false.obs;
  RxBool isLoading = false.obs;
  RxBool obsecureText = true.obs;

  final userNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  // WhatsApp consent variable
  RxBool whatsappConsent = true.obs;

  // Method to update consent
  void updateWhatsappConsent(bool value) {
    whatsappConsent.value = value;
  }

  Future<void> loginUser() async {
    isLoading.value = true;
    try {
      String dealerName = userNameController.text.trim();
      String contactNumber = phoneNumberController.text.trim();
      final requestBody = {
        "userName": dealerName,
        "phoneNumber": contactNumber,
        "password": passwordController.text.trim(),
      };

      final response = await ApiService.post(
        endpoint: AppUrls.login,
        body: requestBody,
      );
      final data = jsonDecode(response.body);
      // debugPrint("Status Code: ${response.statusCode}");
      if (response.statusCode == 200) {
        final token = data['token'];
        final user = data['user'];
        final userType = user['userType'];
        final userId = user['id'];
        final userName = user['userName'];
        final phoneNumber = user['phoneNumber'];
        final email = user['email'];
        final approvalStatus = user['approvalStatus'];
        final entityType = user['entityType'] ?? "";
        // debugPrint("userType: $userType");
        // debugPrint("token: $token");
        // debugPrint("approvalStatus: $approvalStatus");

        // Link current userid in OneSignal to receive push notifications
        await NotificationService.instance.login(userId);

        if (userType != AppConstants.roles.customer) {
          ToastWidget.show(
            context: Get.context!,
            title: "No account found for this user.",
            type: ToastType.error,
          );
          return;
        }

        if (approvalStatus == 'Pending') {
          ToastWidget.show(
            context: Get.context!,
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

        if (approvalStatus == 'Rejected') {
          ToastWidget.show(
            context: Get.context!,
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

        if (approvalStatus == 'Approved') {
          await SharedPrefsHelper.saveString(SharedPrefsHelper.tokenKey, token);
        }

        // debugPrint("Token saved in local: $token");
        await SharedPrefsHelper.saveString(
          SharedPrefsHelper.userKey,
          jsonEncode(user),
        );
        await SharedPrefsHelper.saveString(
          SharedPrefsHelper.userRoleKey,
          userType,
        );
        await SharedPrefsHelper.saveString(SharedPrefsHelper.userIdKey, userId);
        await SharedPrefsHelper.saveString(
          SharedPrefsHelper.userNameKey,
          userName,
        );
        await SharedPrefsHelper.saveString(
          SharedPrefsHelper.userPhoneNumberKey,
          phoneNumber,
        );
        await SharedPrefsHelper.saveString(
          SharedPrefsHelper.userEmailKey,
          email,
        );
        await SharedPrefsHelper.saveString(
          SharedPrefsHelper.entityTypeKey,
          entityType,
        );
        // debugPrint("userId: $userId");
        if (userType == AppConstants.roles.admin) {
          // Get.offAll(() => AdminDashboard());
        } else {
          if (approvalStatus == 'Pending') {
            final entityType = (user['entityType'] as String?)?.trim();
            final entityDocuments = await _fetchEntityDocuments(entityType);
            Get.to(
              () => WaitingForApprovalPage(
                documents: entityDocuments,
                userRole: userType,
              ),
            );
          } else if (approvalStatus == 'Approved') {
            if (userType == AppConstants.roles.customer) {
              Get.offAll(() => BottomNavigationBarPage());

              // Log event
              UserActivityLogService.logEvent(
                userId: userId,
                event: AppConstants.userActivityLogEvents.login,
                eventDetails: 'Logged in successfully',
                metadata: {'approvalStatus': approvalStatus},
              );
            } else if (userType == AppConstants.roles.salesManager) {
              // Get.offAll(() => SalesManagerHomepage());
            } else if (userType == AppConstants.roles.dealer) {
              // Get.offAll(() => BottomNavigationPage());
            }
          } else if (approvalStatus == 'Rejected') {
            // Get.to(() => RejectedScreen(userId: user['id']));
          } else {
            ToastWidget.show(
              context: Get.context!,
              title: "Invalid approval status. Please contact admin.",
              type: ToastType.error,
            );
          }
        }
      } else {
        debugPrint("data: $data");
        ToastWidget.show(
          context: Get.context!,
          title: data['message'] ?? "Invalid credentials",
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
      ToastWidget.show(
        context: Get.context!,
        title: "Something went wrong. Please try again.",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? validatePassword(String password) {
    if (password.isEmpty) return "Password is required.";
    if (password.length < 8) {
      return "Password must be at least 8 characters long.";
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "At least one uppercase letter required.";
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return "At least one lowercase letter required.";
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]').hasMatch(password)) {
      return "At least one special character required.";
    }
    return null;
  }

  // Fetch entity documents
  Future<List<String>> _fetchEntityDocuments(String? entityType) async {
    final fallback = <String>[
      // optional: keep empty list if you don't want a fallback
      'No documents found',
    ];

    if (entityType == null || entityType.trim().isEmpty) return fallback;

    try {
      final response = await ApiService.get(
        endpoint: AppUrls.getEntityDocumentsByName(
          entityName: entityType.trim(),
        ),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final data = (json['data'] ?? {}) as Map<String, dynamic>;
        final docs = (data['documents'] ?? []) as List;
        return docs.map((e) => '$e').toList();
      }
    } catch (error) {
      // ignore and use fallback
      debugPrint("Error: $error");
    }
    return fallback;
  }

  // Send OTP
  Future<void> sendOTP() async {
    isSendOtpLoading.value = true;
    try {
      final phoneNumber = phoneNumberController.text.trim();

      if (phoneNumber == '6666666666') {
        Get.to(
          () => LoginPinCodePage(
            requestId: 'test-request-id',
            phoneNumber: phoneNumber,
            whatsappConsent: whatsappConsent.value,
          ),
        );
        ToastWidget.show(
          context: Get.context!,
          title: "OTP Sent Successfully",
          type: ToastType.success,
        );
        return;
      }

      // For indian numbers only
      final RegExp indianRegex = RegExp(r'^[6-9]\d{9}$');

      if (!indianRegex.hasMatch(phoneNumber)) {
        ToastWidget.show(
          context: Get.context!,
          title: "Invalid mobile number",
          subtitle:
              "Please enter a valid indian mobile number (starts with 6-9)",
          type: ToastType.error,
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
          Get.to(
            () => LoginPinCodePage(
              requestId: requestId,
              phoneNumber: phoneNumber,
              whatsappConsent: whatsappConsent.value,
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

  // Clear fields
  void clearFields() {
    userNameController.clear();
    phoneNumberController.clear();
    passwordController.clear();
    obsecureText.value = true;
  }
}
