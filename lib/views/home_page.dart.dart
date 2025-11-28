import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/controllers/home_page_controller.dart';
import 'package:otobix_customer_app/views/my_auctions_page.dart';
import 'package:otobix_customer_app/views/sell_my_car_page.dart';
import 'package:otobix_customer_app/views/under_development_page.dart';
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

              // If list is empty => don't show banners at all
              if (banners.isEmpty) {
                return const SizedBox.shrink();
              }

              final imageUrls = banners.map((b) => b.imageUrl).toList();

              // Each tap prints (or shows) its screenName
              final onTaps = banners.map<VoidCallback>((b) {
                return () {
                  debugPrint('Banner tapped: ${b.screenName}');
                  // or show a toast/snackbar / navigate etc.
                  // Get.snackbar('Banner', b.screenName);
                };
              }).toList();

              return ImagesScrollWidget(
                width: 200,
                height: 100,
                imageUrls: imageUrls,
                onTaps: onTaps,
              );
            }),

            const SizedBox(height: 30),

            Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavigationItem(
                        // Sell My Car
                        icon: CupertinoIcons.car_fill,
                        title: 'Sell My Car',
                        onTap: () => Get.to(() => SellMyCarPage()),
                      ),
                      const SizedBox(width: 10),
                      _buildNavigationItem(
                        // View My Auctions
                        icon: CupertinoIcons.hammer,
                        title: 'View My Auctions',
                        onTap: () => Get.to(() => MyAuctionsPage()),
                      ),
                      const SizedBox(width: 10),
                      _buildNavigationItem(
                        // Buy A Car
                        icon: CupertinoIcons.cart_fill,
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
                        // Warranty
                        icon: CupertinoIcons.checkmark_shield,

                        title: 'Warranty',
                        onTap: () => Get.to(
                          () => UnderDevelopmentPage(
                            screenName: "Warranty",
                            icon: CupertinoIcons.checkmark_shield,
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildNavigationItem(
                        // Insurance
                        icon: CupertinoIcons.shield_lefthalf_fill,

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
                        icon: CupertinoIcons.money_dollar_circle,

                        title: 'Finance',
                        onTap: () => Get.to(
                          () => UnderDevelopmentPage(
                            screenName: "Finance",
                            icon: CupertinoIcons.money_dollar_circle,
                            color: AppColors.green,
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
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final double width = MediaQuery.of(Get.context!).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.grey, size: 50),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: width / 30,
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
