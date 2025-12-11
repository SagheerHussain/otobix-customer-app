class AuctionDetailsModel {
  final String carId;
  final String auctionStatus;
  final String frontMainImage;
  final String registrationNumber;
  final String make;
  final String model;
  final String variant;
  final DateTime registrationDate;
  final DateTime yearOfManufacture;
  final DateTime upcomingUntil;
  final DateTime auctionEndTime;
  final List<AuctionDetailsBidModel> liveBids;
  final List<AuctionDetailsOtobuyOfferModel> otobuyOffers;
  final double oneClickPrice;
  final double customerExpectedPrice;

  AuctionDetailsModel({
    required this.carId,
    required this.auctionStatus,
    required this.frontMainImage,
    required this.registrationNumber,
    required this.make,
    required this.model,
    required this.variant,
    required this.registrationDate,
    required this.yearOfManufacture,
    required this.upcomingUntil,
    required this.auctionEndTime,
    required this.liveBids,
    required this.otobuyOffers,
    required this.oneClickPrice,
    required this.customerExpectedPrice,
  });

  // Factory method to create AuctionDetails from JSON
  factory AuctionDetailsModel.fromJson(Map<String, dynamic> json) {
    return AuctionDetailsModel(
      carId: json['carId'] ?? '',
      auctionStatus: json['auctionStatus'] ?? '',
      frontMainImage: json['frontMainImage'] ?? '',
      registrationNumber: json['registrationNumber'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      variant: json['variant'] ?? '',
      registrationDate: DateTime.parse(json['registrationDate']),
      yearOfManufacture: DateTime.parse(json['yearOfManufacture']),
      upcomingUntil: DateTime.parse(json['upcomingUntil']),
      auctionEndTime: DateTime.parse(json['auctionEndTime']),
      liveBids:
          (json['liveBids'] as List<dynamic>?)
              ?.map((e) => AuctionDetailsBidModel.fromJson(e))
              .toList() ??
          [],
      otobuyOffers:
          (json['otobuyOffers'] as List<dynamic>?)
              ?.map((e) => AuctionDetailsOtobuyOfferModel.fromJson(e))
              .toList() ??
          [],
      oneClickPrice: _toDouble(json['oneClickPrice']),
      customerExpectedPrice: _toDouble(json['customerExpectedPrice']),
    );
  }

  // Method to convert AuctionDetails to JSON
  Map<String, dynamic> toJson() {
    return {
      'auctionStatus': auctionStatus,
      'frontMainImage': frontMainImage,
      'registrationNumber': registrationNumber,
      'make': make,
      'model': model,
      'variant': variant,
      'registrationDate': registrationDate.toIso8601String(),
      'yearOfManufacture': yearOfManufacture.toIso8601String(),
      'upcomingUntil': upcomingUntil.toIso8601String(),
      'auctionEndTime': auctionEndTime.toIso8601String(),
      'liveBids': liveBids.map((e) => e.toJson()).toList(),
      'otobuyOffers': otobuyOffers.map((e) => e.toJson()).toList(),
      'oneClickPrice': oneClickPrice,
      'customerExpectedPrice': customerExpectedPrice,
    };
  }

  // Add copyWith method
  AuctionDetailsModel copyWith({
    String? carId,
    String? auctionStatus,
    String? frontMainImage,
    String? registrationNumber,
    String? make,
    String? model,
    String? variant,
    DateTime? registrationDate,
    DateTime? yearOfManufacture,
    DateTime? upcomingUntil,
    DateTime? auctionEndTime,
    List<AuctionDetailsBidModel>? liveBids,
    List<AuctionDetailsOtobuyOfferModel>? otobuyOffers,
    double? oneClickPrice,
    double? customerExpectedPrice,
  }) {
    return AuctionDetailsModel(
      carId: carId ?? this.carId,
      auctionStatus: auctionStatus ?? this.auctionStatus,
      frontMainImage: frontMainImage ?? this.frontMainImage,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      make: make ?? this.make,
      model: model ?? this.model,
      variant: variant ?? this.variant,
      registrationDate: registrationDate ?? this.registrationDate,
      yearOfManufacture: yearOfManufacture ?? this.yearOfManufacture,
      upcomingUntil: upcomingUntil ?? this.upcomingUntil,
      auctionEndTime: auctionEndTime ?? this.auctionEndTime,
      liveBids: liveBids ?? this.liveBids,
      otobuyOffers: otobuyOffers ?? this.otobuyOffers,
      oneClickPrice: oneClickPrice ?? this.oneClickPrice,
      customerExpectedPrice:
          customerExpectedPrice ?? this.customerExpectedPrice,
    );
  }

  // Default values method (returns an empty/default instance)
  static AuctionDetailsModel empty() {
    return AuctionDetailsModel(
      carId: '',
      auctionStatus: '',
      frontMainImage: '',
      registrationNumber: '',
      make: '',
      model: '',
      variant: '',
      registrationDate: DateTime.now(),
      yearOfManufacture: DateTime.now(),
      upcomingUntil: DateTime.now(),
      auctionEndTime: DateTime.now(),
      liveBids: [],
      otobuyOffers: [],
      oneClickPrice: 0.0,
      customerExpectedPrice: 0.0,
    );
  }
}

// Bid Model
class AuctionDetailsBidModel {
  final String offerBy;
  final DateTime date;
  final double amount;

  AuctionDetailsBidModel({
    required this.offerBy,
    required this.date,
    required this.amount,
  });

  // Factory method to create Bid from JSON
  factory AuctionDetailsBidModel.fromJson(Map<String, dynamic> json) {
    return AuctionDetailsBidModel(
      offerBy: json['offerBy'] ?? '',
      date: DateTime.parse(json['date']),
      amount: _toDouble(json['amount']),
    );
  }

  // Method to convert Bid to JSON
  Map<String, dynamic> toJson() {
    return {
      'offerBy': offerBy,
      'date': date.toIso8601String(),
      'amount': amount,
    };
  }
}

// Otobuy Offer Model
class AuctionDetailsOtobuyOfferModel {
  final String offerBy;
  final DateTime date;
  final double amount;

  AuctionDetailsOtobuyOfferModel({
    required this.offerBy,
    required this.date,
    required this.amount,
  });

  // Factory method to create OtobuyOffer from JSON
  factory AuctionDetailsOtobuyOfferModel.fromJson(Map<String, dynamic> json) {
    return AuctionDetailsOtobuyOfferModel(
      offerBy: json['offerBy'] ?? '',
      date: DateTime.parse(json['date']),
      amount: _toDouble(json['amount']),
    );
  }

  // Method to convert OtobuyOffer to JSON
  Map<String, dynamic> toJson() {
    return {
      'offerBy': offerBy,
      'date': date.toIso8601String(),
      'amount': amount,
    };
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}
