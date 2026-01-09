import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/new_and_used_cars_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/views/pdi_payment_page.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';

class NewAndUsedCarsPdiPage extends StatelessWidget {
  final String serviceCategory;
  const NewAndUsedCarsPdiPage({super.key, required this.serviceCategory});

  static const Color _border = Color(0xFFCED7E6);
  static const Color _outerBg = Color(0xFFE9EDF3);
  static const Color _innerPanel = Color(0xFFB7C4D6);
  static const Color _titleBlue = Color(0xFF0D2B55);
  static const Color _red = Color(0xFFE3001B);

  @override
  Widget build(BuildContext context) {
    final NewAndUsedCarsController c = Get.put(
      NewAndUsedCarsController(serviceCategory),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: serviceCategory),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 14),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: PageView(
                  controller: c.pageController,
                  onPageChanged: c.onPageChanged,
                  physics: const NeverScrollableScrollPhysics(), // ✅ no swipe
                  children: [
                    _buildPageOne(context, c),
                    _buildPageTwo(context, c), // ✅ implemented
                    _buildPageThree(c),
                    // _buildPageFour(c, 'Price Summary', 'Coming next (dummy)'),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Dots indicator
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

              // Primary button
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
                    () => Text(
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
      ),
    );
  }

  // ========================= PAGE 1 (your existing) =========================
  Widget _buildPageOne(BuildContext context, NewAndUsedCarsController c) {
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
                      if (c.isUsedCar) ...[
                        _buildLabel('Enter Car Registration Number'),
                        const SizedBox(height: 6),
                        Obx(
                          () => _buildDropdown(
                            hint: 'WB 02AN XXXX',
                            value: c.selectedReg.value.isEmpty
                                ? null
                                : c.selectedReg.value,
                            onTap: c.onTapRegistration,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      _buildLabel('Select Car Brand'),
                      const SizedBox(height: 6),
                      Obx(
                        () => _buildDropdown(
                          hint: 'Select a Brand',
                          value: c.selectedBrand.value.isEmpty
                              ? null
                              : c.selectedBrand.value,
                          onTap: c.onTapBrand,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabel('Select Car Model'),
                      const SizedBox(height: 6),
                      Obx(
                        () => _buildDropdown(
                          hint: 'Select a Model',
                          value: c.selectedModel.value.isEmpty
                              ? null
                              : c.selectedModel.value,
                          onTap: c.onTapModel,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabel('Select Car Variant'),
                      const SizedBox(height: 6),
                      Obx(
                        () => _buildDropdown(
                          hint: 'Select a Variant',
                          value: c.selectedVariant.value.isEmpty
                              ? null
                              : c.selectedVariant.value,
                          onTap: c.onTapVariant,
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
                      if (c.isUsedCar) ...[
                        const SizedBox(height: 14),
                        _buildLabel('Check Car Service History'),
                        const SizedBox(height: 8),
                        Obx(() => _buildYesNo(c)),
                      ],
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

  // ========================= PAGE 2 (NEW) =========================
  Widget _buildPageTwo(BuildContext context, NewAndUsedCarsController c) {
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
                      // Select Date
                      _buildLabel('Select Date'),
                      const SizedBox(height: 8),
                      _buildDateRow(c),
                      const SizedBox(height: 12),

                      // Select Time Slot
                      _buildLabel('Select Time Slot'),
                      const SizedBox(height: 8),
                      _buildTimeSlots(c),
                      const SizedBox(height: 14),

                      // Consumer / Business
                      Row(
                        children: [
                          _buildTypeBox(
                            text: 'Consumer',
                            c: c,
                            selected:
                                c.selectedCustomerType.value == 'Consumer',
                            onTap: () => c.setCustomerType('Consumer'),
                          ),
                          const SizedBox(width: 45),
                          _buildTypeBox(
                            text: 'Business',
                            c: c,
                            selected:
                                c.selectedCustomerType.value == 'Business',
                            onTap: () => c.setCustomerType('Business'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Billing Address
                      _buildLineField(
                        label: 'Billing Address',
                        controller: c.billingAddressController,
                      ),
                      const SizedBox(height: 16),

                      // Visit Address
                      _buildLineField(
                        label: 'Visit Address',
                        controller: c.visitAddressController,
                      ),
                      const SizedBox(height: 16),

                      // Representative Number
                      _buildLineField(
                        label: 'Customer/ Car Representative Number',
                        controller: c.repNumberController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      // Pincode dropdown
                      Obx(
                        () => _buildDropdown(
                          hint: 'Select a Pincode',
                          value: c.selectedPincode.value.isEmpty
                              ? null
                              : c.selectedPincode.value,
                          onTap: c.onTapPincode,
                        ),
                      ),
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

  Widget _buildDateRow(NewAndUsedCarsController c) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: c.dateOptions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final item = c.dateOptions[i];
                  final selected = c.selectedDateIndex.value == i;

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
                          color: selected
                              ? _titleBlue.withOpacity(0.6)
                              : Colors.transparent,
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
            ),
          ),
          // const SizedBox(width: 8),
          // InkWell(
          //   onTap: c.rotateDatesForward,
          //   borderRadius: BorderRadius.circular(10),
          //   child: const Padding(
          //     padding: EdgeInsets.all(4),
          //     child: Icon(
          //       Icons.chevron_right_rounded,
          //       size: 26,
          //       color: _titleBlue,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildTimeSlots(NewAndUsedCarsController c) {
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
    required bool selected,
    required VoidCallback onTap,
    required NewAndUsedCarsController c,
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
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _titleBlue,
          ),
          decoration: const InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        Container(height: 1, color: _titleBlue.withOpacity(0.55)),
      ],
    );
  }

  Widget _buildPageThree(NewAndUsedCarsController c) {
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
            // Inner panel like screenshot
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== Key Features box =====
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

                    // ===== Price summary box =====
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _innerPanel,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Obx(
                        () => Column(
                          children: [
                            _buildPriceRow(
                              left: c.pdiLineTitle,
                              right: c.formatRupee(c.basePdiPrice.value),
                            ),
                            const SizedBox(height: 8),
                            _buildPriceRow(
                              left: 'Visit Charge',
                              right: c.formatRupee(c.visitCharge.value),
                            ),
                            if (c.discountAmount.value > 0) ...[
                              const SizedBox(height: 8),
                              _buildPriceRow(
                                left: 'Discount',
                                right:
                                    '- ${c.formatRupee(c.discountAmount.value)}',
                                rightColor: const Color(0xFF11B34A),
                              ),
                            ],
                            const SizedBox(height: 10),
                            Container(
                              height: 1,
                              color: _titleBlue.withOpacity(0.35),
                            ),
                            const SizedBox(height: 10),
                            _buildPriceRow(
                              left: 'Total',
                              right: c.formatRupee(c.totalPrice),
                              isBold: true,
                            ),
                            const SizedBox(height: 12),

                            // Offers & Coupon dropdown
                            InkWell(
                              onTap: c.onOfferCouponTap,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _titleBlue.withOpacity(0.35),
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: _titleBlue.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(
                                        Icons.percent_rounded,
                                        size: 16,
                                        color: _titleBlue,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        c.selectedOfferCoupon.value,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: _titleBlue,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: _titleBlue,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildPageFour(NewAndUsedCarsController c, String title, String sub) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _outerBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _border),
        ),
        child: Column(children: [Expanded(child: PdiPaymentPage())]),
      ),
    );
  }

  // ========================= COMMON HELPERS =========================
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

  Widget _buildYesNo(NewAndUsedCarsController c) {
    final selected = c.serviceHistoryYes.value;

    Widget box(bool isYes) {
      final bool checked = selected == isYes;
      return InkWell(
        onTap: () => c.setServiceHistory(isYes),
        borderRadius: BorderRadius.circular(6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: checked ? _titleBlue : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _titleBlue, width: 1.5),
              ),
              child: checked
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              isYes ? 'Yes' : 'No',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: _titleBlue,
              ),
            ),
          ],
        ),
      );
    }

    return Row(children: [box(true), const SizedBox(width: 40), box(false)]);
  }
}
