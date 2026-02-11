import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/login_controller.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/views/home_page.dart.dart';
import 'package:otobix_customer_app/views/profile_page.dart';
import 'package:otobix_customer_app/views/login_page.dart';
import 'package:otobix_customer_app/views/under_development_page.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class BottomNavigationBarController extends GetxController {
  RxInt currentIndex = 0.obs;
  final RxBool isLoadingLogout = false.obs;

  List<Widget> get pages => [
    HomePage(),
    // UnderDevelopmentPage(
    //   screenName: "My Cars",
    //   icon: CupertinoIcons.car_detailed,
    //   color: AppColors.green,
    //   showAppBar: false,
    // ),
    // const UnderDevelopmentPage(
    //   screenName: "Cart",
    //   icon: CupertinoIcons.cart_fill,
    //   color: AppColors.grey,
    //   showAppBar: false,
    // ),
   
    ProfilePage(),
  ];

  // Logut function
  Future<void> logout() async {
    try {
      isLoadingLogout.value = true;
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
      isLoadingLogout.value = false;
    }
  }
}
