import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownController<T> extends GetxController {
  final TextEditingController controller;
  final List<DropdownMenuItem<T>>? items;
  final ValueChanged<T?>? onChanged;

  final FocusNode focusNode = FocusNode();
  final LayerLink layerLink = LayerLink();

  var isDropdownOpen = false.obs;
  var filteredItems = <DropdownMenuItem<T>>[].obs;
  var _isDisposed = false;

  DropdownController({required this.controller, this.items, this.onChanged});

  void _afterBuild(VoidCallback fn) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) fn();
    });
  }

  @override
  void onInit() {
    super.onInit();
    filteredItems.value = items ?? [];
    focusNode.addListener(_onFocusChange);
    controller.addListener(_onTextChanged);
  }

  void _onFocusChange() {
    if (_isDisposed) return;

    if (focusNode.hasFocus) {
      showDropdown();
    } else {
      hideDropdown();
    }
  }

  void _onTextChanged() {
    if (_isDisposed) return;
    if (items == null) return;

    final searchText = controller.text.toLowerCase();

    final nextList = items!.where((item) {
      final value = item.value?.toString().toLowerCase() ?? '';
      final childText = item.child is Text
          ? (item.child as Text).data?.toLowerCase() ?? ''
          : '';
      return value.contains(searchText) || childText.contains(searchText);
    }).toList();

    // ✅ delay Rx update (fixes "during build")
    _afterBuild(() => filteredItems.value = nextList);
  }

  void showDropdown() {
    if (_isDisposed || isDropdownOpen.value) return;

    // ✅ delay Rx update (fixes "during build")
    _afterBuild(() => isDropdownOpen.value = true);
  }

  void hideDropdown() {
    if (_isDisposed || !isDropdownOpen.value) return;

    // ✅ delay Rx update (fixes "during build")
    _afterBuild(() => isDropdownOpen.value = false);
  }

  void selectItem(DropdownMenuItem<T> item) {
    if (_isDisposed) return;

    controller.text = _getItemDisplayText(item);
    if (item.value != null) onChanged?.call(item.value);

    hideDropdown();
    focusNode.unfocus();
  }

  String _getItemDisplayText(DropdownMenuItem<T> item) {
    if (item.child is Text) {
      return (item.child as Text).data ?? item.value?.toString() ?? '';
    }
    return item.value?.toString() ?? '';
  }

  void updateItems(List<DropdownMenuItem<T>> newItems) {
    if (_isDisposed) return;
    _afterBuild(() => filteredItems.value = newItems); // ✅ safe
  }

  @override
  void onClose() {
    _isDisposed = true;
    focusNode.removeListener(_onFocusChange);
    controller.removeListener(_onTextChanged);
    focusNode.dispose();
    super.onClose();
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class DropdownController<T> extends GetxController {
//   final TextEditingController controller;
//   final List<DropdownMenuItem<T>>? items;
//   final ValueChanged<T?>? onChanged;

//   final FocusNode focusNode = FocusNode();
//   final LayerLink layerLink = LayerLink();

//   var isDropdownOpen = false.obs;
//   var filteredItems = <DropdownMenuItem<T>>[].obs;
//   var _isDisposed = false;

//   DropdownController({required this.controller, this.items, this.onChanged});

//   @override
//   void onInit() {
//     super.onInit();
//     filteredItems.value = items ?? [];
//     focusNode.addListener(_onFocusChange);
//     controller.addListener(_onTextChanged);
//   }

//   void _onFocusChange() {
//     if (_isDisposed) return;

//     if (focusNode.hasFocus) {
//       showDropdown();
//     } else {
//       hideDropdown();
//     }
//   }

//   void _onTextChanged() {
//     if (_isDisposed) return;

//     if (items != null) {
//       final searchText = controller.text.toLowerCase();

//       filteredItems.value = items!.where((item) {
//         final value = item.value?.toString().toLowerCase() ?? '';
//         final childText = item.child is Text
//             ? (item.child as Text).data?.toLowerCase() ?? ''
//             : '';
//         return value.contains(searchText) || childText.contains(searchText);
//       }).toList();
//     }
//   }

//   void showDropdown() {
//     if (isDropdownOpen.value || _isDisposed) return;
//     isDropdownOpen.value = true;
//   }

//   void hideDropdown() {
//     if (!isDropdownOpen.value || _isDisposed) return;
//     isDropdownOpen.value = false;
//   }

//   void selectItem(DropdownMenuItem<T> item) {
//     if (_isDisposed) return;
//     controller.text = _getItemDisplayText(item);
//     if (item.value != null) {
//       onChanged?.call(item.value);
//     }
//     hideDropdown();
//     focusNode.unfocus();
//   }

//   String _getItemDisplayText(DropdownMenuItem<T> item) {
//     if (item.child is Text) {
//       return (item.child as Text).data ?? item.value?.toString() ?? '';
//     }
//     return item.value?.toString() ?? '';
//   }

//   void updateItems(List<DropdownMenuItem<T>> newItems) {
//     if (_isDisposed) return;
//     filteredItems.value = newItems;
//   }

//   @override
//   void onClose() {
//     _isDisposed = true;
//     focusNode.removeListener(_onFocusChange);
//     controller.removeListener(_onTextChanged);
//     focusNode.dispose();
//     super.onClose();
//   }
// }
