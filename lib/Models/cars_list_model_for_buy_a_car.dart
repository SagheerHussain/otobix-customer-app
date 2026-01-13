class CarsListModelForBuyACar {
  // User data
  final String userDocId; // id in firestore
  final String userPhoneNumber; // phoneNumber in firestore
  final String userRole; // role in firestore
  final String userCity; // city in firestore
  final String dealershipName; // name in firestore
  final String userAssignedPhone; // assignedPhone in firestore
  final String userState; // state in firestore
  final String userId; // userId in firestore
  final String userEmail; // email in firestore
  final String userName; // username in firestore

  // Car data
  final String carDocId; // id in firestore
  final String carContact; // contact in firestore
  final String carName; // name in firestore
  final String carDesc; // desc in firestore
  final String carPrice; // price in firestore
  final String carYear; // year in firestore
  final String carTaxValidity; // tax_validity in firestore
  final String carOwnershipSerialNo; // ownership_serial_no in firestore
  final String carMake; // make in firestore
  final String carModel; // model in firestore
  final String carVariant; // variant in firestore
  final String carKms; // kms in firestore
  final String carTransmission; // transmission in firestore
  final String carFuelType; // fuel_type in firestore
  final List<String> imageUrls; // images in firestore

  const CarsListModelForBuyACar({
    required this.userDocId,
    required this.userPhoneNumber,
    required this.userRole,
    required this.userCity,
    required this.dealershipName,
    required this.userAssignedPhone,
    required this.userState,
    required this.userId,
    required this.userEmail,
    required this.userName,
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
    required this.imageUrls,
  });

  /// Reads JSON where keys are EXACTLY your Dart field names
  factory CarsListModelForBuyACar.fromJson(Map<String, dynamic> json) {
    return CarsListModelForBuyACar(
      // User
      userDocId: json['userDocId'] ?? '',
      userPhoneNumber: json['userPhoneNumber'] ?? '',
      userRole: json['userRole'] ?? '',
      userCity: json['userCity'] ?? '',
      dealershipName: json['dealershipName'] ?? '',
      userAssignedPhone: json['userAssignedPhone'] ?? '',
      userState: json['userState'] ?? '',
      userId: json['userId'] ?? '',
      userEmail: json['userEmail'] ?? '',
      userName: json['userName'] ?? '',

      // Car
      carDocId: json['carDocId'] ?? '',
      carContact: json['carContact'] ?? '',
      carName: json['carName'] ?? '',
      carDesc: json['carDesc'] ?? '',
      carPrice: json['carPrice'] ?? '',
      carYear: json['carYear'] ?? '',
      carTaxValidity: json['carTaxValidity'] ?? '',
      carOwnershipSerialNo: json['carOwnershipSerialNo'] ?? '',
      carMake: json['carMake'] ?? '',
      carModel: json['carModel'] ?? '',
      carVariant: json['carVariant'] ?? '',
      carKms: json['carKms'] ?? '',
      carTransmission: json['carTransmission'] ?? '',
      carFuelType: json['carFuelType'] ?? '',
      imageUrls: parseImagesList(json['imageUrls']),
    );
  }

  /// Outputs JSON where keys are EXACTLY your Dart field names
  Map<String, dynamic> toJson() {
    return {
      // User
      'userDocId': userDocId,
      'userPhoneNumber': userPhoneNumber,
      'userRole': userRole,
      'userCity': userCity,
      'dealershipName': dealershipName,
      'userAssignedPhone': userAssignedPhone,
      'userState': userState,
      'userId': userId,
      'userEmail': userEmail,
      'userName': userName,

      // Car
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
      'imageUrls': imageUrls.map((x) => x).toList(),
    };
  }
}

List<String> parseImagesList(dynamic value) {
  if (value == null) return [];
  if (value is List) return value.map((e) => e.toString()).toList();
  //   if (value is String) return [value];
  if (value is String && value.trim().isNotEmpty) return [value];
  return [];
}
