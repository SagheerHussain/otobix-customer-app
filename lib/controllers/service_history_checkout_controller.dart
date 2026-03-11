import 'package:get/get.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class ServiceHistoryCheckoutController extends GetxController {
  final Map<String, dynamic> carDetails = {
    'carName': 'Jeep Compass 4x4 Limited',
    'transmission': 'Manual',
    'year': '2019',
    'fuelType': 'Diesel',
    'ownership': '2nd',
  };

  final List<String> leftSummaryItems = [
    'Vehicle Service History',
    'Odometer Status',
    'Engine Status',
    'Gearbox Status',
    'Structural Status',
    'Flooded Status',
    'Blacklist Status',
  ];

  final List<String> rightSummaryItems = [
    'RC Status',
    'Hypothecation Details',
    'Insurance Details',
    'Challan Details',
    'PUC Details',
    'Registered RTO Details',
  ];

  final Map<String, String> billDetails = {
    'serviceHistory': '₹ 750',
    'gst': '₹ 135',
    'total': '₹ 885',
  };

  void onOffersAndCouponsTap() {
    ToastWidget.show(
      context: Get.context!,
      title: 'Offers & Coupons',
      subtitle: 'Offers and coupons list will open here.',
      type: ToastType.info,
    );
  }

  void onProceedToCheckout() {
    ToastWidget.show(
      context: Get.context!,
      title: 'Proceed to Checkout',
      subtitle: 'Payment flow will be added here.',
      type: ToastType.success,
    );
  }
}
