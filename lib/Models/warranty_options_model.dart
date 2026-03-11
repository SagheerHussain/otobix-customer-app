class WarrantyOptionsModel {
  final String warrantyCover;
  final String warrantyPeriod;
  final double
  warrantyPrice; // ✅ base price from API (keep same key name to avoid confusion)

  // constants
  static const double markupRate = 0.20; // 20%
  static const double gstRate = 0.18; // 18%

  WarrantyOptionsModel({
    required this.warrantyCover,
    required this.warrantyPeriod,
    required this.warrantyPrice,
  });

  factory WarrantyOptionsModel.fromJson(Map<String, dynamic> json) {
    final raw = json['warrantyPrice'];
    final base = (raw is num) ? raw.toDouble() : double.tryParse('$raw') ?? 0.0;

    return WarrantyOptionsModel(
      warrantyCover: (json['warrantyCover'] ?? '').toString(),
      warrantyPeriod: (json['warrantyPeriod'] ?? '').toString(),
      warrantyPrice: base,
    );
  }

  /// ✅ extra computed fields (not coming from API)
  double get warrantyPriceAfterMarkup => warrantyPrice * (1 + markupRate);

  double get warrantyPriceAfterGst => warrantyPriceAfterMarkup * (1 + gstRate);

  String get title => "$warrantyPeriod $warrantyCover";

  /// show final price in UI
  String get priceText => "₹${warrantyPriceAfterGst.toStringAsFixed(0)}";
}


// class WarrantyOptionsModel {
//   final String warrantyCover;
//   final String warrantyPeriod;
//   final double warrantyPrice;


//   WarrantyOptionsModel({
//     required this.warrantyCover,
//     required this.warrantyPeriod,
//     required this.warrantyPrice,
//   });

//   factory WarrantyOptionsModel.fromJson(Map<String, dynamic> json) {
//     return WarrantyOptionsModel(
//       warrantyCover: (json['warrantyCover'] ?? '').toString(),
//       warrantyPeriod: (json['warrantyPeriod'] ?? '').toString(),
//       warrantyPrice: (json['warrantyPrice'] is num)
//           ? (json['warrantyPrice'] as num).toDouble()
//           : double.tryParse((json['warrantyPrice'] ?? '0').toString()) ?? 0.0,
//     );
//   }

//   /// For showing in UI
//   String get title => "$warrantyPeriod $warrantyCover";

//   /// optional: show price nicely
//   String get priceText => "₹${warrantyPrice.toStringAsFixed(0)}";
// }
