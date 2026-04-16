import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:otobix_customer_app/controllers/insurance_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_images.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';
import 'package:otobix_customer_app/widgets/insurance_dropdown_widget.dart';

class InsurancePage extends StatelessWidget {
  final bool isGuestUser;
  final String? phoneNumber;
  InsurancePage({super.key, this.isGuestUser = false, this.phoneNumber = ''});

  final InsuranceController insuranceController = Get.put(
    InsuranceController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Insure My Car'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              // Banner Image
              Image.asset(
                AppImages.insuranceScreenBanner,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildCarTypeOptions(),
                    const SizedBox(height: 15),

                    // Registration Number (Used Car)
                    Obx(
                      () => _buildShouldShowWidget(
                        showWidget: insuranceController.isUsedCar.value,
                        widget: _buildRegistrationNumberField(),
                      ),
                    ),

                    // RTO (New Car)
                    Obx(
                      () => _buildShouldShowWidget(
                        showWidget: !insuranceController.isUsedCar.value,
                        widget: _buildRtoList(),
                      ),
                    ),

                    // Makes (New Car)
                    Obx(
                      () => _buildShouldShowWidget(
                        showWidget: !insuranceController.isUsedCar.value,
                        widget: _buildCarMakes(),
                      ),
                    ),

                    // Models (New Car)
                    Obx(
                      () => _buildShouldShowWidget(
                        showWidget: !insuranceController.isUsedCar.value,
                        widget: _buildCarModels(),
                      ),
                    ),

                    // Fuel Types (New Car)
                    Obx(
                      () => _buildShouldShowWidget(
                        showWidget: !insuranceController.isUsedCar.value,
                        widget: _buildFuelTypes(),
                      ),
                    ),

                    // Variants (New Car)
                    Obx(
                      () => _buildShouldShowWidget(
                        showWidget: !insuranceController.isUsedCar.value,
                        widget: _buildCarVariants(),
                      ),
                    ),

                    // Manufacture Date
                    Obx(
                      () => _buildShouldShowWidget(
                        showWidget: !insuranceController.isUsedCar.value,
                        widget: _buildManufactureDate(),
                      ),
                    ),

                    // Owner Types
                    Obx(
                      () => _buildShouldShowWidget(
                        showWidget: !insuranceController.isUsedCar.value,
                        widget: _buildOwnerTypeOptions(),
                      ),
                    ),

                    // Policy Types
                    Obx(
                      () => _buildShouldShowWidget(
                        showWidget: insuranceController.isUsedCar.value,
                        widget: _buildPolicyTypeOptions(),
                      ),
                    ),

                    // const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ButtonWidget(
                        text: 'Fetch Quotes',
                        height: 35,
                        fontSize: 12,
                        isLoading: insuranceController.isFetchQuotesLoading,
                        onTap: () {
                          insuranceController.fetchQuotes();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _buildQuotesSection(),
              const SizedBox(height: 20),

              // Generated Quotes List
              Obx(
                () => _buildShouldShowWidget(
                  showWidget:
                      insuranceController.generatedQuotesList.isNotEmpty,
                  widget: _buildGeneratedQuotesList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show car type options
  Widget _buildCarTypeOptions() {
    final options = insuranceController.carTypeOptions;

    return Obx(
      () => Row(
        children: List.generate(options.length, (index) {
          final option = options[index];
          final isSelected =
              insuranceController.selectedCarTypeIndex.value == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => insuranceController.onCarTypeChanged(index),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF111827),
                          width: 1.3,
                        ),
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.green,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        option['label'],
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Get registration number input
  Widget _buildRegistrationNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Car Registration Number',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
          ),
          child: TextFormField(
            controller: insuranceController.registrationNumberController,
            textCapitalization: TextCapitalization.characters,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            decoration: InputDecoration(
              prefixIcon: Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.directions_car,
                  color: AppColors.green,
                  size: 20,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
              hintText: 'e.g. MH12AB1234',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.grey),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            onChanged: (value) {
              insuranceController.onRegistrationNumberChanged(value);
            },
          ),
        ),
      ],
    );
  }

  // Show rot list
  Widget _buildRtoList() {
    return InsuranceDropdownWidget(
      label: 'RTO',
      hintText: 'Select RTO',
      icon: Icons.location_city_outlined,
      items: insuranceController.rtoList
          .map((rto) => rto['RegionCode'] as String)
          .toList(),
      isRequired: true,
      onChanged: (value) => insuranceController.onRtoSelected(value),
      validator: (value) {
        if (value == 'invalid') {
          return 'This RTO is not available';
        }
        return null;
      },
    );
  }

  // Show car makes
  Widget _buildCarMakes() {
    return InsuranceDropdownWidget(
      label: 'Make',
      hintText: 'Select car make',
      icon: Icons.directions_car_filled_outlined,
      items: insuranceController.makesList
          .map((make) => make['makeName'] as String)
          .toList(),
      isRequired: true,
      onChanged: (value) => insuranceController.onMakeSelected(value),
      validator: (value) {
        if (value == 'invalid') {
          return 'This Car Make is not available';
        }
        return null;
      },
    );
  }

  // Show car models
  Widget _buildCarModels() {
    return Obx(() {
      final enabled = insuranceController.isModelEnabled.value;

      return IgnorePointer(
        ignoring: !enabled,
        child: Opacity(
          opacity: enabled ? 1 : 0.45,
          child: InsuranceDropdownWidget(
            key: ValueKey(
              'model_${insuranceController.selectedMakeId.value}_${insuranceController.modelsList.length}',
            ),
            label: 'Model',
            hintText: enabled ? 'Select model' : 'Select make first',
            icon: Icons.car_rental_outlined,
            items: insuranceController.modelsList
                .map((model) => model['modelName'] as String)
                .toList(),
            isRequired: true,
            onChanged: (value) => insuranceController.onModelSelected(value),
            validator: (value) {
              if (value == 'invalid') {
                return 'This Car Model is not available';
              }
              return null;
            },
          ),
        ),
      );
    });
  }

  // Show fuel types
  Widget _buildFuelTypes() {
    return Obx(() {
      final enabled = insuranceController.isFuelTypeEnabled.value;

      return IgnorePointer(
        ignoring: !enabled,
        child: Opacity(
          opacity: enabled ? 1 : 0.45,
          child: InsuranceDropdownWidget(
            key: ValueKey(
              'fuel_${insuranceController.selectedModelId.value}_${insuranceController.fuelTypesList.length}_${insuranceController.selectedFuelType.value}',
            ),
            label: 'Fuel Type',
            hintText: enabled ? 'Select fuel type' : 'Select model first',
            icon: Icons.local_gas_station_outlined,
            items: insuranceController.fuelTypesList
                .map((fuel) => fuel['fuelTypeName'] as String)
                .toList(),
            isRequired: true,
            onChanged: (value) => insuranceController.onFuelTypeSelected(value),
            validator: (value) {
              if (value == 'invalid') {
                return 'This Fuel Type is not available';
              }
              return null;
            },
          ),
        ),
      );
    });
  }

  // Show car variants
  Widget _buildCarVariants() {
    return Obx(() {
      final enabled = insuranceController.isVariantEnabled.value;

      return IgnorePointer(
        ignoring: !enabled,
        child: Opacity(
          opacity: enabled ? 1 : 0.45,
          child: InsuranceDropdownWidget(
            key: ValueKey(
              'variant_${insuranceController.selectedModelId.value}_${insuranceController.selectedFuelTypeId.value}_${insuranceController.variantsList.length}',
            ),
            label: 'Variant',
            hintText: enabled ? 'Select variant' : 'Select fuel type first',
            icon: Icons.tune_rounded,
            items: insuranceController.variantsList
                .map((variant) => variant['variantName'] as String)
                .toList(),
            isRequired: true,
            onChanged: (value) => insuranceController.onVariantSelected(value),
            validator: (value) {
              if (value == 'invalid') {
                return 'This Car Variant is not available';
              }
              return null;
            },
          ),
        ),
      );
    });
  }

  // Manufacture Date
  Widget _buildManufactureDate() {
    return TextFormField(
      controller: insuranceController.manufactureDateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Manufacture Date',
        hintText: 'Select month and year',
        prefixIcon: const Icon(
          Icons.calendar_today,
          color: AppColors.green,
          size: 15,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.black87,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.3)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.4),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.2)),
        ),
      ),
      onTap: () async {
        final DateTime now = DateTime.now();

        final DateTime? picked = await showMonthYearPicker(
          context: Get.context!,
          locale: const Locale('en'),
          initialDate: DateTime(now.year, now.month, 1),
          firstDate: DateTime(1980, 1, 1),
          lastDate: DateTime(now.year, now.month, 1),
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: const TextScaler.linear(0.9),
              ),
              child: child!,
            );
          },
        );

        if (picked != null) {
          // User selected month/year -> auto day = 1
          final DateTime selectedDate = DateTime(picked.year, picked.month, 1);

          // Minus 2 months
          final DateTime adjustedDate = DateTime(
            selectedDate.year,
            selectedDate.month - 2,
            1,
          );

          // Treat adjustedDate as IST midnight and convert to UTC
          // Example:
          // 2024-03-01 00:00:00 IST
          // => 2024-02-29T18:30:00.000Z
          final DateTime utcDate = DateTime.utc(
            adjustedDate.year,
            adjustedDate.month,
            adjustedDate.day,
          ).subtract(const Duration(hours: 5, minutes: 30));

          final String utcIsoString = utcDate.toIso8601String();

          // Save API value
          insuranceController.selectedManufacturingDate.value = utcIsoString;

          // Show selected month/year to user
          insuranceController.manufactureDateController.text =
              '${picked.month.toString().padLeft(2, '0')}/${picked.year}';

          debugPrint('Selected by user: ${picked.month}/${picked.year}');
          debugPrint('Adjusted date: $adjustedDate');
          debugPrint('UTC ISO: $utcIsoString');
        }
      },
    );
  }

  Widget _buildManufactureDate1() {
    return TextFormField(
      controller: insuranceController.manufactureDateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Manufacture Date',
        hintText: 'Select month and year',
        prefixIcon: const Icon(
          Icons.calendar_today,
          color: AppColors.green,
          size: 15,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.black87,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.3)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.4),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.2)),
        ),
      ),
      onTap: () async {
        final DateTime now = DateTime.now();

        final DateTime? picked = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime(now.year, now.month, 1),
          firstDate: DateTime(2000, 1, 1),
          lastDate: DateTime(now.year, now.month, 1),
          initialDatePickerMode: DatePickerMode.year,
        );

        if (picked != null) {
          final int year = picked.year;
          final int month = picked.month;

          // always store 1st day of selected month
          insuranceController.selectedManufacturingDate.value =
              '${year.toString().padLeft(4, '0')}-'
              '${month.toString().padLeft(2, '0')}-'
              '01T00:00:00.000Z';

          // show MM/YYYY only
          insuranceController.manufactureDateController.text =
              '${month.toString().padLeft(2, '0')}/$year';
        }
      },
    );
  }

  // Show owner type options
  Widget _buildOwnerTypeOptions() {
    final options = insuranceController.ownerTypeOptions;

    return Obx(
      () => Column(
        children: List.generate(options.length, (index) {
          final option = options[index];
          final isSelected =
              insuranceController.selectedOwnerType.value == option['value'];

          return GestureDetector(
            onTap: () => insuranceController.onOwnerTypeChanged(index),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF111827),
                        width: 1.3,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.green,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option['label'],
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // Show policy type options
  Widget _buildPolicyTypeOptions() {
    final options = insuranceController.policyTypeOptions;

    return Obx(
      () => Column(
        children: List.generate(options.length, (index) {
          final option = options[index];
          final isSelected =
              insuranceController.selectedPolicyType.value == option['value'];

          return GestureDetector(
            onTap: () => insuranceController.onPolicyTypeChanged(index),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF111827),
                        width: 1.3,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.green,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option['label'],
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildQuotesSection() {
    return Obx(() {
      // if (!insuranceController.isUsedCar) {
      //   return const SizedBox.shrink();
      // }

      if (!insuranceController.hasFetchedQuotes.value) {
        return const SizedBox.shrink();
      }

      final bool hasQuotes = insuranceController.hasQuotes;
      final bool hasRedirectLink = insuranceController.hasRedirectLink;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            // if (insuranceController.quoteMessage.value.isNotEmpty)
            //   Container(
            //     width: double.infinity,
            //     padding: const EdgeInsets.all(12),
            //     decoration: BoxDecoration(
            //       color: hasQuotes
            //           ? AppColors.green.withValues(alpha: 0.1)
            //           : AppColors.red.withValues(alpha: 0.1),
            //       borderRadius: BorderRadius.circular(12),
            //       border: Border.all(
            //         color: hasQuotes
            //             ? AppColors.green.withValues(alpha: 0.4)
            //             : AppColors.red.withValues(alpha: 0.4),
            //       ),
            //     ),
            //     child: Text(
            //       insuranceController.quoteMessage.value,
            //       style: TextStyle(
            //         fontSize: 13,
            //         fontWeight: FontWeight.w600,
            //         color: hasQuotes ? AppColors.green : AppColors.red,
            //       ),
            //     ),
            //   ),
            if (hasQuotes) ...[
              // const SizedBox(height: 20),
              Text(
                'Fetched Quotes...',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 15),
              _buildQuotesList(),
            ],

            if (!hasRedirectLink) ...[
              const SizedBox(height: 16),
              Text(
                'Proceed option is not available right now.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],

            if (hasRedirectLink) ...[
              const SizedBox(height: 10),
              Obx(() {
                final redirectLink = insuranceController.redirectLink.value;

                final isLoading =
                    insuranceController.proceedLoadingMap[redirectLink] ??
                    false;

                return ButtonWidget(
                  text: 'Proceed',
                  isLoading: isLoading.obs,
                  height: 35,
                  width: 200,
                  fontSize: 12,
                  elevation: 5,
                  onTap: () {
                    insuranceController.openRedirectLinkPage(
                      proceedRedirectLink:
                          insuranceController.redirectLink.value,
                    );
                  },
                );
              }),
              const SizedBox(height: 15),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildQuotesList() {
    return Obx(
      () => Column(
        children: List.generate(insuranceController.quotes.length, (index) {
          final quote = insuranceController.quotes[index];
          return _buildQuoteCard(quote, index);
        }),
      ),
    );
  }

  Widget _buildQuoteCard(dynamic quote, int index) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: quote is Map
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quote ${index + 1}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 10),
                ...quote.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            '${entry.key}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 6,
                          child: Text(
                            _formatValue(entry.value),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Text(
              _formatValue(quote),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
    );
  }

  String _formatValue(dynamic value) {
    if (value == null) return '-';

    if (value is Map || value is List) {
      return jsonEncode(value);
    }

    return value.toString();
  }

  // Should show this widget
  Widget _buildShouldShowWidget({
    required bool showWidget,
    required Widget widget,
    double bottomSpace = 15,
  }) {
    return showWidget
        ? Column(
            children: [
              widget,
              SizedBox(height: bottomSpace),
            ],
          )
        : const SizedBox.shrink();
  }

  // Generated Quotes List
  Widget _buildGeneratedQuotesList() {
    return Obx(
      () => Column(
        children: List.generate(
          insuranceController.generatedQuotesList.length,
          (index) {
            final quote = insuranceController.generatedQuotesList[index];
            return _buildInsuranceQuoteCard(quote);
          },
        ),
      ),
    );
  }

  // Generated Quote Card
  // Generated Quote Card
  Widget _buildInsuranceQuoteCard(Map<String, dynamic> report) {
    final String carType = (report['carType'] ?? '').toString();
    final bool isUsedCar = carType.toLowerCase() == 'used car';

    final List<dynamic> quotes = report['quotes'] is List
        ? report['quotes']
        : [];

    final bool hasRedirectLink = (report['redirectLink'] ?? '')
        .toString()
        .trim()
        .isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xff8fa4c1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isUsedCar
              ? _buildUsedCarQuoteDetails(report)
              : _buildNewCarQuoteDetails(report),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1),
          ),

          Row(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                size: 16,
                color: Color(0xff143d79),
              ),
              const SizedBox(width: 6),
              const Text(
                'Available Quotes',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff143d79),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (quotes.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xfff5f7fa),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'No quotes available',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            )
          else
            Column(
              children: List.generate(quotes.length, (index) {
                final quote = quotes[index] as Map<String, dynamic>;

                return Container(
                  margin: EdgeInsets.only(
                    bottom: index == quotes.length - 1 ? 0 : 8,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xfff8fbff),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xffd8e4f2)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          (quote['insurer'] ?? '-').toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff143d79),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Premium: ₹${quote['premium'] ?? '-'}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'IDV: ₹${quote['idv'] ?? '-'}',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  hasRedirectLink
                      ? 'Proceed option available'
                      : 'Proceed option is not available',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: hasRedirectLink
                        ? const Color(0xff1e9f39)
                        : Colors.black54,
                  ),
                ),
              ),
              if (hasRedirectLink) ...[
                const SizedBox(width: 10),
                Obx(() {
                  final redirectLink = (report['redirectLink'] ?? '')
                      .toString();

                  final isLoading =
                      insuranceController.proceedLoadingMap[redirectLink] ??
                      false;

                  return ButtonWidget(
                    text: 'PROCEED',
                    isLoading: isLoading.obs,
                    onTap: () {
                      insuranceController.openRedirectLinkPage(
                        proceedRedirectLink: redirectLink,
                      );
                    },
                    width: 90,
                    height: 28,
                    fontSize: 10.5,
                    borderRadius: 5,
                    elevation: 1,
                    backgroundColor: const Color(0xff153d79),
                  );
                }),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsedCarQuoteDetails(Map<String, dynamic> report) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 82,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xffeef2f7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                CupertinoIcons.car_fill,
                size: 40,
                color: Color(0xffa56a00),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 82,
              child: Text(
                (report['registrationNumber'] ?? '-').toString(),
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff143d79),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Used Car Insurance',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff143d79),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xfffff0d6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xffe0b96f)),
                    ),
                    child: Text(
                      (report['carType'] ?? '-').toString(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Color(0xffa56a00),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoText(
                'Registration Number',
                (report['registrationNumber'] ?? '-').toString(),
              ),
              _buildInfoText(
                'Policy Type',
                (report['policyType'] ?? '-').toString(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewCarQuoteDetails(Map<String, dynamic> report) {
    final String title = [
      (report['makeName'] ?? '').toString(),
      (report['modelName'] ?? '').toString(),
      (report['variantName'] ?? '').toString(),
    ].where((e) => e.trim().isNotEmpty).join(' ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 82,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xffeef2f7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                CupertinoIcons.car_detailed,
                size: 40,
                color: AppColors.green,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 82,
              child: Text(
                (report['registrationRtoCode'] ?? '-').toString(),
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff143d79),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title.isEmpty ? 'New Car Insurance' : title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff143d79),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffd6ffd9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xff7ed58c)),
                    ),
                    child: Text(
                      (report['carType'] ?? '-').toString(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppColors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // _buildInfoText(
              //   'Policy Type',
              //   (report['policyType'] ?? '-').toString(),
              // ),
              Row(
                children: [
                  _buildInfoText(
                    'RTO',
                    (report['registrationRtoCode'] ?? '-').toString(),
                  ),
                  const SizedBox(width: 10),
                  _buildInfoText(
                    'Fuel Type',
                    (report['fuelType'] ?? '-').toString(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 10,
                runSpacing: 6,
                children: [
                  _buildMiniChip(
                    'Make',
                    (report['makeName'] ?? '-').toString(),
                  ),
                  _buildMiniChip(
                    'Model',
                    (report['modelName'] ?? '-').toString(),
                  ),
                  _buildMiniChip(
                    'Variant',
                    (report['variantName'] ?? '-').toString(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helpers for generated quotes list
  Widget _buildInfoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 10.5, color: Colors.black87),
          children: [
            TextSpan(
              text: '$label - ',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            TextSpan(
              text: value.isEmpty ? '-' : value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xffeef4fb),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffd7e4f2)),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 10, color: Colors.black87),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: value.isEmpty ? '-' : value,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
