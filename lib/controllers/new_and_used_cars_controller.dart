import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/views/pdi_payment_page.dart';

class NewAndUsedCarsController extends GetxController {
  NewAndUsedCarsController(this.serviceCategory);

  final String serviceCategory;

  // ===== PageView =====
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  // you currently have 4 pages in UI
  final int totalPages = 3;

  void onPageChanged(int index) => currentPage.value = index;

  void goNext() {
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    } else {
      // last page action (dummy)
      Get.off(PdiPaymentPage());
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

  void onPrimaryButtonTap() {
    goNext();
  }

  // ===== Helpers =====
  bool get isNewCar => serviceCategory.toLowerCase().contains('new');
  bool get isUsedCar => serviceCategory.toLowerCase().contains('used');

  // Button text (NEXT until last page)
  String get primaryButtonText =>
      currentPage.value == totalPages - 1 ? 'Proceed to Checkout' : 'Next';

  // ===== Common BottomSheet Picker (no models) =====
  void openPicker({
    required String title,
    required List<String> items,
    required void Function(String) onSelect,
  }) {
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
              const SizedBox(height: 10),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.black.withOpacity(0.06)),
                  itemBuilder: (_, i) {
                    return ListTile(
                      dense: true,
                      title: Text(
                        items[i],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF23324A),
                        ),
                      ),
                      onTap: () {
                        onSelect(items[i]);
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ===================================================================
  // PAGE 1 (existing dummy data)
  // ===================================================================

  final RxList<String> registrationOptions = <String>[
    'WB 02AN XXXX',
    'WB 24CD XXXX',
    'DL 01AB XXXX',
  ].obs;

  final RxList<String> brands = <String>[
    'Maruti Suzuki',
    'Hyundai',
    'Tata',
    'Honda',
  ].obs;

  final Map<String, List<String>> modelsByBrand = {
    'Maruti Suzuki': ['Swift', 'Baleno', 'Brezza'],
    'Hyundai': ['i10', 'i20', 'Creta'],
    'Tata': ['Nexon', 'Punch', 'Harrier'],
    'Honda': ['City', 'Amaze', 'Elevate'],
  };

  final Map<String, List<String>> variantsByModel = {
    'Swift': ['VXi', 'ZXi', 'ZXi+'],
    'Baleno': ['Sigma', 'Delta', 'Zeta'],
    'Brezza': ['LXi', 'VXi', 'ZXi'],
    'i10': ['Era', 'Magna', 'Sportz'],
    'i20': ['Sportz', 'Asta', 'N Line'],
    'Creta': ['E', 'S', 'SX'],
    'Nexon': ['Smart', 'Pure', 'Fearless'],
    'Punch': ['Pure', 'Adventure', 'Creative'],
    'Harrier': ['Pure', 'Adventure', 'Fearless'],
    'City': ['V', 'VX', 'ZX'],
    'Amaze': ['E', 'S', 'VX'],
    'Elevate': ['SV', 'V', 'ZX'],
  };

  final RxList<String> fuelTypes = <String>[
    'Petrol',
    'Diesel',
    'CNG',
    'Electric',
  ].obs;

  final RxList<String> transmissions = <String>[
    'Manual',
    'Automatic (AT)',
    'AMT',
    'CVT',
  ].obs;

  final RxString selectedReg = ''.obs; // used car
  final RxString selectedBrand = ''.obs;
  final RxString selectedModel = ''.obs;
  final RxString selectedVariant = ''.obs;
  final RxString selectedFuel = ''.obs;
  final RxString selectedTransmission = ''.obs;

  // Used car: service history Yes/No
  final RxnBool serviceHistoryYes = RxnBool(true);

  void setReg(String v) => selectedReg.value = v;

  void setBrand(String v) {
    selectedBrand.value = v;
    selectedModel.value = '';
    selectedVariant.value = '';
  }

  void setModel(String v) {
    selectedModel.value = v;
    selectedVariant.value = '';
  }

  void setVariant(String v) => selectedVariant.value = v;
  void setFuel(String v) => selectedFuel.value = v;
  void setTransmission(String v) => selectedTransmission.value = v;
  void setServiceHistory(bool isYes) => serviceHistoryYes.value = isYes;

  void onTapRegistration() {
    openPicker(
      title: 'Enter Car Registration Number',
      items: registrationOptions,
      onSelect: setReg,
    );
  }

  void onTapBrand() {
    openPicker(title: 'Select Car Brand', items: brands, onSelect: setBrand);
  }

  void onTapModel() {
    final items = modelsByBrand[selectedBrand.value] ?? <String>[];
    openPicker(
      title: 'Select Car Model',
      items: items.isEmpty ? <String>['Select brand first'] : items,
      onSelect: (v) {
        if (v == 'Select brand first') return;
        setModel(v);
      },
    );
  }

  void onTapVariant() {
    final items = variantsByModel[selectedModel.value] ?? <String>[];
    openPicker(
      title: 'Select Car Variant',
      items: items.isEmpty ? <String>['Select model first'] : items,
      onSelect: (v) {
        if (v == 'Select model first') return;
        setVariant(v);
      },
    );
  }

  void onTapFuel() {
    openPicker(
      title: 'Select Car Fuel Type',
      items: fuelTypes,
      onSelect: setFuel,
    );
  }

  void onTapTransmission() {
    openPicker(
      title: 'Select Car Transmission',
      items: transmissions,
      onSelect: setTransmission,
    );
  }

  // ===================================================================
  // PAGE 2 (NEW): Date/Time + Address
  // ===================================================================

  /// each item: {label:'Today', day:'Mon', date:'1'}
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

  // Consumer/Business (single selection)
  final RxString selectedCustomerType = 'Consumer'.obs;

  // address text controllers (dummy)
  final TextEditingController billingAddressController =
      TextEditingController();
  final TextEditingController visitAddressController = TextEditingController();
  final TextEditingController repNumberController = TextEditingController();

  // pincode dropdown
  final RxList<String> pincodeOptions = <String>[
    '700001',
    '700002',
    '700003',
    '700004',
  ].obs;
  final RxString selectedPincode = ''.obs;

  void selectDate(int index) => selectedDateIndex.value = index;

  void rotateDatesForward() {
    if (dateOptions.isEmpty) return;
    final first = dateOptions.removeAt(0);
    dateOptions.add(first);
    if (selectedDateIndex.value > 0) {
      selectedDateIndex.value = selectedDateIndex.value - 1;
    }
  }

  void selectTimeSlot(String slot) => selectedTimeSlot.value = slot;

  void setCustomerType(String type) => selectedCustomerType.value = type;

  void onTapPincode() {
    openPicker(
      title: 'Select a Pincode',
      items: pincodeOptions,
      onSelect: (v) => selectedPincode.value = v,
    );
  }

  // ===================================================================
  // PAGE 3: Key Features + Price Summary + Offers & Coupon
  // (Keep this block together so you can move it later easily)
  // ===================================================================

  // Dummy key features (same list shown)
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

  // Pricing (dummy like screenshot)
  final RxInt basePdiPrice = 1399.obs;
  final RxInt visitCharge = 399.obs;

  // Offer/Coupon dropdown (dummy)
  final RxList<String> offerCoupons = <String>[
    'Offers & Coupon', // default label
    'NEW50 (₹50 Off)',
    'SAVE100 (₹100 Off)',
    'FESTIVE200 (₹200 Off)',
  ].obs;

  final RxString selectedOfferCoupon = 'Offers & Coupon'.obs;
  final RxInt discountAmount = 0.obs;

  // Derived
  int get totalPrice =>
      basePdiPrice.value + visitCharge.value - discountAmount.value;

  // Title changes based on new/used
  String get pdiLineTitle => isUsedCar ? 'Used Car PDI' : 'New Car PDI';

  // ===== Functions =====
  void onOfferCouponTap() {
    openPicker(
      title: 'Select Offer / Coupon',
      items: offerCoupons,
      onSelect: setOfferCoupon,
    );
  }

  void setOfferCoupon(String value) {
    selectedOfferCoupon.value = value;

    if (value.contains('NEW50')) {
      discountAmount.value = 50;
    } else if (value.contains('SAVE100')) {
      discountAmount.value = 100;
    } else if (value.contains('FESTIVE200')) {
      discountAmount.value = 200;
    } else {
      discountAmount.value = 0;
    }
  }

  String formatRupee(int value) => '₹  $value';

  @override
  void onInit() {
    super.onInit();
    _buildNext5Dates();
    selectedTimeSlot.value = timeSlots.first; // default like screenshot feel
  }

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

  @override
  void onClose() {
    billingAddressController.dispose();
    visitAddressController.dispose();
    repNumberController.dispose();
    pageController.dispose();
    super.onClose();
  }
}
