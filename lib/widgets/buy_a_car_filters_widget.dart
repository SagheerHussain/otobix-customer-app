import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/buy_a_car_controller.dart';
import 'package:otobix_customer_app/controllers/buy_a_car_filters_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';

class BuyACarFiltersWidget extends StatelessWidget {
  BuyACarFiltersWidget({super.key, required this.onApplyPressed});

  final VoidCallback onApplyPressed;

  final BuyACarFiltersController fc = Get.find<BuyACarFiltersController>();

  @override
  Widget build(BuildContext context) {
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

          // MAKE / STATE
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => _buildSearchableDropdownField(
                    label: 'Make',
                    hintText: 'Select Make',
                    value: fc.selectedMake.value,
                    enabled: true,
                    isLoading: fc.isMakeLoading.value,
                    onTap: () => _openSearchSheet(
                      title: 'Select Make',
                      itemsRx: fc.makeOptions,
                      isLoadingRx: fc.isMakeLoading,
                      onSearch: fc.onMakeSearchChanged,
                      onSelect: (v) => fc.onMakePicked(v),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(
                  () => _buildSearchableDropdownField(
                    label: 'Dealer Location',
                    hintText: 'Select State',
                    value: fc.selectedState.value,
                    enabled: true,
                    isLoading: false,
                    onTap: () => _openSearchSheet(
                      title: 'Select State',
                      itemsRx: fc.states,
                      isLoadingRx: null,
                      onSearch: null,
                      onSelect: (v) => fc.selectedState.value = v,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // MODEL / VARIANT
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => _buildSearchableDropdownField(
                    label: 'Model',
                    hintText: fc.isModelEnabled.value
                        ? 'Select Model'
                        : 'Select make first',
                    value: fc.selectedModel.value,
                    enabled: fc.isModelEnabled.value,
                    isLoading: fc.isModelLoading.value,
                    onTap: fc.isModelEnabled.value
                        ? () => _openSearchSheet(
                            title: 'Select Model',
                            itemsRx: fc.modelOptions,
                            isLoadingRx: fc.isModelLoading,
                            onSearch: fc.onModelSearchChanged,
                            onSelect: (v) => fc.onModelPicked(v),
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(
                  () => _buildSearchableDropdownField(
                    label: 'Variant',
                    hintText: fc.isVariantEnabled.value
                        ? 'Select Variant'
                        : 'Select model first',
                    value: fc.selectedVariant.value,
                    enabled: fc.isVariantEnabled.value,
                    isLoading: fc.isVariantLoading.value,
                    onTap: fc.isVariantEnabled.value
                        ? () => _openSearchSheet(
                            title: 'Select Variant',
                            itemsRx: fc.variantOptions,
                            isLoadingRx: fc.isVariantLoading,
                            onSearch: fc.onVariantSearchChanged,
                            onSelect: (v) => fc.onVariantPicked(v),
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // FUEL
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

          // TRANSMISSION
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

          // BODY
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

          // CAR AGE
          const Text(
            'Car Age (Years)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Obx(() {
            final rv = fc.selectedCarAgeYears.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RangeSlider(
                  values: rv,
                  min: BuyACarFiltersController.minCarAgeYears,
                  max: BuyACarFiltersController.maxCarAgeYears,
                  divisions: 4,
                  labels: RangeLabels(
                    '${rv.start.round()} yr',
                    '${rv.end.round()} yr',
                  ),
                  onChanged: (values) {
                    fc.selectedCarAgeYears.value = RangeValues(
                      values.start.roundToDouble(),
                      values.end.roundToDouble(),
                    );
                  },
                  activeColor: AppColors.green,
                  inactiveColor: AppColors.grey.withValues(alpha: .3),
                ),
                Text(
                  '${rv.start.round()} year(s) - ${rv.end.round()} year(s)',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }),

          const SizedBox(height: 15),

          // MILEAGE
          const Text(
            'Mileage (KM Driven)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Obx(() {
            final rv = fc.selectedMileageKm.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RangeSlider(
                  values: rv,
                  min: BuyACarFiltersController.minMileageKm,
                  max: BuyACarFiltersController.maxMileageKm,
                  divisions: 4,
                  labels: RangeLabels(
                    '${(rv.start / 1000).round()}k',
                    '${(rv.end / 1000).round()}k',
                  ),
                  onChanged: (values) {
                    fc.selectedMileageKm.value = RangeValues(
                      values.start.roundToDouble(),
                      values.end.roundToDouble(),
                    );
                  },
                  activeColor: AppColors.green,
                  inactiveColor: AppColors.grey.withValues(alpha: .3),
                ),
                Text(
                  '${rv.start.round()} km - ${rv.end.round()} km',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }),

          const SizedBox(height: 24),

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
                    Navigator.pop(Get.context!);
                    Get.find<BuyACarController>().onResetFiltersPressed();
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
                    onApplyPressed();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchableDropdownField({
    required String label,
    required String hintText,
    required String? value,
    required bool enabled,
    required bool isLoading,
    required VoidCallback? onTap,
  }) {
    final opacity = enabled ? 1.0 : 0.45;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 5),
        Opacity(
          opacity: opacity,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(5),
            child: Container(
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
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      (value != null && value.trim().isNotEmpty)
                          ? value
                          : hintText,
                      style: TextStyle(
                        fontSize: 12,
                        color: (value != null && value.trim().isNotEmpty)
                            ? AppColors.black
                            : AppColors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isLoading) ...[
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 8),
                  ],
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openSearchSheet({
    required String title,
    required RxList<String> itemsRx,
    required RxBool? isLoadingRx,
    required void Function(String text)? onSearch,
    required void Function(String? value) onSelect,
  }) {
    final searchCtrl = TextEditingController();

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
          ),
          child: SizedBox(
            height: MediaQuery.of(Get.context!).size.height * 0.7,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: .4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(Get.context!),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: searchCtrl,
                    onChanged: (txt) {
                      if (onSearch != null) onSearch(txt);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Obx(() {
                    final all = itemsRx.toList();
                    final query = searchCtrl.text.trim().toLowerCase();

                    final filtered = query.isEmpty
                        ? all
                        : all
                              .where((e) => e.toLowerCase().contains(query))
                              .toList();

                    final loading = isLoadingRx?.value ?? false;

                    if (loading && all.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (filtered.isEmpty) {
                      return const Center(
                        child: Text(
                          'No results found',
                          style: TextStyle(fontSize: 12, color: AppColors.grey),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: AppColors.grey.withValues(alpha: .25),
                      ),
                      itemBuilder: (_, i) {
                        final v = filtered[i];
                        return ListTile(
                          dense: true,
                          title: Text(v, style: const TextStyle(fontSize: 13)),
                          onTap: () {
                            onSelect(v);
                            Navigator.pop(Get.context!);
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
