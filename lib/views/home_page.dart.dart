import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/controllers/home_page_controller.dart';
import 'package:otobix_customer_app/utils/app_icons.dart';
import 'package:otobix_customer_app/views/my_auctions_page.dart';
import 'package:otobix_customer_app/views/sell_my_car_page.dart';
import 'package:otobix_customer_app/views/under_development_page.dart';
import 'package:otobix_customer_app/widgets/home_banners_widgets.dart';
import 'package:otobix_customer_app/widgets/images_scroll_widget.dart';

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
                  IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // TOP header banners
            Obx(() {
              final banners = homeController.headerBannersList;

              if (banners.isEmpty) {
                return const SizedBox.shrink();
              }

              final imageUrls = banners.map((b) => b.imageUrl).toList();

              return HomeBannersWidget(
                imageUrls: imageUrls,
                height:
                    MediaQuery.of(context).size.width /
                    2, // whatever height you like
                displayDuration: const Duration(seconds: 2),
                onTap: (index) {
                  final banner = banners[index];
                  debugPrint('Banner tapped: ${banner.screenName}');
                  // here you can navigate based on banner.screenName, etc.
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
                        onTap: () => Get.to(
                          () => UnderDevelopmentPage(
                            screenName: "Buy A Car",
                            icon: CupertinoIcons.cart_fill,
                            color: AppColors.deepOrange,
                          ),
                        ),
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
                        onTap: () => Get.to(
                          () => UnderDevelopmentPage(
                            screenName: "Insurance",
                            icon: CupertinoIcons.shield_lefthalf_fill,
                            color: AppColors.red,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildNavigationItem(
                        // Finance
                        icon: AppIcons.finance,
                        title: 'Finance',
                        onTap: () => Get.to(
                          () => UnderDevelopmentPage(
                            screenName: "Finance",
                            icon: CupertinoIcons.money_dollar_circle,
                            color: AppColors.green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildNavigationItem(
                        // Warranty
                        icon: AppIcons.warranty,

                        title: 'Warranty',
                        onTap: () => Get.to(
                          () => UnderDevelopmentPage(
                            screenName: "Warranty",
                            icon: CupertinoIcons.checkmark_shield,
                            color: AppColors.blue,
                          ),
                        ),
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
                        onTap: () => Get.to(
                          () => UnderDevelopmentPage(
                            screenName: "PDI",
                            icon: CupertinoIcons.car,
                            color: AppColors.red,
                          ),
                        ),
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
            SvgPicture.asset(icon, height: 50, width: 50),
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
}
