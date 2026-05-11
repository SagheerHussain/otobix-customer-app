import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InsuranceDropdownWidgetController extends GetxController {
  final ValueChanged<String?>? onChanged;

  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final LayerLink layerLink = LayerLink();

  final RxBool isDropdownOpen = false.obs;
  final RxList<String> filteredItems = <String>[].obs;
  final RxnString selectedValue = RxnString();

  List<String> _items;
  bool _allowCustomEntries;
  bool _isDisposed = false;
  String? _lastNotifiedValue;

  InsuranceDropdownWidgetController({
    required List<String> items,
    required bool allowCustomEntries,
    this.onChanged,
    String? initialValue,
  }) : _items = List<String>.from(items),
       _allowCustomEntries = allowCustomEntries {
    if (initialValue != null && initialValue.trim().isNotEmpty) {
      textController.text = initialValue;
      selectedValue.value = initialValue;
      _lastNotifiedValue = initialValue;
    }
  }

  void _afterBuild(VoidCallback fn) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) fn();
    });
  }

  @override
  void onInit() {
    super.onInit();

    filteredItems.assignAll(_items);

    focusNode.addListener(_onFocusChange);
    textController.addListener(_onTextChanged);
  }

  void _onFocusChange() {
    if (_isDisposed) return;

    if (focusNode.hasFocus) {
      _filterItems();
      showDropdown();
    } else {
      _syncTypedValueWithSelection();
      hideDropdown();
    }
  }

  void _onTextChanged() {
    if (_isDisposed) return;

    _filterItems();

    if (focusNode.hasFocus && !isDropdownOpen.value) {
      showDropdown();
    }
  }

  void _filterItems() {
    final searchText = textController.text.trim().toLowerCase();

    final List<String> nextList;
    if (searchText.isEmpty) {
      nextList = List<String>.from(_items);
    } else {
      nextList = _items
          .where((item) => item.toLowerCase().contains(searchText))
          .toList();
    }

    _afterBuild(() {
      filteredItems.assignAll(nextList);
    });
  }

  void showDropdown() {
    if (_isDisposed || isDropdownOpen.value) return;

    _afterBuild(() {
      isDropdownOpen.value = true;
    });
  }

  void hideDropdown() {
    if (_isDisposed || !isDropdownOpen.value) return;

    _afterBuild(() {
      isDropdownOpen.value = false;
    });
  }

  void selectItem(String item) {
    if (_isDisposed) return;

    textController.value = TextEditingValue(
      text: item,
      selection: TextSelection.collapsed(offset: item.length),
    );

    selectedValue.value = item;
    _notifyChange(item);

    hideDropdown();
    focusNode.unfocus();
  }

  void updateItems(List<String> newItems) {
    if (_isDisposed) return;

    _items = List<String>.from(newItems);
    _filterItems();
  }

  void updateAllowCustomEntries(bool value) {
    _allowCustomEntries = value;
  }

  void setInitialValue(String? value, {bool notify = false}) {
    if (_isDisposed) return;

    final newValue = value?.trim() ?? '';

    textController.value = TextEditingValue(
      text: newValue,
      selection: TextSelection.collapsed(offset: newValue.length),
    );

    selectedValue.value = newValue.isEmpty ? null : newValue;
    _filterItems();

    if (notify) {
      _notifyChange(selectedValue.value);
    }
  }

  void _syncTypedValueWithSelection() {
    final rawText = textController.text.trim();

    if (rawText.isEmpty) {
      selectedValue.value = null;
      _notifyChange(null);
      return;
    }

    final matchedItem = _findExactMatch(rawText);

    if (matchedItem != null) {
      if (textController.text != matchedItem) {
        textController.value = TextEditingValue(
          text: matchedItem,
          selection: TextSelection.collapsed(offset: matchedItem.length),
        );
      }

      selectedValue.value = matchedItem;
      _notifyChange(matchedItem);
      return;
    }

    if (_allowCustomEntries) {
      selectedValue.value = rawText;
      _notifyChange(rawText);
    }
  }

  String? _findExactMatch(String value) {
    for (final item in _items) {
      if (item.toLowerCase() == value.toLowerCase()) {
        return item;
      }
    }
    return null;
  }

  void _notifyChange(String? value) {
    if (_lastNotifiedValue == value) return;
    _lastNotifiedValue = value;
    onChanged?.call(value);
  }

  @override
  void onClose() {
    _isDisposed = true;
    focusNode.removeListener(_onFocusChange);
    textController.removeListener(_onTextChanged);
    textController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
