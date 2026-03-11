import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/razorpay_payment_controller.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class NewCarPdiController extends GetxController {
  // ===== PageView =====
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  final int totalPages = 3;

  void onPageChanged(int index) {
    currentPage.value = index;

    // ✅ when entering Page 3
    // if (index == 2) {
    //   fetchPdiPrice(); // don't await
    // }
  }

  // ===== Loading flags =====
  final RxBool isMakeLoading = false.obs;
  final RxBool isModelLoading = false.obs;
  final RxBool isFetchPdiPriceLoading = false.obs;
  final RxBool isSubmitPdiLoading = false.obs;

  // ===== API Options =====
  final RxList<String> makeOptions = <String>[].obs;
  final RxList<String> modelOptions = <String>[].obs;

  // ===== Selected values =====
  final RxString selectedMake = ''.obs;
  final RxString selectedModel = ''.obs;

  final RxList<String> fuelTypes = <String>[
    'Petrol',
    'Diesel',
    'CNG',
    'Electric',
    'Hybrid',
  ].obs;

  final RxList<String> transmissions = <String>[
    'Manual',
    'Automatic',
    'AMT',
    'CVT',
    'DCT',
  ].obs;

  final RxString selectedFuel = ''.obs;
  final RxString selectedTransmission = ''.obs;

  // ===== Page 2 =====
  final RxList<Map<String, String>> dateOptions = <Map<String, String>>[].obs;
  final RxInt selectedDateIndex = 0.obs;

  final RxList<String> timeSlots = <String>[
    '10 AM - 11 AM',
    '11 AM - 12 PM',
    '12 PM - 01 PM',
    '01 PM - 02 PM',
    '02 PM - 03 PM',
    '03 PM - 04 PM',
    '04 PM - 05 PM',
    '05 PM - 06 PM',
  ].obs;

  final RxString selectedTimeSlot = ''.obs;
  final RxString selectedCustomerType = 'Consumer'.obs;

  final TextEditingController billingAddressController =
      TextEditingController();
  final TextEditingController visitAddressController = TextEditingController();
  final TextEditingController customerPhoneNumberController =
      TextEditingController();
  final TextEditingController pincodeController =
      TextEditingController(); // ✅ India PIN (6 digits)

  // ===== Page 3 =====
  final RxList<String> keyFeatures = <String>[
    'Body Structure/ Chassis',
    'Steering & Suspension',
    'Engine & Transmission',
    'Brakes & Clutch',
    'Mechanicals',
    'Wheels & Tyres',
    'Battery & Electricals',
    'Exterior Panels',
    'Electricals',
    'Vehicle Documentation',
  ].obs;

  final RxDouble vehicleInspectionRate = 0.0.obs;
  final RxDouble vehicleInspectionGst = 0.0.obs;
  final RxDouble vehicleInspectionTotal = 0.0.obs;
  final RxDouble vehicleInspectionRounding = 0.0.obs;

  final RxDouble serviceHistoryRate = 0.0.obs;
  final RxDouble serviceHistoryGst = 0.0.obs;
  final RxDouble serviceHistoryTotal = 0.0.obs;
  final RxDouble serviceHistoryRounding = 0.0.obs;

  RxDouble rate = 0.0.obs;
  RxDouble gst = 0.0.obs;
  RxDouble total = 0.0.obs;

  final RxList<String> offerCoupons = <String>[
    'Offers & Coupon',
    'NEW100 (₹100 Off)',
    'SAVE200 (₹200 Off)',
    'MEGA10 (10% Off)',
  ].obs;

  final RxString selectedOfferCoupon = 'Offers & Coupon'.obs;
  final RxInt discountAmount = 0.obs;

  String get pdiLineTitle => 'New Car PDI';

  String get primaryButtonText =>
      currentPage.value == totalPages - 1 ? 'Proceed to Checkout' : 'Next';

  // ===================================================================
  // ✅ Create ISO UTC DateTime using selected date + start time of slot
  // ===================================================================
  String get selectedStartDateTimeUtcIso {
    if (dateOptions.isEmpty) return '';
    if (selectedTimeSlot.value.isEmpty) return '';

    // selected date = today + index
    final DateTime baseDate = DateTime.now().add(
      Duration(days: selectedDateIndex.value),
    );
    final int startHour24 = _parseStartHour24(selectedTimeSlot.value);

    final local = DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      startHour24,
      0,
      0,
    );

    return local.toUtc().toIso8601String();
  }

  int _parseStartHour24(String slot) {
    // slot example: "10 AM - 11 AM"
    final match = RegExp(
      r'^\s*(\d{1,2})\s*(AM|PM)\b',
      caseSensitive: false,
    ).firstMatch(slot);

    if (match == null) return 10;

    int hour = int.tryParse(match.group(1) ?? '10') ?? 10;
    final ap = (match.group(2) ?? 'AM').toUpperCase();

    if (ap == 'PM' && hour != 12) hour += 12;
    if (ap == 'AM' && hour == 12) hour = 0;

    return hour;
  }

  double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  // ===================================================================
  // ✅ TOAST
  // ===================================================================
  void _showError(String msg) {
    if (Get.context == null) return;
    ToastWidget.show(
      context: Get.context!,
      title: 'Required',
      subtitle: msg,
      type: ToastType.error,
    );
  }

  // ===================================================================
  // ✅ SEARCH PICKER (BottomSheet with Search)
  // FIX: DO NOT dispose search controller manually (prevents crash)
  // ===================================================================
  void openSearchPicker({
    required String title,
    required RxList<String> options,
    required RxBool isLoading,
    required void Function(String query) onSearch,
    required void Function(String value) onSelect,
    String searchHint = 'Search...',
  }) {
    final TextEditingController searchCtrl = TextEditingController();
    Timer? debounce;

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0D2B55),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: searchCtrl,
                onChanged: (v) {
                  debounce?.cancel();
                  debounce = Timer(const Duration(milliseconds: 350), () {
                    onSearch(v.trim());
                  });
                },
                decoration: InputDecoration(
                  hintText: searchHint,
                  isDense: true,
                  filled: true,
                  fillColor: const Color(0xFFF3F6FB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),

              const SizedBox(height: 12),

              Obx(() {
                if (isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: CircularProgressIndicator(),
                  );
                }

                if (options.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Text(
                      'No results found',
                      style: TextStyle(
                        color: Color(0xFF6B7A94),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }

                return Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: Colors.black.withOpacity(0.06),
                    ),
                    itemBuilder: (_, i) {
                      final v = options[i];
                      return ListTile(
                        dense: true,
                        title: Text(
                          v,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF23324A),
                          ),
                        ),
                        onTap: () {
                          onSelect(v);
                          Get.back();
                        },
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    ).whenComplete(() {
      // only cancel debounce. no controller dispose to avoid "used after disposed" crash.
      debounce?.cancel();
    });
  }

  // ===================================================================
  // ✅ API Calls
  // ===================================================================

  Future<void> fetchMakeSuggestions(String query) async {
    isMakeLoading.value = true;
    try {
      final response = await ApiService.post(
        endpoint: AppUrls.searchMakeForPdi,
        body: {'q': query, 'limit': 30},
      );

      if (response.statusCode != 200) return;
      final body = jsonDecode(response.body);
      if (body['success'] != true) return;

      final List<String> makes = (body['data'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();

      makeOptions.assignAll(makes);
    } catch (e) {
      debugPrint('fetchMakeSuggestions error: $e');
    } finally {
      isMakeLoading.value = false;
    }
  }

  Future<void> fetchModelSuggestions({
    required String make,
    required String query,
  }) async {
    isModelLoading.value = true;
    try {
      final response = await ApiService.post(
        endpoint: AppUrls.searchModelByMakeForPdi,
        body: {'make': make, 'q': query, 'limit': 30},
      );

      if (response.statusCode != 200) return;
      final body = jsonDecode(response.body);
      if (body['success'] != true) return;

      final List<String> models = (body['data'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();

      modelOptions.assignAll(models);
    } catch (e) {
      debugPrint('fetchModelSuggestions error: $e');
    } finally {
      isModelLoading.value = false;
    }
  }

  // ===================================================================
  // ✅ Selection Logic (Reset rules)
  // ===================================================================

  void setMake(String v) {
    selectedMake.value = v;

    // reset dependent selections
    selectedModel.value = '';
    modelOptions.clear();

    fetchModelSuggestions(make: v, query: '');
  }

  void setModel(String v) {
    selectedModel.value = v;

    fetchPdiPrice(); // don't await
  }

  void setFuel(String v) => selectedFuel.value = v;
  void setTransmission(String v) => selectedTransmission.value = v;

  // ===================================================================
  // ✅ Tap handlers (with required checks)
  // ===================================================================

  void onTapMake() {
    openSearchPicker(
      title: 'Select Car Brand',
      options: makeOptions,
      isLoading: isMakeLoading,
      onSearch: fetchMakeSuggestions,
      onSelect: setMake,
      searchHint: 'Search make...',
    );
  }

  void onTapModel() {
    if (selectedMake.value.isEmpty) {
      _showError('Please select car brand first');
      return;
    }
    openSearchPicker(
      title: 'Select Car Model',
      options: modelOptions,
      isLoading: isModelLoading,
      onSearch: (q) =>
          fetchModelSuggestions(make: selectedMake.value, query: q),
      onSelect: setModel,
      searchHint: 'Search model...',
    );
  }

  void onTapFuel() {
    openSearchPicker(
      title: 'Select Fuel Type',
      options: fuelTypes,
      isLoading: false.obs,
      onSearch: (_) {},
      onSelect: setFuel,
      searchHint: 'Search fuel...',
    );
  }

  void onTapTransmission() {
    openSearchPicker(
      title: 'Select Transmission',
      options: transmissions,
      isLoading: false.obs,
      onSearch: (_) {},
      onSelect: setTransmission,
      searchHint: 'Search transmission...',
    );
  }

  // ===================================================================
  // ✅ Date / time helpers
  // ===================================================================

  void selectDate(int index) => selectedDateIndex.value = index;
  void selectTimeSlot(String slot) => selectedTimeSlot.value = slot;
  void setCustomerType(String type) => selectedCustomerType.value = type;

  void _buildNext5Dates() {
    dateOptions.clear();

    final now = DateTime.now();
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    String weekdayName(DateTime d) => dayNames[d.weekday - 1];

    for (int i = 0; i < 5; i++) {
      final d = now.add(Duration(days: i));
      final label = i == 0 ? 'Today' : (i == 1 ? 'Tomorrow' : weekdayName(d));

      dateOptions.add({
        'label': label,
        'day': weekdayName(d),
        'date': '${d.day}',
      });
    }

    selectedDateIndex.value = 0;
  }

  // ===================================================================
  // ✅ VALIDATION
  // ===================================================================

  bool _validatePage1() {
    if (selectedMake.value.isEmpty) {
      _showError('Please select car brand');
      return false;
    }
    if (selectedModel.value.isEmpty) {
      _showError('Please select car model');
      return false;
    }
    if (selectedFuel.value.isEmpty) {
      _showError('Please select fuel type');
      return false;
    }
    if (selectedTransmission.value.isEmpty) {
      _showError('Please select transmission');
      return false;
    }
    return true;
  }

  bool _validatePage2() {
    if (selectedTimeSlot.value.isEmpty) {
      _showError('Please select a time slot');
      return false;
    }

    // ✅ Create ISO UTC DateTime check
    if (selectedStartDateTimeUtcIso.isEmpty) {
      _showError('Please select date & time slot');
      return false;
    }
    // if (billingAddressController.text.trim().isEmpty) {
    //   _showError('Please enter billing address');
    //   return false;
    // }
    if (visitAddressController.text.trim().isEmpty) {
      _showError('Please enter visit address');
      return false;
    }
    final phone = customerPhoneNumberController.text.trim();

    // ✅ Indian phone: 10 digits, starts 6-9
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
      _showError('Enter a valid Indian mobile number (10 digits, starts 6-9)');
      return false;
    }

    final pin = pincodeController.text.trim();
    // ✅ India pincode: 6 digits
    if (!RegExp(r'^\d{6}$').hasMatch(pin)) {
      _showError('Enter a valid Pincode (6 digits)');
      return false;
    }

    return true;
  }

  // ===================================================================
  // ✅ NAVIGATION
  // ===================================================================

  void onPrimaryButtonTap() async {
    final page = currentPage.value;
    if (page == 0 && !_validatePage1()) return;
    if (page == 1 && !_validatePage2()) return;

    goNext();
  }

  void goNext() {
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    } else {
      submitPdi();
    }
  }

  void goBack() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  String formatRupee(double value) => '₹  ${value.toStringAsFixed(0)}';

  // Fetch pdi price
  Future<void> fetchPdiPrice() async {
    if (isFetchPdiPriceLoading.value) return;

    isFetchPdiPriceLoading.value = true;

    try {
      final response = await ApiService.get(
        endpoint: AppUrls.fetchPdiPrice(
          make: selectedMake.value.trim(),
          model: selectedModel.value.trim(),
        ),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final data = responseBody['data'] as Map<String, dynamic>?;

        final vehicle =
            (data?['vehicleInspection'] as Map<String, dynamic>?) ?? {};
        final history =
            (data?['serviceHistory'] as Map<String, dynamic>?) ?? {};

        // ✅ Vehicle Inspection
        vehicleInspectionRate.value = _toDouble(vehicle['rate']);
        vehicleInspectionGst.value = _toDouble(vehicle['gst']);
        vehicleInspectionTotal.value = _toDouble(vehicle['total']);
        vehicleInspectionRounding.value = _toDouble(vehicle['rounding']);

        // ✅ Service History
        serviceHistoryRate.value = _toDouble(history['rate']);
        serviceHistoryGst.value = _toDouble(history['gst']);
        serviceHistoryTotal.value = _toDouble(history['total']);
        serviceHistoryRounding.value = _toDouble(history['rounding']);

        rate.value = vehicleInspectionRate.value;
        gst.value = vehicleInspectionGst.value;
        total.value = vehicleInspectionTotal.value;
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed',
          subtitle: 'Failed to Fetch PDI Price',
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint('Error Fetching PDI Price: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error Fetching PDI Price',
        type: ToastType.error,
      );
    } finally {
      isFetchPdiPriceLoading.value = false;
    }
  }

  // Submit PDI
  Future<void> submitPdi() async {
    if (isSubmitPdiLoading.value) return;

    isSubmitPdiLoading.value = true;

    try {
      final userId =
          await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? "";
      final userEmail =
          await SharedPrefsHelper.getString(SharedPrefsHelper.userEmailKey) ??
          "";

      // ✅ Start payment and WAIT for success
      final RazorpayPaymentController paymentController =
          Get.isRegistered<RazorpayPaymentController>()
          ? Get.find<RazorpayPaymentController>()
          : Get.put(RazorpayPaymentController());

      final success = await paymentController
          .pay(
            amountRupees: total.value,
            name: "New Car PDI",
            description: "PDI Purchase",
            email: userEmail,
            phone: customerPhoneNumberController.text.trim(),
            notes: {
              "userId": userId,
              "basePrice": rate.value,
              "gstOnPdi": gst.value,
              "totalPdiPriceWithGst": total.value,
            },
            receipt: "pdi_${DateTime.now().millisecondsSinceEpoch}",
            userId: userId,
            meta: {},
          )
          .timeout(
            const Duration(minutes: 3),
            onTimeout: () {
              throw Exception("Payment timed out. Please try again.");
            },
          );

      if (billingAddressController.text.trim().isEmpty) {
        billingAddressController.text = visitAddressController.text.trim();
      }

      // ✅ 3) Payment success => now call Sale API with paymentId
      final requestBody = {
        "paymentId": success.paymentId, // ✅ IMPORTANT
        "pdiType": pdiLineTitle,
        "userId": userId,
        "userPhoneNumber": customerPhoneNumberController.text.trim(),
        "make": selectedMake.value,
        "model": selectedModel.value,
        "fuelType": selectedFuel.value,
        "transmissionType": selectedTransmission.value,
        "inspectionDate": selectedStartDateTimeUtcIso,
        "customerType": selectedCustomerType.value,
        "billingAddress": billingAddressController.text.trim(),
        "visitAddress": visitAddressController.text.trim(),
        "pinCode": pincodeController.text.trim(),
        "rate": rate.value,
        "gst": gst.value,
        "total": total.value,
        "isServiceHistoryProvided": false,
      };

      final response = await ApiService.post(
        endpoint: AppUrls.submitPdiRequest,
        body: requestBody,
      );

      final responseBody = jsonDecode(response.body);

      // debugPrint(responseBody.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        ToastWidget.show(
          context: Get.context!,
          title: 'PDI',
          subtitle: 'Successfully submitted PDI request',
          type: ToastType.success,
        );
      } else if (response.statusCode == 400) {
        final String errorMsg = responseBody['message'];
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed',
          subtitle: errorMsg,
          type: ToastType.error,
        );
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed',
          subtitle: 'Failed to submit PDI request',
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint('Error submitting pdi request: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error submitting PDI request',
        type: ToastType.error,
      );
    } finally {
      isSubmitPdiLoading.value = false;
    }
  }

  // ===================================================================
  // ✅ LIFECYCLE
  // ===================================================================

  @override
  void onInit() async {
    super.onInit();

    _buildNext5Dates();
    selectedTimeSlot.value = timeSlots.first;

    // optional defaults
    selectedFuel.value = fuelTypes.first;
    selectedTransmission.value = transmissions.first;

    final userPhone =
        await SharedPrefsHelper.getString(
          SharedPrefsHelper.userPhoneNumberKey,
        ) ??
        "";
    customerPhoneNumberController.text = userPhone;

    fetchMakeSuggestions('');
  }

  @override
  void onClose() {
    billingAddressController.dispose();
    visitAddressController.dispose();
    customerPhoneNumberController.dispose();
    pincodeController.dispose();
    pageController.dispose();
    super.onClose();
  }
}
