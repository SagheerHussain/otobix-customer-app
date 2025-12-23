import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/bottom_navigation_bar_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavigationBarPage extends StatelessWidget {
  BottomNavigationBarPage({super.key});

  final BottomNavigationBarController getxController = Get.put(
    BottomNavigationBarController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => getxController.pages[getxController.currentIndex.value],
        ),
      ),
      bottomNavigationBar: Obx(
        () => SalomonBottomBar(
          currentIndex: getxController.currentIndex.value,
          onTap: (index) {
            getxController.currentIndex.value = index;
          },
          itemShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          items: [
            // /// Home
            // SalomonBottomBarItem(
            //   icon: const Icon(CupertinoIcons.home, size: 22),
            //   title: const Text("Home", style: TextStyle(fontSize: 13)),
            //   selectedColor: AppColors.blue,
            // ),

            // /// My Cars
            // SalomonBottomBarItem(
            //   icon: const Icon(CupertinoIcons.car_detailed, size: 22),
            //   title: const Text("My Cars", style: TextStyle(fontSize: 13)),
            //   selectedColor: AppColors.green,
            // ),

            // /// Cart
            // SalomonBottomBarItem(
            //   icon: const Icon(CupertinoIcons.cart_fill, size: 22),
            //   title: const Text("Cart", style: TextStyle(fontSize: 13)),
            //   selectedColor: AppColors.red,
            // ),

            /// Sell My Car
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.money_dollar, size: 22),
              title: const Text("Sell My Car", style: TextStyle(fontSize: 13)),
              selectedColor: AppColors.blue,
            ),

            /// My Auctions
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.car_detailed, size: 22),
              title: const Text("My Auctions", style: TextStyle(fontSize: 13)),
              selectedColor: AppColors.green,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.person_crop_circle, size: 22),
              title: const Text("Profile", style: TextStyle(fontSize: 13)),
              selectedColor: AppColors.deepOrange,
            ),
          ],
        ),
      ),
    );
  }
}
