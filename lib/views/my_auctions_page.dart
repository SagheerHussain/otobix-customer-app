import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_customer_app/Models/cars_list_model.dart';
import 'package:otobix_customer_app/controllers/my_auctions_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_images.dart';
import 'package:otobix_customer_app/utils/global_functions.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';
import 'package:otobix_customer_app/widgets/empty_data_widget.dart';
import 'package:otobix_customer_app/widgets/shimmer_widget.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class MyAuctionsPage extends StatelessWidget {
  MyAuctionsPage({super.key});

  final MyAuctionsController getxController = Get.put(MyAuctionsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'My Auctions'),
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

  Widget _buildCarsList(List<CarsListModel> carsList) {
    return Expanded(
      child: ListView.separated(
        itemCount: carsList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final car = carsList[index];

          final String yearofManufacture =
              '${GlobalFunctions.getFormattedDate(date: car.yearMonthOfManufacture, type: GlobalFunctions.year)} ';

          return InkWell(
            onTap: () {
              // Get.to(
              //   () => CarDetailsPage(
              //     carId: car.id,
              //     car: car,
              //     currentOpenSection: homeController.liveBidsSectionScreen,
              //     remainingAuctionTime: getxController
              //         .getCarRemainingTimeForNextScreen(car.id),
              //   ),
              // );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car image
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(5),
                        ),

                        child: CachedNetworkImage(
                          imageUrl: car.imageUrl,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 160,
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
                            return Image.asset(
                              AppImages.carNotFound,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  // Car details
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$yearofManufacture${car.make} ${car.model} ${car.variant}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),
                        _buildOtherDetails(car),

                        // const SizedBox(height: 5),
                        // _buildCarCardFooter(car),
                      ],
                    ),
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

  Widget _buildOtherDetails(CarsListModel car) {
    Widget iconDetail(IconData icon, String label, String value) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 15, color: AppColors.grey),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Divider(),
          // Text(
          //   label,
          //   style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          // ),
        ],
      );
    }

    String maskRegistrationNumber(String? input) {
      if (input == null || input.length <= 5) return '*****';
      final visible = input.substring(0, input.length - 5);
      return '$visible*****';
    }

    final items = [
      // iconDetail(Icons.factory, 'Make', 'Mahindra'),
      // iconDetail(Icons.directions_car, 'Model', 'Scorpio'),
      // iconDetail(Icons.confirmation_number, 'Variant', '[2014–2017]'),
      iconDetail(
        Icons.calendar_month,
        'Registration Date',
        GlobalFunctions.getFormattedDate(
              date: car.registrationDate,
              type: GlobalFunctions.monthYear,
            ) ??
            'N/A',
      ),
      iconDetail(
        Icons.speed,
        'Odometer Reading in Kms',
        '${NumberFormat.decimalPattern('en_IN').format(car.odometerReadingInKms)} km',
      ),
      iconDetail(Icons.local_gas_station, 'Fuel Type', car.fuelType),

      // iconDetail(
      //   Icons.calendar_month,
      //   'Year of Manufacture',
      //   GlobalFunctions.getFormattedDate(
      //         date: carDetails.yearMonthOfManufacture,
      //         type: GlobalFunctions.year,
      //       ) ??
      //       'N/A',
      // ),
      iconDetail(Icons.settings, 'Transmission', car.commentsOnTransmission),
      iconDetail(
        Icons.person,
        'Owner Serial Number',
        car.ownerSerialNumber == 1
            ? 'First Owner'
            : '${car.ownerSerialNumber} Owners',
      ),
      iconDetail(
        Icons.receipt_long,
        'Tax Validity',
        car.roadTaxValidity == 'LTT' || car.roadTaxValidity == 'OTT'
            ? car.roadTaxValidity
            : GlobalFunctions.getFormattedDate(
                    date: car.taxValidTill,
                    type: GlobalFunctions.monthYear,
                  ) ??
                  'N/A',
      ),

      // iconDetail(
      //   Icons.science,
      //   'Cubic Capacity',
      //   car.cubicCapacity != 0 ? '${car.cubicCapacity} cc' : 'N/A',
      // ),
      iconDetail(
        Icons.location_on,
        'Inspection Location',
        car.inspectionLocation,
      ),
      iconDetail(
        Icons.directions_car_filled,
        'Registration No.',
        maskRegistrationNumber(car.registrationNumber),
      ),
      iconDetail(Icons.apartment, 'Registered RTO', car.registeredRto),
    ];

    return Container(
      // padding: const EdgeInsets.all(12),
      // margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wrap(
          //   spacing: 10,
          //   runSpacing: 5,
          //   alignment: WrapAlignment.start,
          //   children: items,
          // ),
          GridView.count(
            padding: EdgeInsets.zero,
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 5, // controls vertical space
            crossAxisSpacing: 10, // controls horizontal space
            childAspectRatio: 4, // width / height ratio — adjust as needed
            children: items,
          ),
        ],
      ),
    );
  }

  Widget _buildCarCardFooter(CarsListModel car) {
    return Column(
      children: [
        // const Divider(),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.center,
          child: ButtonWidget(
            text: 'Interested',
            height: 30,
            width: 150,
            fontSize: 12,
            isLoading: false.obs,
            onTap: () {
              ToastWidget.show(
                context: Get.context!,
                title:
                    'Thank you for your interest. Our team will contact you shortly.',
                toastDuration: 5,
                type: ToastType.success,
              );
            },
          ),
        ),
        const SizedBox(height: 5),
      ],
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
          hintText: 'Search cars...',
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
