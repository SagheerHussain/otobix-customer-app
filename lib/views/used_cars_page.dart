import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_customer_app/Models/cars_list_model.dart';
import 'package:otobix_customer_app/controllers/used_cars_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_images.dart';
import 'package:otobix_customer_app/utils/global_functions.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';
import 'package:otobix_customer_app/widgets/empty_data_widget.dart';
import 'package:otobix_customer_app/widgets/shimmer_widget.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class UsedCarsPage extends StatelessWidget {
  UsedCarsPage({super.key});

  final UsedCarsController getxController = Get.put(UsedCarsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Used Cars'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Flexible(child: _buildSearchBar(context)),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        _buildFilterAndSortSheet();
                      },
                      child: Icon(
                        Icons.filter_alt_outlined,
                        size: 30,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              Obx(() {
                // Final filtered cars list
                final filteredCarsList = getxController.sortFilteredCarsList;

                // Check if cars list is loading
                if (getxController.isPageLoading.value) {
                  return _buildLoadingWidget();
                } else if (filteredCarsList.isEmpty) {
                  // Check if cars list is empty
                  return Expanded(
                    child: Center(
                      child: const EmptyDataWidget(
                        icon: Icons.car_rental,
                        message: 'No Cars Found',
                      ),
                    ),
                  );
                } else {
                  // Show fetched and filtered cars list
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

                        const SizedBox(height: 5),
                        _buildCarCardFooter(car),
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

  // Filter and Sort
  // Filter and Sort
  void _buildFilterAndSortSheet() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter & Sort',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                getxController.clearAllFilters();
                                Get.back();
                              },
                              child: Text(
                                'Clear All',
                                style: TextStyle(
                                  color: AppColors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => Get.back(),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  const Divider(height: 1),

                  // Filters Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sort Section
                          _buildSortSection(),
                          const SizedBox(height: 20),

                          // Filters Section
                          _buildFiltersSection(),
                        ],
                      ),
                    ),
                  ),

                  // Apply Button
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => ButtonWidget(
                              text:
                                  'Apply Filters (${getxController.getAppliedFiltersCount()})',
                              isLoading: false.obs,
                              onTap: () {
                                getxController.applyFilters();
                                Get.back();
                              },
                              height: 50,
                              backgroundColor: AppColors.green,
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sort By',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSortChip('Newest First', 'newest'),
            _buildSortChip('Price: Low to High', 'price_low'),
            _buildSortChip('Price: High to Low', 'price_high'),
            _buildSortChip('Year: New to Old', 'year_new'),
            _buildSortChip('Year: Old to New', 'year_old'),
            _buildSortChip('KM: Low to High', 'km_low'),
            _buildSortChip('KM: High to Low', 'km_high'),
          ],
        ),
      ],
    );
  }

  Widget _buildSortChip(String label, String value) {
    return Obx(() {
      final isSelected = getxController.selectedSort.value == value;
      return ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          getxController.selectedSort.value = selected ? value : '';
        },
        backgroundColor: Colors.grey[100],
        selectedColor: AppColors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.green : Colors.grey[300]!,
          ),
        ),
      );
    });
  }

  Widget _buildFiltersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filters',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        // Make
        _buildFilterDropdown(
          label: 'Make',
          value: getxController.selectedMake.value,
          items: getxController.availableMakes,
          onChanged: (value) => getxController.selectedMake.value = value!,
        ),

        // Model
        _buildFilterDropdown(
          label: 'Model',
          value: getxController.selectedModel.value,
          items: getxController.availableModels,
          onChanged: (value) => getxController.selectedModel.value = value!,
        ),

        // Transmission
        _buildFilterChipGroup(
          label: 'Transmission',
          options: ['Manual', 'Automatic', 'AMT', 'CVT'],
          selectedOptions: getxController.selectedTransmissions,
        ),

        // Registration Year
        _buildYearRangeFilter(
          label: 'Registration Year',
          minYearController: getxController.minRegYearController,
          maxYearController: getxController.maxRegYearController,
        ),

        // Manufacture Year
        _buildYearRangeFilter(
          label: 'Manufacture Year',
          minYearController: getxController.minMfgYearController,
          maxYearController: getxController.maxMfgYearController,
        ),

        // Ownership Serial No
        _buildFilterChipGroup(
          label: 'Ownership',
          options: ['1st Owner', '2nd Owner', '3rd Owner', '4th+ Owner'],
          selectedOptions: getxController.selectedOwnerships,
        ),

        // Fuel Type
        _buildFilterChipGroup(
          label: 'Fuel Type',
          options: ['Petrol', 'Diesel', 'CNG', 'Electric', 'Hybrid'],
          selectedOptions: getxController.selectedFuelTypes,
        ),

        // KMs Range
        _buildKMsRangeFilter(),
      ],
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    // Create unique items by adding index to handle duplicates
    final uniqueItems = items.asMap().entries.map((entry) {
      return '${entry.value}_${entry.key}'; // Append index to make values unique
    }).toList();

    // Convert the value to match the unique format
    String? uniqueValue;
    if (value != null && value.isNotEmpty) {
      final index = items.indexWhere((item) => item == value);
      if (index != -1) {
        uniqueValue = '${value}_$index';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButton<String>(
            value: uniqueValue,
            isExpanded: true,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(
                value: null,
                child: Text(
                  'Select $label',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
              ...uniqueItems.asMap().entries.map((entry) {
                final displayText =
                    items[entry.key]; // Original text without index
                return DropdownMenuItem(
                  value: entry.value,
                  child: Text(
                    displayText,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
            ],
            onChanged: (String? selectedUniqueValue) {
              if (selectedUniqueValue == null) {
                onChanged(null);
              } else {
                // Extract the original value by removing the index suffix
                final originalValue = selectedUniqueValue
                    .split('_')
                    .sublist(0, selectedUniqueValue.split('_').length - 1)
                    .join('_');
                onChanged(originalValue);
              }
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFilterChipGroup({
    required String label,
    required List<String> options,
    required RxList<String> selectedOptions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            return Obx(() {
              final isSelected = selectedOptions.contains(option);
              return FilterChip(
                label: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontSize: 12,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    selectedOptions.add(option);
                  } else {
                    selectedOptions.remove(option);
                  }
                },
                backgroundColor: Colors.grey[100],
                selectedColor: AppColors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppColors.green : Colors.grey[300]!,
                  ),
                ),
              );
            });
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildYearRangeFilter({
    required String label,
    required TextEditingController minYearController,
    required TextEditingController maxYearController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildYearTextField('Min Year', minYearController)),
            const SizedBox(width: 12),
            Expanded(child: _buildYearTextField('Max Year', maxYearController)),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildYearTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildKMsRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'KMs Driven',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return Column(
            children: [
              RangeSlider(
                values: getxController.kmsRange.value,
                min: 0,
                max: 200000,
                divisions: 20,
                labels: RangeLabels(
                  '${getxController.kmsRange.value.start.round()} km',
                  '${getxController.kmsRange.value.end.round()} km',
                ),
                onChanged: (values) {
                  getxController.kmsRange.value = values;
                },
                activeColor: AppColors.green,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${getxController.kmsRange.value.start.round()} km',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '${getxController.kmsRange.value.end.round()} km',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }
}
