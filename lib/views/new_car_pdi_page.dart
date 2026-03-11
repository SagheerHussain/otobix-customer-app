import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/new_car_pdi_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/shimmer_widget.dart';

class NewCarPdiPage extends StatelessWidget {
  NewCarPdiPage({super.key});

  static const Color _border = Color(0xFFCED7E6);
  static const Color _outerBg = Color(0xFFE9EDF3);
  static const Color _innerPanel = Color(0xFFB7C4D6);
  static const Color _titleBlue = Color(0xFF0D2B55);
  static const Color _red = Color(0xFFE3001B);

  final NewCarPdiController c = Get.put(NewCarPdiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: 'New Car PDI'),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 14),
            Expanded(
              child: PageView(
                controller: c.pageController,
                onPageChanged: c.onPageChanged,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildPageOne(context, c),
                  _buildPageTwo(context, c),
                  _buildPageThree(c),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  c.totalPages,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: c.currentPage.value == i ? 18 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: c.currentPage.value == i
                          ? _titleBlue
                          : _titleBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            InkWell(
              onTap: c.onPrimaryButtonTap,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 40,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: _red,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Obx(
                  () => c.isSubmitPdiLoading.value
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: AppColors.white,
                          ),
                        )
                      : Text(
                          c.primaryButtonText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ========================= PAGE 1 =========================
  Widget _buildPageOne(BuildContext context, NewCarPdiController c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _outerBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _border),
        ),
        child: Column(
          children: [
            _buildPageOneTitle(),
            const SizedBox(height: 12),
            Flexible(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                  decoration: BoxDecoration(
                    color: _innerPanel,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Select Car Brand'),
                      const SizedBox(height: 6),
                      Obx(
                        () => _buildDropdown(
                          hint: 'Select a Brand',
                          value: c.selectedMake.value.isEmpty
                              ? null
                              : c.selectedMake.value,
                          onTap: c.onTapMake,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabel('Select Car Model'),
                      const SizedBox(height: 6),
                      Obx(
                        () => _buildDropdown(
                          hint: c.selectedMake.value.isEmpty
                              ? 'Select brand first'
                              : 'Select a Model',
                          value: c.selectedModel.value.isEmpty
                              ? null
                              : c.selectedModel.value,
                          onTap: c.onTapModel,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildLabel('Select Car Fuel Type'),
                      const SizedBox(height: 6),
                      Obx(
                        () => _buildDropdown(
                          hint: 'Select a Fuel Type',
                          value: c.selectedFuel.value.isEmpty
                              ? null
                              : c.selectedFuel.value,
                          onTap: c.onTapFuel,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabel('Select Car Transmission'),
                      const SizedBox(height: 6),
                      Obx(
                        () => _buildDropdown(
                          hint: 'Select a Transmission',
                          value: c.selectedTransmission.value.isEmpty
                              ? null
                              : c.selectedTransmission.value,
                          onTap: c.onTapTransmission,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Obx(() {
              if (c.selectedModel.value.isEmpty) {
                return const SizedBox.shrink();
              }
              if (c.isFetchPdiPriceLoading.value) {
                return _buildPriceLoading();
              }
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _innerPanel,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _buildPriceRow(
                      left: 'PDI Price',
                      right: c.formatRupee(c.rate.value),
                    ),
                    const SizedBox(height: 8),

                    _buildPriceRow(
                      left: 'GST',
                      right: c.formatRupee(c.gst.value),
                    ),
                    const SizedBox(height: 8),
                    _buildPriceRow(
                      left: 'Total',
                      right: c.formatRupee(c.total.value),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPageOneTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: const TextSpan(
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: _titleBlue,
          ),
          children: [
            TextSpan(text: 'Enter Your '),
            TextSpan(
              text: 'Car',
              style: TextStyle(color: _red),
            ),
            TextSpan(text: ' Details'),
          ],
        ),
      ),
    );
  }

  // ========================= PAGE 2 =========================
  Widget _buildPageTwo(BuildContext context, NewCarPdiController c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _outerBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _border),
        ),
        child: Column(
          children: [
            _buildPageTwoTitle(),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                  decoration: BoxDecoration(
                    color: _innerPanel,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Select Date'),
                      const SizedBox(height: 8),
                      _buildDateRow(c),
                      const SizedBox(height: 12),

                      _buildLabel('Select Time Slot'),
                      const SizedBox(height: 8),
                      _buildTimeSlots(c),
                      const SizedBox(height: 14),

                      Row(
                        children: [
                          _buildTypeBox(
                            text: 'Consumer',
                            c: c,
                            onTap: () => c.setCustomerType('Consumer'),
                          ),
                          const SizedBox(width: 45),
                          _buildTypeBox(
                            text: 'Business',
                            c: c,
                            onTap: () => c.setCustomerType('Business'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildLineField(
                        label: 'Billing Address (Optional)',
                        controller: c.billingAddressController,
                      ),
                      const SizedBox(height: 16),

                      _buildLineField(
                        label: 'Visit Address',
                        controller: c.visitAddressController,
                      ),
                      const SizedBox(height: 16),

                      _buildLineField(
                        label: "Customer's Contact Number",
                        controller: c.customerPhoneNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        enabled: false,
                      ),
                      const SizedBox(height: 16),

                      _buildPincodeFieldLikeDropdown(c),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPincodeFieldLikeDropdown(NewCarPdiController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Pincode (6 digits)'),
        const SizedBox(height: 6),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
          ),
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: c.pincodeController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF23324A),
            ),
            decoration: const InputDecoration(
              hintText: 'Enter Pincode',
              hintStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6B7A94),
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageTwoTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: const TextSpan(
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: _titleBlue,
          ),
          children: [
            TextSpan(text: 'Book '),
            TextSpan(
              text: 'Appointment',
              style: TextStyle(color: _red),
            ),
            TextSpan(text: ' & Enter '),
            TextSpan(
              text: 'Address',
              style: TextStyle(color: _red),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ FIXED: Date selection works
  Widget _buildDateRow(NewCarPdiController c) {
    return Obx(() {
      // ✅ FORCE Obx to subscribe (read values here)
      final selectedIndex = c.selectedDateIndex.value;
      final dates = c.dateOptions.toList();

      return SizedBox(
        height: 50,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: dates.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final item = dates[i];
            final selected = selectedIndex == i;

            return InkWell(
              onTap: () => c.selectDate(i),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 65,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selected ? _titleBlue : Colors.transparent,
                    width: selected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['label'] ?? '',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: _titleBlue,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['date'] ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: _titleBlue,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildTimeSlots(NewCarPdiController c) {
    return Obx(
      () => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: c.timeSlots.map((slot) {
          final selected = c.selectedTimeSlot.value == slot;
          return InkWell(
            onTap: () => c.selectTimeSlot(slot),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? _titleBlue : Colors.transparent,
                  width: selected ? 1.5 : 0,
                ),
              ),
              child: Text(
                slot,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: _titleBlue,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTypeBox({
    required String text,
    required NewCarPdiController c,
    required VoidCallback onTap,
  }) {
    return Obx(
      () => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: c.selectedCustomerType.value == text
                    ? _titleBlue
                    : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _titleBlue, width: 1.2),
              ),
              child: c.selectedCustomerType.value == text
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: _titleBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: _titleBlue,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _titleBlue,
          ),
          decoration: InputDecoration(
            enabled: enabled,
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        Container(height: 1, color: _titleBlue.withOpacity(0.55)),
      ],
    );
  }

  // ========================= PAGE 3 =========================
  Widget _buildPageThree(NewCarPdiController c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _outerBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _border),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _innerPanel,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Key Features',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: _titleBlue,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => Column(
                              children: List.generate(c.keyFeatures.length, (
                                i,
                              ) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.check_rounded,
                                        size: 18,
                                        color: Color(0xFF11B34A),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          c.keyFeatures[i],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: _titleBlue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _innerPanel,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Obx(() {
                        if (c.isFetchPdiPriceLoading.value) {
                          return _buildPriceLoading();
                        }
                        return Column(
                          children: [
                            _buildPriceRow(
                              left: 'PDI Price',
                              right: c.formatRupee(c.rate.value),
                            ),
                            const SizedBox(height: 8),

                            _buildPriceRow(
                              left: 'GST',
                              right: c.formatRupee(c.gst.value),
                            ),
                            const SizedBox(height: 8),
                            _buildPriceRow(
                              left: 'Total',
                              right: c.formatRupee(c.total.value),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow({
    required String left,
    required String right,
    bool isBold = false,
    Color rightColor = _titleBlue,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
              color: _titleBlue,
            ),
          ),
        ),
        Text(
          right,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w800,
            color: rightColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: _titleBlue,
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: value == null
                      ? const Color(0xFF6B7A94)
                      : const Color(0xFF23324A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down_rounded, color: Color(0xFF23324A)),
          ],
        ),
      ),
    );
  }

  // Price Loading
  Widget _buildPriceLoading() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(height: 15, width: 100),
            ShimmerWidget(height: 15, width: 40),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(height: 15, width: 120),
            ShimmerWidget(height: 15, width: 40),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(height: 15, width: 150),
            ShimmerWidget(height: 15, width: 40),
          ],
        ),
      ],
    );
  }
}
