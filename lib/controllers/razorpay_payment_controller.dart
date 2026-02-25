import 'dart:async';

import 'package:get/get.dart';
import 'package:otobix_customer_app/services/razorpay_payment_service.dart';

class RazorpayPaymentController extends GetxController {
  final RazorpayPaymentService _service = RazorpayPaymentService();
  final isPaying = false.obs;

  String? _userId;
  Map<String, dynamic> _meta = {};

  Completer<PaymentSuccessData>? _completer;

  @override
  void onInit() {
    super.onInit();

    _service.init(
      // This will run when payment is successful
      onSuccess: (success) async {
        // verify
        final verified = await _service.verifyOnBackend(
          success: success,
          userId: _userId,
          meta: _meta,
        );

        isPaying.value = false;

        if (verified) {
          _completer?.complete(success);
        } else {
          _completer?.completeError(
            Exception("Payment received but verification failed."),
          );
        }

        _completer = null;
      },
      // This will run when payment is failed
      onFailure: (failure) {
        isPaying.value = false;
        _completer?.completeError(Exception(failure.message));
        _completer = null;
      },
      // This will run when user selects external wallet
      onExternalWallet: (_) {},
    );
  }

  Future<PaymentSuccessData> pay({
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
    if (isPaying.value) {
      throw Exception("Payment already in progress.");
    }

    _userId = userId;
    _meta = meta ?? {};

    isPaying.value = true;
    _completer = Completer<PaymentSuccessData>();

    try {
      await _service.openCheckout(
        amountRupees: amountRupees,
        name: name,
        description: description,
        customerEmail: email,
        customerPhone: phone,
        notes: notes,
        receipt: receipt,
      );
      // Razorpay UI opens; result will come via callbacks
      return _completer!.future;
    } catch (e) {
      isPaying.value = false;
      _completer = null;
      final msg = e.toString().replaceAll("Exception: ", "").trim();
      throw Exception(msg);
    }
  }

  @override
  void onClose() {
    _service.dispose();
    super.onClose();
  }
}



// import 'package:get/get.dart';
// import 'package:otobix_customer_app/services/razorpay_payment_service.dart';

// class RazorpayPaymentController extends GetxController {
//   final RazorpayPaymentService _service = RazorpayPaymentService();

//   final isPaying = false.obs;

//   // callback hooks (screen can set these)
//   Function(String message)? onResultMessage;

  
//   // Keep these so verify uses correct meta/userId
//   String? _userId;
//   Map<String, dynamic> _meta = {};

//   @override
//   void onInit() {
//     super.onInit();

//     _service.init(
//       onSuccess: (success) async {
//         isPaying.value = true;

//         final verified = await _service.verifyOnBackend(
//         success: success,
//           userId: _userId,
//           meta: _meta,
//         );

//         isPaying.value = false;

//         if (verified) {
//           onResultMessage?.call("✅ Payment successful!");
//         } else {
//             onResultMessage?.call(
//             "⚠️ Payment received, but verification failed.\nPlease contact support if money is deducted.",
//           );
//         }
//       },
//       onFailure: (failure) {
//         isPaying.value = false;
//         onResultMessage?.call(failure.message);
//       },
//       onExternalWallet: (walletName) {
//          onResultMessage?.call("ℹ️ Using wallet: $walletName");
//       },
//     );
//   }

//   Future<void> pay({
//     required double amountRupees,
//     required String name,
//     required String description,
//     required String email,
//     required String phone,
//     required Map<String, dynamic> notes,
//     String? receipt,
//     String? userId,
//     Map<String, dynamic>? meta,
//   }) async {
//     if (isPaying.value) return;

//      // store meta/userId so success callback can use them
//     _userId = userId;
//     _meta = meta ?? {};

//     isPaying.value = true;

//     try {
//       // store these to use in verify callback if needed
//       // (simple approach: pass meta/userId directly in verifyOnBackend inside success callback)
//       await _service.openCheckout(
//         amountRupees: amountRupees,
//         name: name,
//         description: description,
//         customerEmail: email,
//         customerPhone: phone,
//         notes: notes,
//         receipt: receipt,
//       );
//       // Don't set isPaying=false here because Razorpay UI will open now.
//       // It will be turned off in success/failure callbacks.
//     } catch (e) {
//       isPaying.value = false;

//       // show only friendly message
//       final msg = e.toString().replaceAll("Exception: ", "").trim();
//       onResultMessage?.call(msg);
//     }
//   }

//   @override
//   void onClose() {
//     _service.dispose();
//     super.onClose();
//   }
// }
