import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as ApiService;
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_constants.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/views/login_page.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class CustomerHomepage extends StatelessWidget {
  const CustomerHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 2,
        automaticallyImplyLeading: false,
        title: const Text(
          'Welcome, Customer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: AppColors.green,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.green),
            onPressed: () {
              logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sell My Car',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                'My Auctions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              const Text(
                'Used Cars',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              const Text(
                'Manage My Cars',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              // // Search
              // SizedBox(
              //   height: 30,
              //   child: TextField(
              //     decoration: InputDecoration(
              //       hintText: 'Search for cars, brands, models...',
              //       hintStyle: TextStyle(color: AppColors.grey, fontSize: 10),
              //       prefixIcon: const Icon(Icons.search, size: 15),
              //       prefixIconColor: AppColors.grey,
              //       filled: true,
              //       fillColor: AppColors.white,
              //       contentPadding: const EdgeInsets.symmetric(vertical: 2),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(30),
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20),

              // const Text(
              //   'Featured Cars',
              //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              // ),
              // const SizedBox(height: 10),

              // SizedBox(
              //   height: 150,
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: List.generate(4, (index) => _buildCarCard()),
              //   ),
              // ),

              // const SizedBox(height: 20),

              // const Text(
              //   'Live Auctions',
              //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              // ),
              // const SizedBox(height: 10),

              // Expanded(
              //   child: ListView.builder(
              //     itemCount: 3,
              //     itemBuilder: (_, index) => _buildAuctionCard(),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car image placeholder
            // Container(
            //   height: 90,
            //   decoration: const BoxDecoration(
            //     borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            //     color: Colors.grey,
            //   ),
            //   child: Center(
            //     child: Image.asset(
            //       AppImages.hondaCity1,
            //       height: 90,
            //       width: 200,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Toyota Corolla",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "2021 | Automatic",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuctionCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          const Icon(Icons.car_rental, size: 20, color: AppColors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Honda Civic 2020",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  "Auction ends in: 02h 15m 30s",
                  style: TextStyle(fontSize: 10, color: AppColors.red),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Bid Now", style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    try {
      // isLoading.value = true;

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
      final response = await ApiService.post(Uri.parse(endpoint), body: {});
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // unlink the device from the current user (call on sign-out)
        // NotificationService.instance.logout();
        await SharedPrefsHelper.remove(SharedPrefsHelper.tokenKey);
        await SharedPrefsHelper.remove(SharedPrefsHelper.userKey);
        await SharedPrefsHelper.remove(SharedPrefsHelper.userTypeKey);
        await SharedPrefsHelper.remove(SharedPrefsHelper.userIdKey);

        ToastWidget.show(
          context: Get.context!,
          title: 'Logout successful',
          type: ToastType.success,
        );

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
      // isLoading.value = false;
    }
  }
}
