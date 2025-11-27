class SellMyCarBannersModel {
  final String? id;
  final String imageUrl;
  final String screenName;
  final String status;
  final String type;
  final String cloudinaryPublicId;

  SellMyCarBannersModel({
    this.id,
    required this.screenName,
    required this.imageUrl,
    required this.status,
    required this.type,
    required this.cloudinaryPublicId,
  });

  Map<String, dynamic> toJson() => {
    'imageUrl': imageUrl,
    'screenName': screenName,
    'status': status,
    'type': type,
    'cloudinaryPublicId': cloudinaryPublicId,
  };

  factory SellMyCarBannersModel.fromJson({
    required String documentId,
    required Map<String, dynamic> json,
  }) => SellMyCarBannersModel(
    id: documentId,
    imageUrl: json['imageUrl'] ?? '',
    screenName: json['screenName'] ?? '',
    status: json['status'] ?? '',
    type: json['type'] ?? '',
    cloudinaryPublicId: json['cloudinaryPublicId'] ?? '',
  );
}
