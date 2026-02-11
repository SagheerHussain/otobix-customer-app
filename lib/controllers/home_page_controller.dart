import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/Models/home_nav_item.dart';
import 'package:otobix_customer_app/Models/sell_my_car_banners_model.dart';
import 'package:otobix_customer_app/controllers/login_controller.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_constants.dart';
import 'package:otobix_customer_app/utils/app_icons.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/views/buy_a_car_page.dart';
import 'package:otobix_customer_app/views/finance_page.dart';
import 'package:otobix_customer_app/views/insurance_page.dart';
import 'package:otobix_customer_app/views/login_page.dart';
import 'package:otobix_customer_app/views/my_auctions_page.dart';
import 'package:otobix_customer_app/views/pdi_page.dart';
import 'package:otobix_customer_app/views/sell_my_car_page.dart';
import 'package:otobix_customer_app/views/under_development_page.dart';
import 'package:otobix_customer_app/views/warranty_page.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class HomePageController extends GetxController {
  final RxBool isLoadingLogout = false.obs;
  final RxBool isBannersLoading = false.obs;
  final RxString userName = ''.obs;

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Search
  // final TextEditingController searchController = TextEditingController();
  // final RxString searchQuery = ''.obs;

  Future<void> loadUserName() async {
    final name = await SharedPrefsHelper.getString(
      SharedPrefsHelper.userNameKey,
    );
    userName.value = name ?? 'User';
  }

  // Banners
  final headerBannersList = <SellMyCarBannersModel>[].obs;
  final footerBannersList = <SellMyCarBannersModel>[].obs;

  final FocusNode searchFocusNode = FocusNode();
  final RxBool isSearchFocused = false.obs;

  @override
  void onInit() {
    searchFocusNode.addListener(() {
      isSearchFocused.value = searchFocusNode.hasFocus;
    });
    loadUserName();
    _fetchBannersList();
    super.onInit();
  }

  // Load Banners list
  Future<void> _fetchBannersList() async {
    isBannersLoading.value = true;
    try {
      final response = await ApiService.post(
        endpoint: AppUrls.fetchCarBannersList,
        body: {'view': AppConstants.bannerViews.home},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final List<dynamic> dataList = decoded['data'] as List<dynamic>;

        // If the backend sends { type: 'Header' | 'Footer' }
        final headerBannerMaps = dataList
            .where(
              (banner) =>
                  banner['type'] == AppConstants.bannerTypes.header &&
                  banner['status'] == AppConstants.bannerStatus.active,
            )
            .cast<Map<String, dynamic>>()
            .toList();

        final footerBannerMaps = dataList
            .where(
              (banner) =>
                  banner['type'] == AppConstants.bannerTypes.footer &&
                  banner['status'] == AppConstants.bannerStatus.active,
            )
            .cast<Map<String, dynamic>>()
            .toList();

        // Map to your model and assign to RxLists
        headerBannersList.assignAll(
          headerBannerMaps
              .map(
                (banner) => SellMyCarBannersModel.fromJson(
                  documentId: banner['_id'],
                  json: banner,
                ),
              )
              .toList(),
        );

        footerBannersList.assignAll(
          footerBannerMaps
              .map(
                (banner) => SellMyCarBannersModel.fromJson(
                  documentId: banner['_id'],
                  json: banner,
                ),
              )
              .toList(),
        );
      } else {
        debugPrint('Failed to load banners: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error loading banners: $error');
    } finally {
      isBannersLoading.value = false;
    }
  }

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
        await SharedPrefsHelper.remove(SharedPrefsHelper.userPhoneNumberKey);

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

  // ✅ One source of truth for home navigation items
  late final List<HomeNavItem> navItems = [
    HomeNavItem(
      icon: AppIcons.sellMyCar,
      title: 'Sell My Car',
      subtitle: 'List your car for auction',
      pageBuilder: () => SellMyCarPage(),
    ),
    HomeNavItem(
      icon: AppIcons.viewMyAuctions,
      title: 'View My Auctions',
      subtitle: 'Track bids and offers',
      pageBuilder: () => MyAuctionsPage(),
    ),
    HomeNavItem(
      icon: AppIcons.buyACar,
      title: 'Buy A Car',
      subtitle: 'Browse cars & place bids',
      pageBuilder: () => BuyACarPage(),
    ),
    // HomeNavItem(
    //   icon: AppIcons.insurance,
    //   title: 'Insurance',
    //   subtitle: 'Get coverage options',
    //   pageBuilder: () => InsurancePage(),
    // ),
    // HomeNavItem(
    //   icon: AppIcons.finance,
    //   title: 'Finance',
    //   subtitle: 'Explore installment plans',
    //   pageBuilder: () => FinancePage(),
    // ),
    // HomeNavItem(
    //   icon: AppIcons.warranty,
    //   title: 'Warranty',
    //   subtitle: 'Protect your purchase',
    //   pageBuilder: () => WarrantyPage(),
    // ),
    // HomeNavItem(
    //   icon: AppIcons.pdi,
    //   title: 'PDI',
    //   subtitle: 'Vehicle inspection service',
    //   pageBuilder: () => PdiPage(),
    // ),
    // HomeNavItem(
    //   icon: AppIcons.manageMyCars,
    //   title: 'Manage My Cars',
    //   subtitle: 'Manage your listings',
    //   pageBuilder: () => UnderDevelopmentPage(
    //     screenName: "Manage My Cars",
    //     icon: CupertinoIcons.car,
    //     color: AppColors.green,
    //   ),
    // ),
    // HomeNavItem(
    //   icon: AppIcons.referAndEarn,
    //   title: 'Refer and Earn',
    //   subtitle: 'Invite friends & earn rewards',
    //   pageBuilder: () => UnderDevelopmentPage(
    //     screenName: "Refer and Earn",
    //     icon: CupertinoIcons.checkmark_shield,
    //     color: AppColors.blue,
    //   ),
    // ),
  ];

  // ✅ Filtered results (title + subtitle)
  List<HomeNavItem> get filteredNavItems {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return navItems;
    return navItems.where((item) {
      return item.title.toLowerCase().contains(q) ||
          item.subtitle.toLowerCase().contains(q);
    }).toList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value.toLowerCase();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  void openNavItem(HomeNavItem item) {
    Get.to(() => item.pageBuilder());
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
