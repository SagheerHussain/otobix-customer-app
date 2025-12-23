import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/login_controller.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/services/notification_sevice.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/views/login_page.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';

class ProfileController extends GetxController {
  RxString imageUrl = ''.obs;
  RxString username = ''.obs;
  RxString useremail = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    try {
      isLoading.value = true;

      final token = await SharedPrefsHelper.getString(
        SharedPrefsHelper.tokenKey,
      );
      // debugPrint('Token: $token');

      if (token == null) {
        debugPrint('User not logged in');
        return;
      }

      final response = await ApiService.get(endpoint: AppUrls.getUserProfile);

      // debugPrint('API response: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['profile'];

        username.value = data['name'] ?? '';
        useremail.value = data['email'] ?? '';
      } else {
        debugPrint('Profile fetch failed: ${response.statusCode}');
        debugPrint(response.body);
      }
    } catch (e) {
      debugPrint('Error in getUserProfile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // logout
  Future<void> logout() async {
    try {
      isLoading.value = true;

      final userId = await SharedPrefsHelper.getString(
        SharedPrefsHelper.userIdKey,
      );
      if (userId == null) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'User ID not found',
          type: ToastType.error,
        );
        return;
      }

      final endpoint = AppUrls.logout(userId);
      final response = await ApiService.post(endpoint: endpoint, body: {});
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // unlink the device from the current user (call on sign-out)
        NotificationService.instance.logout();
        await SharedPrefsHelper.remove(SharedPrefsHelper.tokenKey);
        await SharedPrefsHelper.remove(SharedPrefsHelper.userKey);
        await SharedPrefsHelper.remove(SharedPrefsHelper.userTypeKey);
        await SharedPrefsHelper.remove(SharedPrefsHelper.userIdKey);

        ToastWidget.show(
          context: Get.context!,
          title: 'Logout successful',
          type: ToastType.success,
        );
        Get.delete<LoginController>();
        Get.offAll(() => LoginPage());
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Logout Failed',
          subtitle: data['message'] ?? 'Server error',
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint('Logout Exception: $e');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Something went wrong',
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
