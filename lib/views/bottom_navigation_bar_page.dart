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
      body: Obx(() => getxController.pages[getxController.currentIndex.value]),
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
            /// Sell My Car
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.money_dollar_circle, size: 20),
              title: const Text("Sell My Car", style: TextStyle(fontSize: 11)),
              selectedColor: AppColors.green,
            ),

            /// My Auctions
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.hammer, size: 20),
              title: const Text("My Auctions", style: TextStyle(fontSize: 11)),
              selectedColor: AppColors.blue,
            ),

            /// Used Cars
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.car_detailed, size: 20),
              title: const Text("Used Cars", style: TextStyle(fontSize: 11)),
              selectedColor: AppColors.red,
            ),

            /// Manage My Cars
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.square_list, size: 20),
              title: const Text("My Cars", style: TextStyle(fontSize: 11)),
              selectedColor: AppColors.grey,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.person, size: 20),
              title: const Text("Profile", style: TextStyle(fontSize: 11)),
              selectedColor: AppColors.deepOrange,
            ),
          ],
        ),
      ),
    );
  }
}
