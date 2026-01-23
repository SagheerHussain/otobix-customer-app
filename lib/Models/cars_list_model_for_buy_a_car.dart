class CarsListModelForBuyACar {
  final String dealerDocId;
  final String dealerPhoneNumber;
  final String dealerRole;
  final String dealerCity;
  final String dealerName;
  final String dealerAssignedPhone;
  final String dealerState;
  final String dealerUserId;
  final String dealerEmail;
  final String dealerUserName;

  final String carDocId;
  final String carContact;
  final String carName;
  final String carDesc;
  final String carPrice;
  final String carYear;
  final String carTaxValidity;
  final String carOwnershipSerialNo;
  final String carMake;
  final String carModel;
  final String carVariant;
  final String carKms;
  final String carTransmission;
  final String carFuelType;
  final String carBodyType;
  final List<CarImageUrlModel> carImageUrls;

  final bool isDeleted;
  final DateTime? scrapedAt;
  final DateTime? uploadedAt;

  final String activityType;
  final String interestedBuyerId;

  const CarsListModelForBuyACar({
    required this.dealerDocId,
    required this.dealerPhoneNumber,
    required this.dealerRole,
    required this.dealerCity,
    required this.dealerName,
    required this.dealerAssignedPhone,
    required this.dealerState,
    required this.dealerUserId,
    required this.dealerEmail,
    required this.dealerUserName,
    required this.carDocId,
    required this.carContact,
    required this.carName,
    required this.carDesc,
    required this.carPrice,
    required this.carYear,
    required this.carTaxValidity,
    required this.carOwnershipSerialNo,
    required this.carMake,
    required this.carModel,
    required this.carVariant,
    required this.carKms,
    required this.carTransmission,
    required this.carFuelType,
    required this.carBodyType,
    required this.carImageUrls,
    required this.isDeleted,
    required this.scrapedAt,
    required this.uploadedAt,
    required this.activityType,
    required this.interestedBuyerId,
  });

  factory CarsListModelForBuyACar.fromJson(Map<String, dynamic> json) {
    return CarsListModelForBuyACar(
      dealerDocId: json['dealerDocId'] ?? '',
      dealerPhoneNumber: json['dealerPhoneNumber'] ?? '',
      dealerRole: json['dealerRole'] ?? '',
      dealerCity: json['dealerCity'] ?? '',
      dealerName: json['dealerName'] ?? '',
      dealerAssignedPhone: json['dealerAssignedPhone'] ?? '',
      dealerState: json['dealerState'] ?? '',
      dealerUserId: json['dealerUserId'] ?? '',
      dealerEmail: json['dealerEmail'] ?? '',
      dealerUserName: json['dealerUserName'] ?? '',
      carDocId: json['carDocId'] ?? '',
      carContact: json['carContact'] ?? '',
      carName: json['carName'] ?? '',
      carDesc: json['carDesc'] ?? '',
      carPrice: json['carPrice'] ?? '',
      carYear: (json['carYear'] ?? '').toString(),
      carTaxValidity: json['carTaxValidity'] ?? '',
      carOwnershipSerialNo: json['carOwnershipSerialNo'] ?? '',
      carMake: json['carMake'] ?? '',
      carModel: json['carModel'] ?? '',
      carVariant: json['carVariant'] ?? '',
      carKms: json['carKms'] ?? '',
      carTransmission: json['carTransmission'] ?? '',
      carFuelType: json['carFuelType'] ?? '',
      carBodyType: json['carBodyType'] ?? '',
      carImageUrls: parseCarImageUrls(json['carImageUrls']),
      isDeleted: json['isDeleted'] ?? false,
      scrapedAt: parseDateTime(json['scrapedAt']),
      uploadedAt: parseDateTime(json['uploadedAt']),
      activityType: json['activityType'] ?? 'interested',
      interestedBuyerId: json['interestedBuyerId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dealerDocId': dealerDocId,
      'dealerPhoneNumber': dealerPhoneNumber,
      'dealerRole': dealerRole,
      'dealerCity': dealerCity,
      'dealerName': dealerName,
      'dealerAssignedPhone': dealerAssignedPhone,
      'dealerState': dealerState,
      'dealerUserId': dealerUserId,
      'dealerEmail': dealerEmail,
      'dealerUserName': dealerUserName,
      'carDocId': carDocId,
      'carContact': carContact,
      'carName': carName,
      'carDesc': carDesc,
      'carPrice': carPrice,
      'carYear': carYear,
      'carTaxValidity': carTaxValidity,
      'carOwnershipSerialNo': carOwnershipSerialNo,
      'carMake': carMake,
      'carModel': carModel,
      'carVariant': carVariant,
      'carKms': carKms,
      'carTransmission': carTransmission,
      'carFuelType': carFuelType,
      'carBodyType': carBodyType,
      'carImageUrls': carImageUrls.map((e) => e.toJson()).toList(),
      'isDeleted': isDeleted,
      'scrapedAt': scrapedAt?.toIso8601String(),
      'uploadedAt': uploadedAt?.toIso8601String(),
      'activityType': activityType,
      'interestedBuyerId': interestedBuyerId,
    };
  }
}

class CarImageUrlModel {
  final String path;
  final bool status;
  final String url;

  const CarImageUrlModel({
    required this.path,
    required this.status,
    required this.url,
  });

  factory CarImageUrlModel.fromJson(Map<String, dynamic> json) {
    return CarImageUrlModel(
      path: json['path'] ?? '',
      status: json['status'] ?? false,
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'path': path, 'status': status, 'url': url};
  }
}

List<CarImageUrlModel> parseCarImageUrls(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return value
        .where((e) => e is Map)
        .map((e) => CarImageUrlModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
  return [];
}

DateTime? parseDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String && value.trim().isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}
