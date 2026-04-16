import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/insurance_dropdown_widget_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';

class InsuranceDropdownWidget extends StatefulWidget {
  final String label;
  final List<String> items;
  final String hintText;
  final IconData icon;
  final bool isRequired;
  final bool allowCustomEntries;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool isEnabled;
  final InputDecoration? decoration;
  final TextStyle? style;
  final String? customEntryValidationMessage;
  final String? controllerTag;

  const InsuranceDropdownWidget({
    Key? key,
    required this.label,
    required this.items,
    required this.hintText,
    required this.icon,
    this.isRequired = false,
    this.allowCustomEntries = false,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.isEnabled = true,
    this.decoration,
    this.style,
    this.customEntryValidationMessage = 'Custom entries are not allowed',
    this.controllerTag,
  }) : super(key: key);

  @override
  State<InsuranceDropdownWidget> createState() =>
      _InsuranceDropdownWidgetState();
}

class _InsuranceDropdownWidgetState extends State<InsuranceDropdownWidget> {
  late final InsuranceDropdownWidgetController _controller;
  late final String _resolvedTag;

  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  Worker? _dropdownWorker;

  @override
  void initState() {
    super.initState();

    _resolvedTag = widget.controllerTag ?? UniqueKey().toString();

    _controller = Get.put(
      InsuranceDropdownWidgetController(
        items: widget.items,
        initialValue: widget.initialValue,
        onChanged: widget.onChanged,
        allowCustomEntries: widget.allowCustomEntries,
      ),
      tag: _resolvedTag,
    );

    _setupOverlayListener();
  }

  void _setupOverlayListener() {
    _dropdownWorker = ever<bool>(_controller.isDropdownOpen, (isOpen) {
      if (isOpen) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    });
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final overlayState = Overlay.of(context);
    if (overlayState == null) return;

    final renderBox =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final fieldSize = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => CompositedTransformFollower(
        link: _controller.layerLink,
        showWhenUnlinked: false,
        offset: Offset(0, fieldSize.height + 4),
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: fieldSize.width,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.grey.withValues(alpha: 0.3),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              child: Obx(
                () => _controller.filteredItems.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'No options available',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: _controller.filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _controller.filteredItems[index];
                          return ListTile(
                            title: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            onTap: () => _controller.selectItem(item),
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  String? _validateField(String? value) {
    final trimmedValue = value?.trim();

    if (widget.isRequired && (trimmedValue == null || trimmedValue.isEmpty)) {
      return 'This field is required';
    }

    if (!widget.allowCustomEntries &&
        trimmedValue != null &&
        trimmedValue.isNotEmpty) {
      final isValidItem = widget.items.any(
        (item) => item.toLowerCase() == trimmedValue.toLowerCase(),
      );

      if (!isValidItem) {
        return widget.customEntryValidationMessage;
      }
    }

    if (widget.validator != null) {
      final error = widget.validator!(value);
      if (error != null) return error;
    }

    return null;
  }

  @override
  void didUpdateWidget(covariant InsuranceDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!listEquals(oldWidget.items, widget.items)) {
      _controller.updateItems(widget.items);
    }

    if (oldWidget.initialValue != widget.initialValue) {
      _controller.setInitialValue(widget.initialValue, notify: false);
    }

    if (oldWidget.allowCustomEntries != widget.allowCustomEntries) {
      _controller.updateAllowCustomEntries(widget.allowCustomEntries);
    }
  }

  @override
  void dispose() {
    _dropdownWorker?.dispose();
    _hideOverlay();

    if (Get.isRegistered<InsuranceDropdownWidgetController>(
      tag: _resolvedTag,
    )) {
      Get.delete<InsuranceDropdownWidgetController>(tag: _resolvedTag);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _controller.layerLink,
          child: TextFormField(
            key: _fieldKey,
            controller: _controller.textController,
            focusNode: _controller.focusNode,
            enabled: widget.isEnabled,
            style:
                widget.style ??
                const TextStyle(fontSize: 14, color: Colors.black87),
            decoration: _buildInputDecoration(),
            validator: _validateField,
          ),
        ),
        // const SizedBox(height: 15),
      ],
    );
  }

  InputDecoration _buildInputDecoration() {
    final baseDecoration = InputDecoration(
      label: _buildFloatingLabel(),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      prefixIcon: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        child: Icon(widget.icon, color: AppColors.green, size: 20),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      hintText: widget.hintText,
      hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
      floatingLabelStyle: TextStyle(
        color: AppColors.green,
        fontSize: 14,
        fontWeight: FontWeight.w600,
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
        borderSide: BorderSide(color: AppColors.green, width: 1.4),
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
      suffixIcon: _buildSuffixIcon(),
    );

    final customDecoration = widget.decoration;

    if (customDecoration == null) return baseDecoration;

    return baseDecoration.copyWith(
      prefixIcon: customDecoration.prefixIcon ?? baseDecoration.prefixIcon,
      suffixIcon: customDecoration.suffixIcon ?? baseDecoration.suffixIcon,
      hintText: customDecoration.hintText ?? baseDecoration.hintText,
      hintStyle: customDecoration.hintStyle ?? baseDecoration.hintStyle,
      contentPadding:
          customDecoration.contentPadding ?? baseDecoration.contentPadding,
      filled: customDecoration.filled,
      fillColor: customDecoration.fillColor,
      border: customDecoration.border ?? baseDecoration.border,
      enabledBorder:
          customDecoration.enabledBorder ?? baseDecoration.enabledBorder,
      focusedBorder:
          customDecoration.focusedBorder ?? baseDecoration.focusedBorder,
      errorBorder: customDecoration.errorBorder ?? baseDecoration.errorBorder,
      focusedErrorBorder:
          customDecoration.focusedErrorBorder ??
          baseDecoration.focusedErrorBorder,
      disabledBorder:
          customDecoration.disabledBorder ?? baseDecoration.disabledBorder,
      floatingLabelBehavior:
          customDecoration.floatingLabelBehavior ??
          baseDecoration.floatingLabelBehavior,
      floatingLabelStyle:
          customDecoration.floatingLabelStyle ??
          baseDecoration.floatingLabelStyle,
    );
  }

  Widget _buildFloatingLabel() {
    return RichText(
      text: TextSpan(
        text: widget.label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.black87,
        ),
        children: widget.isRequired
            ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ]
            : [],
      ),
    );
  }

  Widget _buildSuffixIcon() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Icon(
          _controller.isDropdownOpen.value
              ? CupertinoIcons.chevron_up
              : CupertinoIcons.chevron_down,
          color: AppColors.green,
          size: 15,
        ),
      ),
    );
  }
}
