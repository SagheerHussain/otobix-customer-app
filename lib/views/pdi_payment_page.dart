import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/pdi_payment_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';

class PdiPaymentPage extends StatelessWidget {
  PdiPaymentPage({super.key});

  final PdiPaymentController c = Get.put(
    PdiPaymentController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFE9EDF3),
      appBar: AppBarWidget(title: 'PDI Payment'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _priceSummaryCard(),
              const SizedBox(height: 14),
              _allPaymentOptionsTitle(),
              const SizedBox(height: 10),
              _paymentTileUpi(context),
              const SizedBox(height: 10),
              _paymentTileCards(context),
              const SizedBox(height: 10),
              _paymentTileNetBanking(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: c.colors.cardBg,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Price Summary',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: c.colors.navy,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: c.colors.navy,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    c.warrantyLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  c.priceSeparator,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  c.warrantyPrice,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _allPaymentOptionsTitle() {
    return Text(
      'All Payment Options',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: c.colors.navy,
      ),
    );
  }

  Widget _paymentTileUpi(BuildContext context) {
    return Obx(() {
      final expanded = c.expandedSection.value == PdiPaymentSection.upi;

      return Container(
        decoration: BoxDecoration(
          color: c.colors.cardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => c.toggleSection(PdiPaymentSection.upi),
              child: Row(
                children: [
                  Icon(
                    Icons.play_arrow_outlined,
                    size: 25,
                    color: c.colors.navy,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      c.upiTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: c.colors.navy,
                      ),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 25,
                    color: c.colors.navy,
                  ),
                ],
              ),
            ),
            if (expanded) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: c.colors.border),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.qr_code_2_rounded,
                                    size: 110,
                                    color: c.colors.primaryText.withValues(
                                      alpha: 0.85,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                    onPressed: c.toggleQrVisibility,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      foregroundColor: Colors.black,
                                      elevation: 1,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 7,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(22),
                                        side: BorderSide(
                                          color: c.colors.border,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      c.qrButtonText,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.upiHintTitle,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: c.colors.primaryText,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: c.upiApps
                                    .map(
                                      (app) => _circleAppIcon(
                                        label: app.label,
                                        bg: app.bg,
                                        fg: app.fg,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: c.colors.border, width: 1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.upiFieldLabel,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: c.colors.primaryText,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: c.upiIdController,
                                      onChanged: c.onUpiChanged,
                                      decoration: InputDecoration(
                                        hintText: c.upiHintText,
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 12,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: c.colors.border,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: c.colors.navy,
                                            width: 1.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ButtonWidget(
                                    text: c.submitText,
                                    height: 35,
                                    width: 100,
                                    fontSize: 12,
                                    backgroundColor: AppColors.blue,
                                    isLoading: c.isWarrantyPaymentLoading,
                                    onTap: () => c.submitUpi(context),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _paymentTileCards(BuildContext context) {
    return Obx(() {
      final expanded = c.expandedSection.value == PdiPaymentSection.cards;

      return Container(
        decoration: BoxDecoration(
          color: c.colors.cardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => c.toggleSection(PdiPaymentSection.cards),
              child: Row(
                children: [
                  Icon(
                    Icons.credit_card_outlined,
                    size: 25,
                    color: c.colors.navy,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      c.cardsTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: c.colors.navy,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children: c.cardsBadges.map((b) => _badge(b)).toList(),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 25,
                    color: c.colors.navy,
                  ),
                ],
              ),
            ),
            if (expanded) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // Card Number Field
                    _buildCardField(
                      label: 'Card Number',
                      hint: '1234 5678 9012 3456',
                      prefixIcon: Icons.credit_card,
                    ),
                    const SizedBox(height: 12),

                    // Name on Card Field
                    _buildCardField(
                      label: 'Name on Card',
                      hint: 'Amit Parekh',
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 12),

                    // Expiry & CVV Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildCardField(
                            label: 'Expiry Date',
                            hint: 'MM/YY',
                            prefixIcon: Icons.calendar_today_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCardField(
                            label: 'CVV',
                            hint: '123',
                            prefixIcon: Icons.lock_outline,
                            isObscure: true,
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 16),

                    // Remember Card Checkbox
                    // Row(
                    //   children: [
                    //     Obx(
                    //       () => Checkbox(
                    //         value: c.rememberCard.value,
                    //         onChanged: (value) => c.rememberCard.value = value!,
                    //         activeColor: c.colors.navy,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(4),
                    //         ),
                    //       ),
                    //     ),
                    //     Text(
                    //       'Save card for future payments',
                    //       style: TextStyle(
                    //         fontSize: 14,
                    //         color: c.colors.primaryText,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 16),

                    // Pay Now Button
                    ButtonWidget(
                      text: 'Pay ${c.warrantyPrice}',
                      isLoading: c.isWarrantyPaymentLoading,
                      height: 35,
                      width: double.infinity,
                      fontSize: 12,
                      backgroundColor: AppColors.blue,
                      onTap: () => c.submitCardPayment(context),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _paymentTileNetBanking(BuildContext context) {
    return Obx(() {
      final expanded = c.expandedSection.value == PdiPaymentSection.netBanking;

      return Container(
        decoration: BoxDecoration(
          color: c.colors.cardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => c.toggleSection(PdiPaymentSection.netBanking),
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_outlined,
                    size: 25,
                    color: c.colors.navy,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      c.netBankingTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: c.colors.navy,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children: c.netBankingBadges.map((b) => _badge(b)).toList(),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 25,
                    color: c.colors.navy,
                  ),
                ],
              ),
            ),
            if (expanded) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // Bank Selection Dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Bank',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: c.colors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            initialValue: c.selectedBank.value.isEmpty
                                ? null
                                : c.selectedBank.value,
                            items: c.bankList
                                .map(
                                  (bank) => DropdownMenuItem(
                                    value: bank.name,
                                    child: Text(bank.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                c.selectedBank.value = value;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Choose your bank',
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: c.colors.border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: c.colors.navy,
                                  width: 1.2,
                                ),
                              ),
                              suffixIcon: const Icon(Icons.arrow_drop_down),
                            ),
                            borderRadius: BorderRadius.circular(10),
                            icon: const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Popular Banks Grid
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Popular Banks',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: c.colors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 3,
                              ),
                          itemCount: c.popularBanks.length,
                          itemBuilder: (context, index) {
                            final bank = c.popularBanks[index];
                            return Obx(
                              () => GestureDetector(
                                onTap: () => c.selectedBank.value = bank.name,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: c.colors.cardBg,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: c.selectedBank.value == bank.name
                                          ? c.colors.navy
                                          : c.colors.border,
                                      width: c.selectedBank.value == bank.name
                                          ? 1.5
                                          : 1,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.white,
                                        child: Text(
                                          bank.shortName.characters.first,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: c.colors.navy,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          bank.shortName,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: c.colors.primaryText,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Pay Now Button
                    ButtonWidget(
                      text: 'Pay ${c.warrantyPrice}',
                      isLoading: c.isWarrantyPaymentLoading,
                      height: 35,
                      width: double.infinity,
                      fontSize: 12,
                      backgroundColor: AppColors.blue,
                      onTap: () => c.submitNetBankingPayment(context),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildCardField({
    required String label,
    required String hint,
    required IconData prefixIcon,
    bool isObscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: c.colors.primaryText,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          obscureText: isObscure,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(prefixIcon, size: 20),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: c.colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: c.colors.navy, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _badge(String text) {
    return Container(
      width: 32,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: c.colors.border),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: c.colors.primaryText,
        ),
      ),
    );
  }

  Widget _circleAppIcon({
    required String label,
    required Color bg,
    required Color fg,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: bg,
          child: Text(
            label.characters.first.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w800, color: fg),
          ),
        ),
      ],
    );
  }
}
