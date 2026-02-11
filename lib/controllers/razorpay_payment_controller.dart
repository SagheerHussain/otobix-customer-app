// controllers/razorpay_payment_controller.dart
import 'package:get/get.dart';
import 'package:otobix_customer_app/services/razorpay_payment_service.dart';

class RazorpayPaymentController extends GetxController {
  final RazorpayPaymentService _service = RazorpayPaymentService();

  final isPaying = false.obs;

  // callback hooks (screen can set these)
  Function(String message)? onResultMessage;

  @override
  void onInit() {
    super.onInit();

    _service.init(
      onSuccess: (success) async {
        isPaying.value = true;

        final verified = await _service.verifyOnBackend(
          success: success,
          userId: null, // if you have auth userId, pass it from pay()
          meta: {},
        );

        isPaying.value = false;

        if (verified) {
          onResultMessage?.call(
            "✅ Payment Success\norderId: ${success.orderId}\npaymentId: ${success.paymentId}",
          );
        } else {
          onResultMessage?.call("❌ Payment failed verification");
        }
      },
      onFailure: (failure) {
        isPaying.value = false;
        onResultMessage?.call("❌ Payment Failed: ${failure.message}");
      },
      onExternalWallet: (walletName) {
        onResultMessage?.call("ℹ️ External Wallet: $walletName");
      },
    );
  }

  Future<void> pay({
    required double amountRupees,
    required String name,
    required String description,
    required String email,
    required String phone,
    required Map<String, dynamic> notes,
    String? receipt,
    String? userId,
    Map<String, dynamic>? meta,
  }) async {
    if (isPaying.value) return;

    isPaying.value = true;

    try {
      // store these to use in verify callback if needed
      // (simple approach: pass meta/userId directly in verifyOnBackend inside success callback)
      await _service.openCheckout(
        amountRupees: amountRupees,
        name: name,
        description: description,
        customerEmail: email,
        customerPhone: phone,
        notes: notes,
        receipt: receipt,
      );
    } catch (e) {
      isPaying.value = false;
      onResultMessage?.call("❌ Error: $e");
    }
  }

  @override
  void onClose() {
    _service.dispose();
    super.onClose();
  }
}
