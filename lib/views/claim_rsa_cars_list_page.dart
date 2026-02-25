import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/Models/cars_list_model.dart';
import 'package:otobix_customer_app/controllers/claim_rsa_cars_list_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_images.dart';
import 'package:otobix_customer_app/views/claim_rsa_page.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/empty_data_widget.dart';
import 'package:otobix_customer_app/widgets/shimmer_widget.dart';

class ClaimRsaCarsListPage extends StatelessWidget {
  ClaimRsaCarsListPage({super.key});

  final ClaimRsaCarsListController getxController = Get.put(
    ClaimRsaCarsListController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Claim RSA Cars'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [Flexible(child: _buildSearchBar(context))],
                ),
              ),
              const SizedBox(height: 15),

              Obx(() {
                // Use filteredCarsList instead of myAuctionCarsList
                final filteredCarsList = getxController.filteredCarsList;

                if (getxController.isPageLoading.value) {
                  return _buildLoadingWidget();
                } else if (filteredCarsList.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: const EmptyDataWidget(
                        icon: Icons.car_rental,
                        message: 'No Cars Found',
                      ),
                    ),
                  );
                } else {
                  return _buildCarsList(filteredCarsList);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Cars List
  Widget _buildCarsList(List<CarsListModel> carsList) {
    return Expanded(
      child: ListView.separated(
        itemCount: carsList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final car = carsList[index];

          // final String yearofManufacture =
          //     '${GlobalFunctions.getFormattedDate(date: car.yearMonthOfManufacture, type: GlobalFunctions.year)} ';

          final double screenWidth = MediaQuery.of(context).size.width;

          return InkWell(
            onTap: () {
              Get.to(() => ClaimRsaPage(car: car));
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car image
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15),
                          bottom: Radius.circular(15),
                        ),

                        child: CachedNetworkImage(
                          imageUrl: car.imageUrl,

                          height: screenWidth * 0.7,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            // height: 160,
                            height: screenWidth * 0.7,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.green,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, error, stackTrace) {
                            return Padding(
                              padding: const EdgeInsets.all(50),
                              child: Image.asset(
                                AppImages.carNotFound,
                                height: screenWidth * 0.7,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                      // Gradient overlay at bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: .8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Appointment ID badge
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey.withValues(alpha: .6),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: .2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              car.appointmentId,

                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            // child: Obx(() {
                            //   final countdown =
                            //       getxController.countdownTextById[car
                            //           .appointmentId] ??
                            //       '-- : -- : --';

                            //   return Text(
                            //     countdown,
                            //     style: const TextStyle(
                            //       color: Colors.white,
                            //       fontSize: 15,
                            //       fontWeight: FontWeight.w600,
                            //       letterSpacing: 0.5,
                            //     ),
                            //   );
                            // }),
                          ),
                        ),
                      ),

                      // Screen Tag
                      // Positioned(
                      //   top: 10,
                      //   left: 10,
                      //   child: Center(
                      //     child: Container(
                      //       padding: const EdgeInsets.symmetric(
                      //         horizontal: 12,
                      //         vertical: 6,
                      //       ),
                      //       decoration: BoxDecoration(
                      //         color: AppColors.black.withValues(alpha: .6),
                      //         borderRadius: BorderRadius.circular(10),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: Colors.black.withValues(alpha: .2),
                      //             blurRadius: 4,
                      //             offset: const Offset(0, 2),
                      //           ),
                      //         ],
                      //       ),
                      //       child: Text(
                      //         'Inspected',
                      //         style: const TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 15,
                      //           fontWeight: FontWeight.w600,
                      //           letterSpacing: 0.5,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Expanded(
      child: ListView.separated(
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          return Card(
            // elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image shimmer
                const ShimmerWidget(height: 160, borderRadius: 12),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      // Title shimmer
                      ShimmerWidget(height: 14, width: 150),
                      SizedBox(height: 10),

                      // Bid row shimmer
                      ShimmerWidget(height: 12, width: 100),
                      SizedBox(height: 6),

                      // Year and KM
                      Row(
                        children: [
                          ShimmerWidget(height: 10, width: 60),
                          SizedBox(width: 10),
                          ShimmerWidget(height: 10, width: 80),
                        ],
                      ),
                      SizedBox(height: 6),

                      // Fuel and Location
                      Row(
                        children: [
                          ShimmerWidget(height: 10, width: 60),
                          SizedBox(width: 10),
                          ShimmerWidget(height: 10, width: 80),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Inspection badge
                      ShimmerWidget(height: 10, width: 100),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Search Bar
  Widget _buildSearchBar(BuildContext context) {
    return SizedBox(
      height: 35,
      child: TextFormField(
        controller: getxController.searchController,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 12),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search cars by appointment id...',
          hintStyle: TextStyle(
            color: AppColors.grey.withValues(alpha: .5),
            fontSize: 12,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
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
          getxController.searchQuery.value = value.toLowerCase();
        },
      ),
    );
  }
}
