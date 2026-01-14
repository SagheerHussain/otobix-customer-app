import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/buy_a_car_filters_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';

class BuyACarFiltersWidget extends StatelessWidget {
  BuyACarFiltersWidget({super.key, required this.onApplyPressed});

  /// Call your BuyACarController method here to refresh list.
  final VoidCallback onApplyPressed;

  final BuyACarFiltersController fc = Get.put(BuyACarFiltersController());

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: suffixIcon needs compact sizing
    return SizedBox(
      width: 44,
      height: 44,
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _openBottomSheet(),
              child: const Icon(
                Icons.filter_alt_outlined,
                size: 20,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openBottomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.9,
        minChildSize: 0.7,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: _buildFilterContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Filter Cars',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // -------------------- MAKE / MODEL / VARIANT / CITY --------------------
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  label: 'Make',
                  hintText: 'Select Make',
                  valueRx: fc.selectedMake,
                  itemsRx: fc.makes,
                  onChanged: (v) => fc.onMakeChanged(v),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDropdown(
                  label: 'Dealer Location',
                  hintText: 'Select City',
                  valueRx: fc.selectedCity,
                  itemsRx: fc.cities,
                  onChanged: (v) => fc.selectedCity.value = v,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: Obx(
                  () => _buildDropdownSimple(
                    label: 'Model',
                    hintText: 'Select Model',
                    value: fc.selectedModel.value,
                    items: fc.modelsForSelectedMake,
                    onChanged: (v) => fc.onModelChanged(v),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(
                  () => _buildDropdownSimple(
                    label: 'Variant',
                    hintText: 'Select Variant',
                    value: fc.selectedVariant.value,
                    items: fc.variantsForSelectedModel,
                    onChanged: (v) => fc.selectedVariant.value = v,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // -------------------- FUEL TYPE (chips like your old UI) --------------------
          const Text(
            'Fuel Type',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 6,
              children: fc.fuelTypes.map((type) {
                final isSelected = fc.selectedFuelTypes.contains(type);
                return FilterChip(
                  label: Text(
                    type,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? AppColors.green : AppColors.black,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.green.withValues(alpha: .1),
                  checkmarkColor: AppColors.green,
                  showCheckmark: true,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      fc.selectedFuelTypes.add(type);
                    } else {
                      fc.selectedFuelTypes.remove(type);
                    }
                  },
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 15),

          // -------------------- TRANSMISSION --------------------
          const Text(
            'Transmission',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 6,
              children: fc.transmissionTypes.map((t) {
                final isSelected = fc.selectedTransmissions.contains(t);
                return FilterChip(
                  label: Text(
                    t,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? AppColors.green : AppColors.black,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.green.withValues(alpha: .1),
                  checkmarkColor: AppColors.green,
                  showCheckmark: true,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onSelected: (sel) {
                    if (sel) {
                      fc.selectedTransmissions.add(t);
                    } else {
                      fc.selectedTransmissions.remove(t);
                    }
                  },
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 15),

          // -------------------- BODY TYPE --------------------
          const Text(
            'Body Type',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 6,
              children: fc.bodyTypes.map((b) {
                final isSelected = fc.selectedBodyTypes.contains(b);
                return FilterChip(
                  label: Text(
                    b,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? AppColors.green : AppColors.black,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.green.withValues(alpha: .1),
                  checkmarkColor: AppColors.green,
                  showCheckmark: true,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onSelected: (sel) {
                    if (sel) {
                      fc.selectedBodyTypes.add(b);
                    } else {
                      fc.selectedBodyTypes.remove(b);
                    }
                  },
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 15),

          // -------------------- YEAR OF REG (bucket range slider) --------------------
          const Text(
            'Year of Registration',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Obx(() {
            final rv = fc.selectedRegBucket.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RangeSlider(
                  values: RangeValues(
                    rv.start.roundToDouble(),
                    rv.end.roundToDouble(),
                  ),
                  min: BuyACarFiltersController.minRegBucket,
                  max: BuyACarFiltersController.maxRegBucket,
                  divisions: 3,
                  labels: RangeLabels(
                    _regLabel(rv.start.round()),
                    _regLabel(rv.end.round()),
                  ),
                  onChanged: (values) {
                    fc.selectedRegBucket.value = RangeValues(
                      values.start.roundToDouble(),
                      values.end.roundToDouble(),
                    );
                  },
                  activeColor: AppColors.green,
                  inactiveColor: AppColors.grey.withValues(alpha: .3),
                ),
                Text(
                  '${_regLabel(rv.start.round())} - ${_regLabel(rv.end.round())}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 15),

          // -------------------- ODOMETER (bucket range slider) --------------------
          const Text(
            'Odometer (KMs)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Obx(() {
            final rv = fc.selectedOdoBucket.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RangeSlider(
                  values: RangeValues(
                    rv.start.roundToDouble(),
                    rv.end.roundToDouble(),
                  ),
                  min: BuyACarFiltersController.minOdoBucket,
                  max: BuyACarFiltersController.maxOdoBucket,
                  divisions: 3,
                  labels: RangeLabels(
                    _odoLabel(rv.start.round()),
                    _odoLabel(rv.end.round()),
                  ),
                  onChanged: (values) {
                    fc.selectedOdoBucket.value = RangeValues(
                      values.start.roundToDouble(),
                      values.end.roundToDouble(),
                    );
                  },
                  activeColor: AppColors.green,
                  inactiveColor: AppColors.grey.withValues(alpha: .3),
                ),
                Text(
                  '${_odoLabel(rv.start.round())} - ${_odoLabel(rv.end.round())}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 24),

          // -------------------- BUTTONS --------------------
          Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  text: 'Reset',
                  textColor: AppColors.white,
                  backgroundColor: AppColors.red,
                  height: 35,
                  isLoading: false.obs,
                  elevation: 5,
                  onTap: () {
                    fc.resetFilters();
                    Navigator.pop(Get.context!);
                    onApplyPressed(); // refresh list
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ButtonWidget(
                  text: 'Apply',
                  height: 35,
                  isLoading: false.obs,
                  elevation: 5,
                  onTap: () {
                    fc.applyFilters();
                    Navigator.pop(Get.context!);
                    onApplyPressed(); // refresh list
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // -------------------- Dropdown (same style as your old) --------------------
  Widget _buildDropdown({
    required String label,
    required String hintText,
    required RxnString valueRx,
    required RxList<String> itemsRx,
    required ValueChanged<String?> onChanged,
  }) {
    return Obx(
      () => _buildDropdownSimple(
        label: label,
        hintText: hintText,
        value: valueRx.value,
        items: itemsRx,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownSimple({
    required String label,
    required String hintText,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 5),
        Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.grey.withValues(alpha: .3)),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: .05),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              menuMaxHeight: 300,
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
              style: const TextStyle(fontSize: 13, color: AppColors.black),
              hint: Text(hintText, style: const TextStyle(fontSize: 12)),
              items: items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item, style: const TextStyle(fontSize: 12)),
                    ),
                  )
                  .toList(),
              onChanged: items.isEmpty ? null : onChanged,
            ),
          ),
        ),
      ],
    );
  }

  String _regLabel(int i) {
    if (i == 0) return '< 1';
    if (i == 1) return '1 - 3';
    if (i == 2) return '3 - 5';
    return '5+';
  }

  String _odoLabel(int i) {
    if (i == 0) return '< 10k';
    if (i == 1) return '10 - 30k';
    if (i == 2) return '30 - 50k';
    return '50k+';
  }
}
