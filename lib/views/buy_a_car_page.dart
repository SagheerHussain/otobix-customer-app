import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/Models/cars_list_model_for_buy_a_car.dart';
import 'package:otobix_customer_app/utils/app_constants.dart';
import 'package:otobix_customer_app/controllers/buy_a_car_controller.dart';
import 'package:otobix_customer_app/controllers/buy_a_car_filters_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_images.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';
import 'package:otobix_customer_app/widgets/buy_a_car_filters_widget.dart';
import 'package:otobix_customer_app/widgets/empty_data_widget.dart';
import 'package:otobix_customer_app/widgets/shimmer_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class BuyACarPage extends StatelessWidget {
  BuyACarPage({super.key});

  // ✅ Create filters controller once (needed by BuyACarController)
  final BuyACarFiltersController filtersController = Get.put(
    BuyACarFiltersController(),
    permanent: true,
  );

  final BuyACarController buyACarController = Get.put(BuyACarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Buy A Car'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Flexible(child: _buildSearchBar(context)),
                    // Obx(() {
                    if (buyACarController.searchController.text
                        .trim()
                        .isNotEmpty)
                      IconButton(
                        onPressed: () => buyACarController.clearSearch(),
                        icon: const Icon(Icons.clear, size: 20),
                        padding: const EdgeInsets.only(left: 8),
                        constraints: const BoxConstraints(),
                      ),

                    if (buyACarController.searchController.text.trim().isEmpty)
                      const SizedBox.shrink(),
                    // }),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                if (buyACarController.isPageLoading.value) {
                  return _buildLoadingWidget();
                } else if (buyACarController.visibleCars.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: EmptyDataWidget(
                        icon: Icons.car_rental,
                        message: buyACarController.searchQuery.isNotEmpty
                            ? 'No cars found for "${buyACarController.searchQuery.value}"'
                            : 'No Cars Found',
                      ),
                    ),
                  );
                } else {
                  return _buildCarsList(buyACarController.visibleCars);
                }
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarsList(List<CarsListModelForBuyACar> carsList) {
    return Expanded(
      child: Obx(() {
        final bool showLoader =
            buyACarController.mode.value == BuyACarMode.normal &&
            buyACarController.isLoadingMore.value &&
            buyACarController.hasMore.value;

        return ListView.separated(
          controller: buyACarController.scrollController,
          itemCount: carsList.length + (showLoader ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
            if (showLoader && index == carsList.length) {
              return _buildLoadMoreShimmerFooter();
            }

            final car = carsList[index];

            return InkWell(
              onTap: () {},
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(5),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: car.carImageUrls.isNotEmpty
                                ? car.carImageUrls[0].url
                                : '',
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
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.green.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              car.carPrice,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${car.carYear} ${car.carName}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildOtherDetails(car),
                          const SizedBox(height: 5),
                          _buildCarCardFooter(car, context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildLoadingWidget() {
    return Expanded(
      child: ListView.separated(
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerWidget(height: 160, borderRadius: 12),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ShimmerWidget(height: 14, width: 150),
                      SizedBox(height: 10),
                      ShimmerWidget(height: 12, width: 100),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          ShimmerWidget(height: 10, width: 60),
                          SizedBox(width: 10),
                          ShimmerWidget(height: 10, width: 80),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          ShimmerWidget(height: 10, width: 60),
                          SizedBox(width: 10),
                          ShimmerWidget(height: 10, width: 80),
                        ],
                      ),
                      SizedBox(height: 8),
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

  Widget _buildCarCardFooter(
    CarsListModelForBuyACar car,
    BuildContext context,
  ) {
    return Column(
      children: [
        const Divider(),
        ButtonWidget(
          text: 'View More Images',
          height: 35,
          fontSize: 12,
          borderRadius: 5,
          isLoading: false.obs,
          backgroundColor: AppColors.blue,
          onTap: () async {
            _showImageGalleryDialog(context, car);
            await buyACarController.saveInterestedBuyer(
              car: car,
              activityType: AppConstants.buyACarActivityType.viewMoreImages,
            );
          },
        ),
        const SizedBox(height: 7),
        ButtonWidget(
          text: 'Interested!',
          height: 35,
          fontSize: 12,
          borderRadius: 5,
          isLoading: false.obs,
          onTap: () {
            _showInterestDialog(context, car);
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SizedBox(
      height: 35,
      child: TextFormField(
        controller: buyACarController.searchController,
        keyboardType: TextInputType.text,
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search by car name...',
          hintStyle: TextStyle(
            color: AppColors.grey.withOpacity(0.5),
            fontSize: 12,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(color: AppColors.green, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 10,
          ),
          suffixIcon: BuyACarFiltersWidget(
            onApplyPressed: () async {
              await buyACarController.onApplyFiltersPressedServer();
            },
          ),
        ),
        onFieldSubmitted: (value) {
          buyACarController.onSearchSubmitted(value);
        },
        onChanged: (value) {
          // optional: keep typing behavior, or remove to only submit
          buyACarController.searchQuery.value = value.trim().toLowerCase();
        },
      ),
    );
  }

  // --- your remaining helpers (unchanged) ---
  Widget _buildOtherDetails(CarsListModelForBuyACar car) {
    bool hasData(String? value) => value != null && value.trim().isNotEmpty;

    Widget gridDetailItem({
      required IconData icon,
      required String label,
      required String value,
      Color? iconColor,
      Color? bgColor,
    }) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (bgColor ?? AppColors.green.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: (iconColor ?? AppColors.green).withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 17, color: iconColor ?? AppColors.green),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.grey.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      );
    }

    final carDetails = <Map<String, dynamic>>[];

    if (hasData(car.carMake)) {
      carDetails.add({
        'icon': Icons.directions_car,
        'label': 'Make',
        'value': car.carMake,
        'color': Colors.blue,
      });
    }
    if (hasData(car.carModel)) {
      carDetails.add({
        'icon': Icons.model_training,
        'label': 'Model',
        'value': car.carModel,
        'color': Colors.purple,
      });
    }
    if (hasData(car.carYear)) {
      carDetails.add({
        'icon': Icons.calendar_month,
        'label': 'Year',
        'value': car.carYear,
        'color': Colors.orange,
      });
    }
    if (hasData(car.carKms)) {
      carDetails.add({
        'icon': Icons.speed,
        'label': 'Kilometers',
        'value': '${car.carKms} km',
        'color': Colors.teal,
      });
    }
    if (hasData(car.carFuelType)) {
      carDetails.add({
        'icon': Icons.local_gas_station,
        'label': 'Fuel Type',
        'value': car.carFuelType,
        'color': Colors.red,
      });
    }
    if (hasData(car.carBodyType)) {
      carDetails.add({
        'icon': Icons.category,
        'label': 'Body Type',
        'value': car.carBodyType,
        'color': Colors.blue,
      });
    }
    if (hasData(car.carTransmission)) {
      carDetails.add({
        'icon': Icons.settings,
        'label': 'Transmission',
        'value': car.carTransmission,
        'color': Colors.deepPurple,
      });
    }
    if (hasData(car.carVariant)) {
      carDetails.add({
        'icon': Icons.directions_car_filled,
        'label': 'Variant',
        'value': car.carVariant,
        'color': Colors.green,
      });
    }
    if (hasData(car.carOwnershipSerialNo)) {
      carDetails.add({
        'icon': Icons.person,
        'label': 'Ownership',
        'value': car.carOwnershipSerialNo,
        'color': Colors.indigo,
      });
    }
    if (hasData(car.carTaxValidity)) {
      carDetails.add({
        'icon': Icons.receipt_long,
        'label': 'Tax Validity',
        'value': car.carTaxValidity,
        'color': Colors.brown,
      });
    }

    if (carDetails.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'No additional details available',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2.2,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: carDetails.length,
        itemBuilder: (context, index) {
          final detail = carDetails[index];
          return gridDetailItem(
            icon: detail['icon'] as IconData,
            label: detail['label'] as String,
            value: detail['value'] as String,
            iconColor: detail['color'] as Color,
            bgColor: (detail['color'] as Color).withValues(alpha: 0.05),
          );
        },
      ),
    );
  }

  void _showImageGalleryDialog(
    BuildContext context,
    CarsListModelForBuyACar car,
  ) {
    if (car.carImageUrls.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('No Images'),
          content: const Text('No images available for this car.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    int currentIndex = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.92,
              maxHeight: MediaQuery.of(context).size.height * 0.50,
            ),
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '${car.carYear} ${car.carName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.black,
                      child: Stack(
                        children: [
                          PhotoViewGallery.builder(
                            itemCount: car.carImageUrls.length,
                            builder: (context, index) {
                              return PhotoViewGalleryPageOptions(
                                imageProvider: NetworkImage(
                                  car.carImageUrls[index].url,
                                ),
                                minScale: PhotoViewComputedScale.covered,
                                maxScale: PhotoViewComputedScale.covered * 3,
                                initialScale: PhotoViewComputedScale.covered,
                                heroAttributes: PhotoViewHeroAttributes(
                                  tag: car.carImageUrls[index].url,
                                ),
                              );
                            },
                            onPageChanged: (index) {
                              setState(() => currentIndex = index);
                            },
                            loadingBuilder: (context, event) => const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.green,
                              ),
                            ),
                            backgroundDecoration: const BoxDecoration(
                              color: Colors.black,
                            ),
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${currentIndex + 1}/${car.carImageUrls.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Close'),
                      ),
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

  void _showInterestDialog(BuildContext context, CarsListModelForBuyACar car) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Interested in this car?',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${car.carYear} ${car.carName}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 2),
            if (hasData(car.carPrice)) Text('Price: ${car.carPrice}'),
            const SizedBox(height: 16),
            const Text(
              'Our team will contact you shortly with more details.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 14, color: AppColors.blue),
            ),
          ),
          ButtonWidget(
            text: 'Submit Interest',
            height: 35,
            fontSize: 12,
            isLoading: buyACarController.isSaveInterestedBuyerLoading,
            onTap: () async {
              await buyACarController.saveInterestedBuyer(
                car: car,
                activityType: AppConstants.buyACarActivityType.interested,
              );
            },
          ),
        ],
      ),
    );
  }

  bool hasData(String? value) => value != null && value.trim().isNotEmpty;

  Widget _buildLoadMoreShimmerFooter() {
    return const Padding(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget(height: 160, borderRadius: 12),
          SizedBox(height: 12),
          ShimmerWidget(height: 14, width: 100),
          SizedBox(height: 10),
          ShimmerWidget(height: 12, width: 150),
        ],
      ),
    );
  }
}
