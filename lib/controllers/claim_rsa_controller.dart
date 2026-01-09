import 'package:get/get.dart';

class ClaimRsaController extends GetxController {
  RxBool isClaimRsaLoading = false.obs;

  /// "consumer" or "business" (empty means none selected)
  RxString selectedType = "".obs;
}
