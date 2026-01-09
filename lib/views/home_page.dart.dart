import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/controllers/home_page_controller.dart';
import 'package:otobix_customer_app/utils/app_constants.dart';
import 'package:otobix_customer_app/utils/app_icons.dart';
import 'package:otobix_customer_app/views/buy_a_car_page.dart';
import 'package:otobix_customer_app/views/finance_page.dart';
import 'package:otobix_customer_app/views/insurance_page.dart';
import 'package:otobix_customer_app/views/my_auctions_page.dart';
import 'package:otobix_customer_app/views/pdi_page.dart';
import 'package:otobix_customer_app/views/sell_my_car_page.dart';
import 'package:otobix_customer_app/views/under_development_page.dart';
import 'package:otobix_customer_app/views/warranty_page.dart';
import 'package:otobix_customer_app/widgets/home_banners_widgets.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomePageController homeController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 10),
                  Flexible(child: _buildSearchBar(context)),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.notifications, color: AppColors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // TOP header banners
                    Obx(() {
                      final banners = homeController.headerBannersList;

                      if (banners.isEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.width * 0.563,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.green,
                            ),
                          ),
                        );
                      }

                      final imageUrls = banners.map((b) => b.imageUrl).toList();

                      return HomeBannersWidget(
                        imageUrls: imageUrls,
                        height:
                            MediaQuery.of(context).size.width *
                            0.563, // whatever height you like
                        displayDuration: const Duration(seconds: 2),
                        onTap: (index) {
                          final banner = banners[index];
                          debugPrint('Banner tapped: ${banner.screenName}');
                          // here you can navigate based on banner.screenName, etc.
                          _navigateToScreenOnBannerTap(banner.screenName);
                        },
                      );
                    }),

                    const SizedBox(height: 30),

                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Services',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width / 25,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blue,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildNavigationItem(
                                // Sell My Car
                                icon: AppIcons.sellMyCar,
                                title: 'Sell My Car',
                                onTap: () => Get.to(() => SellMyCarPage()),
                              ),
                              const SizedBox(width: 10),
                              _buildNavigationItem(
                                // View My Auctions
                                icon: AppIcons.viewMyAuctions,
                                title: 'View My Auctions',
                                onTap: () => Get.to(() => MyAuctionsPage()),
                              ),
                              const SizedBox(width: 10),
                              _buildNavigationItem(
                                // Buy A Car
                                icon: AppIcons.buyACar,
                                title: 'Buy A Car',
                                onTap: () => Get.to(() => BuyACarPage()),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildNavigationItem(
                                // Insurance
                                icon: AppIcons.insurance,

                                title: 'Insurance',
                                onTap: () => Get.to(() => InsurancePage()),
                              ),
                              const SizedBox(width: 10),
                              _buildNavigationItem(
                                // Finance
                                icon: AppIcons.finance,
                                title: 'Finance',
                                onTap: () => Get.to(() => FinancePage()),
                              ),
                              const SizedBox(width: 10),
                              _buildNavigationItem(
                                // Warranty
                                icon: AppIcons.warranty,

                                title: 'Warranty',
                                onTap: () => Get.to(() => WarrantyPage()),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildNavigationItem(
                                // PDI
                                icon: AppIcons.pdi,
                                title: 'PDI',
                                onTap: () => Get.to(() => PdiPage()),
                                // onTap: () => Get.to(
                                //   () => UnderDevelopmentPage(
                                //     screenName: "PDI",
                                //     icon: CupertinoIcons.car,
                                //     color: AppColors.red,
                                //   ),
                                // ),
                              ),
                              const SizedBox(width: 10),
                              _buildNavigationItem(
                                // Manage My Cars
                                icon: AppIcons.manageMyCars,
                                title: 'Manage My Cars',
                                onTap: () => Get.to(
                                  () => UnderDevelopmentPage(
                                    screenName: "Manage My Cars",
                                    icon: CupertinoIcons.car,
                                    color: AppColors.green,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              _buildNavigationItem(
                                // Refer and Earn
                                icon: AppIcons.referAndEarn,

                                title: 'Refer and Earn',
                                onTap: () => Get.to(
                                  () => UnderDevelopmentPage(
                                    screenName: "Refer and Earn",
                                    icon: CupertinoIcons.checkmark_shield,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build navigation item
  Widget _buildNavigationItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final double width = MediaQuery.of(Get.context!).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(icon, color: AppColors.grey, size: 50),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.grey.withValues(alpha: 0.2),
              ),

              child: SvgPicture.asset(icon, height: 50, width: 50),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: width / 40,
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Navigate to screen on banner tap
  void _navigateToScreenOnBannerTap(String? screenName) {
    final name = (screenName ?? '').trim().toLowerCase();

    final routes = <String, Widget Function()>{
      AppConstants.bannerScreenNames.buyACar.toLowerCase(): () => BuyACarPage(),
      AppConstants.bannerScreenNames.sellYourCar.toLowerCase(): () =>
          SellMyCarPage(),
      AppConstants.bannerScreenNames.warranty.toLowerCase(): () =>
          WarrantyPage(),
      AppConstants.bannerScreenNames.finance.toLowerCase(): () => FinancePage(),
      AppConstants.bannerScreenNames.insurance.toLowerCase(): () =>
          InsurancePage(),
    };

    final builder = routes[name];

    if (builder != null) {
      Get.to(builder);
      return;
    }

    // Default fallback
    // Get.to(
    //   () => UnderDevelopmentPage(
    //     screenName: screenName ?? 'Coming Soon',
    //     icon: CupertinoIcons.square_grid_2x2,
    //     color: AppColors.grey,
    //   ),
    // );
  }

  // Search Bar
  Widget _buildSearchBar(BuildContext context) {
    return SizedBox(
      height: 35,
      child: TextFormField(
        controller: homeController.searchController,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 12),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search by Brand, Model or Keywords...',
          hintStyle: TextStyle(
            color: AppColors.grey.withValues(alpha: .5),
            fontSize: 12,
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.grey, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: AppColors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: AppColors.green, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 10,
          ),
        ),
        onChanged: (value) {
          homeController.searchQuery.value = value.toLowerCase();
        },
      ),
    );
  }
}
