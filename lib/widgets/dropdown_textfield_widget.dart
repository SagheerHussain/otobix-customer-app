import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/dropdown_textfield_widget_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';

class DropdownTextfieldWidget<T> extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isRequired;
  final bool allowCustomEntries;
  final List<DropdownMenuItem<T>>? items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final bool isEnabled;
  final InputDecoration? decoration;
  final TextStyle? style;
  final String? customEntryValidationMessage;
  final String? controllerTag;

  const DropdownTextfieldWidget({
    Key? key,
    required this.label,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isRequired = false,
    this.allowCustomEntries = false,
    this.items,
    this.onChanged,
    this.validator,
    this.isEnabled = true,
    this.decoration,
    this.style,
    this.customEntryValidationMessage = 'Custom entries are not allowed',
    this.controllerTag,
  }) : super(key: key);

  @override
  State<DropdownTextfieldWidget<T>> createState() =>
      _DropdownTextfieldWidgetState<T>();
}

class _DropdownTextfieldWidgetState<T>
    extends State<DropdownTextfieldWidget<T>> {
  late final DropdownController<T> _controller;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      DropdownController<T>(
        controller: widget.controller,
        items: widget.items,
        onChanged: widget.onChanged,
      ),
      tag: widget.controllerTag,
    );
    _setupOverlayListener();
  }

  void _setupOverlayListener() {
    ever(_controller.isDropdownOpen, (isOpen) {
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

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 32,
        child: CompositedTransformFollower(
          link: _controller.layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.grey.withValues(alpha: 0.3),
                ),
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
                            title: item.child,
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
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  String? _validateField(String? value) {
    if (widget.isRequired && (value == null || value.trim().isEmpty)) {
      return 'This field is required';
    }

    if (!widget.allowCustomEntries &&
        value != null &&
        value.trim().isNotEmpty) {
      final isValidItem =
          widget.items?.any((item) {
            final itemText = _getItemDisplayText(item).toLowerCase();
            return itemText == value.toLowerCase();
          }) ??
          false;

      if (!isValidItem) {
        return widget.customEntryValidationMessage;
      }
    }

    if (widget.validator != null) {
      final error = widget.validator!(value as T?);
      if (error != null) return error;
    }

    return null;
  }

  String _getItemDisplayText(DropdownMenuItem<T> item) {
    if (item.child is Text) {
      return (item.child as Text).data ?? item.value?.toString() ?? '';
    }
    return item.value?.toString() ?? '';
  }

  @override
  void didUpdateWidget(covariant DropdownTextfieldWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _controller.updateItems(widget.items ?? []);
    }
  }

  @override
  void dispose() {
    _hideOverlay();
    // Only delete the controller if it doesn't have a tag (unique instance)
    if (widget.controllerTag == null) {
      Get.delete<DropdownController<T>>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with optional required asterisk
        RichText(
          text: TextSpan(
            text: widget.label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
            children: widget.isRequired
                ? [
                    const TextSpan(
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
        ),
        const SizedBox(height: 6),

        // Text field with dropdown
        CompositedTransformTarget(
          link: _controller.layerLink,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
            ),
            child: TextFormField(
              controller: widget.controller,
              focusNode: _controller.focusNode,
              enabled: widget.isEnabled,
              style:
                  widget.style ??
                  const TextStyle(fontSize: 14, color: Colors.black87),
              decoration: _buildInputDecoration(),
              validator: (value) => _validateField(value),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  InputDecoration _buildInputDecoration() {
    final baseDecoration = InputDecoration(
      prefixIcon: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        child: Icon(widget.icon, color: Colors.green, size: 20),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
      hintText: widget.hintText,
      border: InputBorder.none,
      errorBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      suffixIcon: _buildSuffixIcon(),
    );

    return widget.decoration != null
        ? baseDecoration.copyWith(
            prefixIcon:
                widget.decoration?.prefixIcon ?? baseDecoration.prefixIcon,
            suffixIcon: widget.decoration?.suffixIcon ?? _buildSuffixIcon(),
            hintText: widget.decoration?.hintText ?? widget.hintText,
            hintStyle: widget.decoration?.hintStyle ?? baseDecoration.hintStyle,
            contentPadding:
                widget.decoration?.contentPadding ??
                baseDecoration.contentPadding,
          )
        : baseDecoration;
  }

  Widget? _buildSuffixIcon() {
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

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:otobix_customer_app/utils/app_colors.dart';

// class DropdownTextfieldWidget<T> extends StatefulWidget {
//   final String label;
//   final TextEditingController controller;
//   final String hintText;
//   final IconData icon;
//   final bool isRequired;
//   final bool allowCustomEntries;
//   final List<DropdownMenuItem<T>>? items;
//   final ValueChanged<T?>? onChanged;
//   final FormFieldValidator<T>? validator;
//   final bool isEnabled;
//   final InputDecoration? decoration;
//   final TextStyle? style;
//   final String? customEntryValidationMessage;

//   const DropdownTextfieldWidget({
//     Key? key,
//     required this.label,
//     required this.controller,
//     required this.hintText,
//     required this.icon,
//     this.isRequired = false,
//     this.allowCustomEntries = false,
//     this.items,
//     this.onChanged,
//     this.validator,
//     this.isEnabled = true,
//     this.decoration,
//     this.style,
//     this.customEntryValidationMessage = 'Custom entries are not allowed',
//   }) : super(key: key);

//   @override
//   State<DropdownTextfieldWidget<T>> createState() =>
//       _DropdownTextfieldWidgetState<T>();
// }

// class _DropdownTextfieldWidgetState<T>
//     extends State<DropdownTextfieldWidget<T>> {
//   final FocusNode _focusNode = FocusNode();
//   OverlayEntry? _overlayEntry;
//   final LayerLink _layerLink = LayerLink();
//   bool _isDropdownOpen = false;
//   List<DropdownMenuItem<T>> _filteredItems = [];

//   @override
//   void initState() {
//     super.initState();
//     _filteredItems = widget.items ?? [];
//     _focusNode.addListener(_onFocusChange);
//     widget.controller.addListener(_onTextChanged);
//   }

//   @override
//   void didUpdateWidget(covariant DropdownTextfieldWidget<T> oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.items != widget.items) {
//       _filteredItems = widget.items ?? [];
//     }
//   }

//   void _onFocusChange() {
//     if (_focusNode.hasFocus) {
//       _showDropdown();
//     } else {
//       _hideDropdown();
//     }
//   }

//   void _onTextChanged() {
//     if (widget.items != null) {
//       final searchText = widget.controller.text.toLowerCase();

//       _filteredItems = widget.items!.where((item) {
//         final value = item.value?.toString().toLowerCase() ?? '';
//         final childText = item.child is Text
//             ? (item.child as Text).data?.toLowerCase() ?? ''
//             : '';
//         return value.contains(searchText) || childText.contains(searchText);
//       }).toList();

//       // 🔑 Force the overlay to rebuild with new _filteredItems
//       _overlayEntry?.markNeedsBuild();

//       // setState is not really needed for overlay, but you can keep it if you want
//       setState(() {});
//     }
//   }

//   void _showDropdown() {
//     if (_overlayEntry != null) return;

//     _overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         width: MediaQuery.of(context).size.width - 32,
//         child: CompositedTransformFollower(
//           link: _layerLink,
//           showWhenUnlinked: false,
//           offset: const Offset(0, 60),
//           child: Material(
//             elevation: 4,
//             borderRadius: BorderRadius.circular(12),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: AppColors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: AppColors.grey.withValues(alpha: 0.3),
//                 ),
//               ),
//               constraints: BoxConstraints(
//                 maxHeight: MediaQuery.of(context).size.height * 0.3,
//               ),
//               child: _filteredItems.isEmpty
//                   ? Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Text(
//                         'No options available',
//                         style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                       ),
//                     )
//                   : ListView.builder(
//                       padding: EdgeInsets.zero,
//                       shrinkWrap: true,
//                       itemCount: _filteredItems.length,
//                       itemBuilder: (context, index) {
//                         final item = _filteredItems[index];
//                         return ListTile(
//                           title: item.child,
//                           onTap: () {
//                             widget.controller.text = _getItemDisplayText(item);
//                             if (item.value != null) {
//                               widget.onChanged?.call(item.value);
//                             }
//                             _hideDropdown();
//                             _focusNode.unfocus();
//                           },
//                         );
//                       },
//                     ),
//             ),
//           ),
//         ),
//       ),
//     );

//     Overlay.of(context).insert(_overlayEntry!);
//     setState(() {
//       _isDropdownOpen = true;
//     });
//   }

//   void _hideDropdown() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//     setState(() {
//       _isDropdownOpen = false;
//     });
//   }

//   String _getItemDisplayText(DropdownMenuItem<T> item) {
//     if (item.child is Text) {
//       return (item.child as Text).data ?? item.value?.toString() ?? '';
//     }
//     return item.value?.toString() ?? '';
//   }

//   String? _validateField(String? value) {
//     if (widget.isRequired && (value == null || value.trim().isEmpty)) {
//       return 'This field is required';
//     }

//     if (!widget.allowCustomEntries &&
//         value != null &&
//         value.trim().isNotEmpty) {
//       final isValidItem =
//           widget.items?.any((item) {
//             return _getItemDisplayText(item).toLowerCase() ==
//                 value.toLowerCase();
//           }) ??
//           false;

//       if (!isValidItem) {
//         return widget.customEntryValidationMessage;
//       }
//     }

//     if (widget.validator != null) {
//       final error = widget.validator!(value as T?);
//       if (error != null) return error;
//     }

//     return null;
//   }

//   @override
//   void dispose() {
//     _focusNode.removeListener(_onFocusChange);
//     widget.controller.removeListener(_onTextChanged);
//     _focusNode.dispose();
//     _hideDropdown();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Label with optional required asterisk
//         RichText(
//           text: TextSpan(
//             text: widget.label,
//             style: const TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 14,
//               color: Colors.black87,
//             ),
//             children: widget.isRequired
//                 ? [
//                     const TextSpan(
//                       text: ' *',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ]
//                 : [],
//           ),
//         ),
//         const SizedBox(height: 6),

//         // Text field with dropdown
//         CompositedTransformTarget(
//           link: _layerLink,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
//             ),
//             child: TextFormField(
//               controller: widget.controller,
//               focusNode: _focusNode,
//               enabled: widget.isEnabled,
//               style:
//                   widget.style ??
//                   const TextStyle(fontSize: 14, color: Colors.black87),
//               decoration: _buildInputDecoration(),
//               validator: (value) => _validateField(value),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//       ],
//     );
//   }

//   InputDecoration _buildInputDecoration() {
//     final baseDecoration = InputDecoration(
//       prefixIcon: Container(
//         width: 40,
//         height: 40,
//         padding: const EdgeInsets.all(8),
//         child: Icon(widget.icon, color: Colors.green, size: 20),
//       ),
//       contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
//       hintText: widget.hintText,
//       border: InputBorder.none,
//       errorBorder: InputBorder.none,
//       enabledBorder: InputBorder.none,
//       focusedBorder: InputBorder.none,
//       disabledBorder: InputBorder.none,
//       focusedErrorBorder: InputBorder.none,
//       suffixIcon: _buildSuffixIcon(),
//     );

//     return widget.decoration != null
//         ? baseDecoration.copyWith(
//             prefixIcon:
//                 widget.decoration?.prefixIcon ?? baseDecoration.prefixIcon,
//             suffixIcon: widget.decoration?.suffixIcon ?? _buildSuffixIcon(),
//             hintText: widget.decoration?.hintText ?? widget.hintText,
//             hintStyle: widget.decoration?.hintStyle ?? baseDecoration.hintStyle,
//             contentPadding:
//                 widget.decoration?.contentPadding ??
//                 baseDecoration.contentPadding,
//           )
//         : baseDecoration;
//   }

//   Widget? _buildSuffixIcon() {
//     return Padding(
//       padding: const EdgeInsets.only(right: 8),
//       child: Icon(
//         _isDropdownOpen
//             ? CupertinoIcons.chevron_up
//             : CupertinoIcons.chevron_down,
//         color: AppColors.green,
//         size: 15,
//       ),
//     );
//   }
// }
