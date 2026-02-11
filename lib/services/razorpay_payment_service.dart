// services/razorpay_payment_service.dart
import 'dart:convert';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentSuccessData {
  final String orderId;
  final String paymentId;
  final String signature;

  PaymentSuccessData({
    required this.orderId,
    required this.paymentId,
    required this.signature,
  });

  Map<String, dynamic> toJson() => {
        "razorpay_order_id": orderId,
        "razorpay_payment_id": paymentId,
        "razorpay_signature": signature,
      };
}

class PaymentFailureData {
  final int code;
  final String message;

  PaymentFailureData({required this.code, required this.message});
}

class RazorpayPaymentService {
  Razorpay? _razorpay;

  void init({
    required void Function(PaymentSuccessData success) onSuccess,
    required void Function(PaymentFailureData failure) onFailure,
    required void Function(String walletName) onExternalWallet,
  }) {
    _razorpay = Razorpay();

    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse r) {
      onSuccess(
        PaymentSuccessData(
          orderId: r.orderId ?? "",
          paymentId: r.paymentId ?? "",
          signature: r.signature ?? "",
        ),
      );
    });

    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse r) {
      onFailure(
        PaymentFailureData(
          code: r.code ?? -1,
          message: r.message ?? "Payment failed",
        ),
      );
    });

    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse r) {
      onExternalWallet(r.walletName ?? "");
    });
  }

  void dispose() {
    _razorpay?.clear();
    _razorpay = null;
  }

  Future<void> openCheckout({
    required double amountRupees,
    required String name,
    required String description,
    required String customerEmail,
    required String customerPhone,
    Map<String, dynamic>? notes,
    String? receipt,
  }) async {
    if (_razorpay == null) {
      throw Exception("RazorpayPaymentService not initialized");
    }

    // ✅ 1) Create order on backend
    final resp = await ApiService.post(
      endpoint: AppUrls.createRazorpayOrder,
      body: {
        "amount": amountRupees,
        "currency": "INR",
        "receipt": receipt,
        "notes": notes ?? {},
      },
    );

    if (resp.statusCode != 200) {
      throw Exception("Create order failed: ${resp.body}");
    }

    final data = jsonDecode(resp.body);
    final String orderId = data["orderId"];
    final String keyId = data["keyId"];

    // ✅ 2) Open Razorpay checkout
    _razorpay!.open({
      "key": keyId,
      "amount": (amountRupees * 100).round(),
      "currency": "INR",
      "name": name,
      "description": description,
      "order_id": orderId,
      "prefill": {"email": customerEmail, "contact": customerPhone},
      "notes": notes ?? {},
    });
  }

  Future<bool> verifyOnBackend({
    required PaymentSuccessData success,
    String? userId,
    Map<String, dynamic>? meta,
  }) async {
    final resp = await ApiService.post(
      endpoint: AppUrls.verifyRazorpayPayment,
      body: {
        ...success.toJson(),
        "userId": userId,
        "meta": meta ?? {},
      },
    );

    if (resp.statusCode != 200) return false;
    final data = jsonDecode(resp.body);
    return data["verified"] == true;
  }
}
