import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';

class SetExpectedPriceDialogWidget extends StatefulWidget {
  final String title;
  final RxBool isSetPriceLoading;
  final double? initialValue;
  final bool canIncreasePriceUpto150Percent;
  final Function(double) onPriceSelected;

  const SetExpectedPriceDialogWidget({
    super.key,
    required this.title,
    required this.isSetPriceLoading,
    this.initialValue,
    required this.canIncreasePriceUpto150Percent,
    required this.onPriceSelected,
  });

  @override
  State<SetExpectedPriceDialogWidget> createState() =>
      _SetExpectedPriceDialogWidgetState();
}

class _SetExpectedPriceDialogWidgetState
    extends State<SetExpectedPriceDialogWidget> {
  final TextEditingController _priceController = TextEditingController();

  final ScrollController _stepsController = ScrollController();

  final double _stepAmount = 1000;
  double _currentPrice = 0;

  double _basePrice = 0; // original initial value
  double _maxPrice = double.infinity;
  bool _isProgrammaticChange = false;

  @override
  void initState() {
    super.initState();

    _basePrice = (widget.initialValue ?? 0);

    if (widget.canIncreasePriceUpto150Percent) {
      // For PD: start at 80%, max is 150%
      final start = _roundToNearest1000(_basePrice * 0.8);
      _maxPrice = _basePrice * 1.5;
      _currentPrice = start;
    } else {
      // For non-PD: start at base price, can decrease but not increase
      _maxPrice = _basePrice; // Can't go above base price
      _currentPrice = _basePrice;
    }

    _priceController.text = _currentPrice.toStringAsFixed(0);

    _priceController.addListener(() {
      if (_isProgrammaticChange) return;

      final text = _priceController.text;
      if (text.isEmpty) return;

      final value = double.tryParse(text);
      if (value == null) return;

      _updatePrice(value);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_stepsController.hasClients) {
        _stepsController.jumpTo(_stepsController.position.maxScrollExtent / 2);
      }
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  void _updatePrice(double newPrice) {
    if (newPrice < 0) return;

    // Clamping logic
    double clamped;
    if (widget.canIncreasePriceUpto150Percent) {
      // For PD: can increase up to 150% of base
      clamped = newPrice > _maxPrice ? _maxPrice : newPrice;
    } else {
      // For non-PD: can decrease freely, but cannot increase above base
      clamped = newPrice > _maxPrice ? _maxPrice : newPrice;
      // No lower limit - can go down to 0
    }

    final rounded = _roundToNearest1000(clamped);
    final newText = rounded.toStringAsFixed(0);

    // ✅ avoid re-setting if already same
    if (_currentPrice == rounded && _priceController.text == newText) return;

    setState(() {
      _currentPrice = rounded;

      _isProgrammaticChange = true;
      _priceController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
      _isProgrammaticChange = false;
    });
  }

  double _roundToNearest1000(double v) => (v / 1000).round() * 1000.0;

  void _incrementPrice() {
    _updatePrice(_currentPrice + _stepAmount);
  }

  void _decrementPrice() {
    final newPrice = _currentPrice - _stepAmount;
    if (newPrice >= 0) {
      _updatePrice(newPrice);
    }
  }

  void _addAmount(double amount) {
    _updatePrice(_currentPrice + amount);
  }

  @override
  Widget build(BuildContext context) {
    final steps = <double>[
      -50000,
      -25000,
      -10000,
      -5000,
      5000,
      10000,
      25000,
      50000,
    ];
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.blue,
              ),
            ),
            const SizedBox(height: 15),

            // Step Price Information
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.blue),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppColors.blue),
                  const SizedBox(width: 6),
                  Text(
                    'Step amount: Rs. ${NumberFormat.decimalPattern('en_IN').format(_stepAmount)}/-',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Price Input with +/- Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Minus Button
                InkWell(
                  onTap: _decrementPrice,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.red),
                    ),
                    child: const Icon(Icons.remove, color: AppColors.red),
                  ),
                ),

                const SizedBox(width: 10),

                // Price TextField
                Container(
                  width: 120,
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.grey.withValues(alpha: 0.5),
                    ),
                  ),
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                      hintStyle: TextStyle(color: AppColors.grey),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Plus Button
                InkWell(
                  onTap: _incrementPrice,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.green),
                    ),
                    child: Icon(Icons.add, color: AppColors.green),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Quick Add Buttons (Horizontal Scroll)
            SizedBox(
              height: 40,
              child: ListView.separated(
                controller: _stepsController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                itemCount: steps.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final amount = steps[i];
                  return _QuickStepButton(
                    amount: amount,
                    onTap: () => _addAmount(amount), // negative will decrement
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // Cancel and Set Buttons
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    text: 'Cancel',
                    isLoading: false.obs,
                    width: 200,
                    backgroundColor: AppColors.grey,
                    elevation: 5,
                    fontSize: 12,
                    onTap: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ButtonWidget(
                    text: 'Set',
                    isLoading: widget.isSetPriceLoading,
                    width: 200,
                    backgroundColor: AppColors.green,
                    elevation: 5,
                    fontSize: 12,
                    onTap: () {
                      widget.onPriceSelected(_currentPrice);
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Example usage function
void showSetExpectedPriceDialog({
  required BuildContext context,
  required String title,
  required final RxBool isSetPriceLoading,
  double? initialValue,
  required bool canIncreasePriceUpto150Percent,
  required Function(double) onPriceSelected,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SetExpectedPriceDialogWidget(
        title: title,
        isSetPriceLoading: isSetPriceLoading,
        initialValue: initialValue,
        canIncreasePriceUpto150Percent: canIncreasePriceUpto150Percent,
        onPriceSelected: onPriceSelected,
      );
    },
  );
}

class _QuickStepButton extends StatelessWidget {
  final double amount;
  final VoidCallback onTap;

  const _QuickStepButton({required this.amount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDecrement = amount < 0;
    final color = isDecrement ? AppColors.red : AppColors.green;
    final icon = isDecrement ? Icons.remove : Icons.add;
    final label =
        'Rs. ${NumberFormat.decimalPattern('en_IN').format(amount.abs())}/-';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
