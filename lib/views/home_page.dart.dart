import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/controllers/home_page_controller.dart';
import 'package:otobix_customer_app/views/manage_my_cars_page.dart';
import 'package:otobix_customer_app/views/my_auctions_page.dart';
import 'package:otobix_customer_app/views/sell_my_car_page.dart';
import 'package:otobix_customer_app/views/under_development_page.dart';
import 'package:otobix_customer_app/views/used_cars_page.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomePageController homeController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        // title: 'Welcome ${homeController.userName.value}',
        title: 'HomePage',
        showBackButton: false,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavigationItem(
                  imagePath:
                      'https://www.theacegrp.com/wp-content/uploads/2024/02/Depositphotos_55577141_L-jpg.webp',
                  title: 'Sell My Car',
                  onTap: () => Get.to(() => SellMyCarPage()),
                ),
                const SizedBox(width: 10),
                _buildNavigationItem(
                  imagePath:
                      'https://img.freepik.com/free-vector/antique-auction-isometric-composition_1284-22062.jpg?semt=ais_hybrid&w=740&q=80',
                  title: 'View My Auctions',
                  onTap: () => Get.to(() => MyAuctionsPage()),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavigationItem(
                  imagePath:
                      'https://ymimg1.b8cdn.com/uploads/article/9586/pictures/13502037/1698062565960_how-to-start-used-car-dealership-ecarstrade-6_01HDE6N11370VNHPV3XAZETE9J.jpg',
                  title: 'Buy Used Cars',
                  onTap: () => Get.to(() => UsedCarsPage()),
                ),
                const SizedBox(width: 10),
                _buildNavigationItem(
                  imagePath:
                      'https://lh4.googleusercontent.com/proxy/t2PWz5vTx9hB4oGuXingEth76XuREIK7Df5HI6DZhJhUfx3N6ZnVdeYWUhYKt0qsk9VrdCNewbBpWxxJSxPmykVzFD0FajOnOLkp5YwLnkYQaN3xNJ1NYNtFH3mOpQ',
                  title: 'Manage My Cars',
                  onTap: () => Get.to(() => ManageMyCarsPage()),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavigationItem(
                  imagePath:
                      'https://www.thecarexpert.co.uk/wp-content/uploads/2023/02/car-finance-borrowing-2022-1068x534.jpg.webp',
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
                  imagePath:
                      'https://static.vecteezy.com/system/resources/previews/045/711/185/non_2x/male-profile-picture-placeholder-for-social-media-forum-dating-site-chat-operator-design-social-profile-template-default-avatar-icon-flat-style-free-vector.jpg',
                  title: 'Profile',
                  onTap: () => Get.to(
                    () => UnderDevelopmentPage(
                      screenName: "Profile",
                      icon: CupertinoIcons.person,
                      color: AppColors.deepOrange,
                      completedPercentage: 10,
                      actionButton: ButtonWidget(
                        text: 'Logout',
                        height: 30,
                        fontSize: 11,
                        isLoading: homeController.isLoadingLogout,
                        onTap: () {
                          homeController.logout();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build navigation item
  Widget _buildNavigationItem({
    required String imagePath,
    required String title,
    required VoidCallback onTap,
  }) {
    final double width = MediaQuery.of(Get.context!).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(color: AppColors.blue),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.white),
              child: Image.network(
                imagePath,
                width: width / 3,
                height: width / 4,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: width / 30,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:otobix_customer_app/controllers/home_page_controller.dart';
// import 'package:otobix_customer_app/utils/app_colors.dart';
// import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

// class HomePage extends StatelessWidget {
//   HomePage({super.key});

//   final HomePageController getxController = Get.put(HomePageController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() => getxController.pages[getxController.currentIndex.value]),
//       bottomNavigationBar: Obx(
//         () => SalomonBottomBar(
//           currentIndex: getxController.currentIndex.value,
//           onTap: (index) {
//             getxController.currentIndex.value = index;
//           },
//           itemShape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           itemPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           items: [
//             /// Sell My Car
//             SalomonBottomBarItem(
//               icon: const Icon(CupertinoIcons.money_dollar_circle, size: 20),
//               title: const Text("Sell My Car", style: TextStyle(fontSize: 11)),
//               selectedColor: AppColors.green,
//             ),

//             /// My Auctions
//             SalomonBottomBarItem(
//               icon: const Icon(CupertinoIcons.hammer, size: 20),
//               title: const Text("My Auctions", style: TextStyle(fontSize: 11)),
//               selectedColor: AppColors.blue,
//             ),

//             /// Used Cars
//             SalomonBottomBarItem(
//               icon: const Icon(CupertinoIcons.car_detailed, size: 20),
//               title: const Text("Used Cars", style: TextStyle(fontSize: 11)),
//               selectedColor: AppColors.red,
//             ),

//             /// Manage My Cars
//             SalomonBottomBarItem(
//               icon: const Icon(CupertinoIcons.square_list, size: 20),
//               title: const Text("My Cars", style: TextStyle(fontSize: 11)),
//               selectedColor: AppColors.grey,
//             ),

//             /// Profile
//             SalomonBottomBarItem(
//               icon: const Icon(CupertinoIcons.person, size: 20),
//               title: const Text("Profile", style: TextStyle(fontSize: 11)),
//               selectedColor: AppColors.deepOrange,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
