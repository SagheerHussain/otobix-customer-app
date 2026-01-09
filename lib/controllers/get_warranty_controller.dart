import 'package:get/get.dart';

class GetWarrantyController extends GetxController {
  RxBool isGetWarrantyLoading = false.obs;

  // Warranty selection
  RxInt selectedWarrantyIndex = (-1).obs;

  void selectWarranty(int index) {
    selectedWarrantyIndex.value = index;
  }
}
