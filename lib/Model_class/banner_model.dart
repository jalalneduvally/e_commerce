
import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  String image;
  String id;
  bool delete;
  DocumentReference reference;

  BannerModel({
    required this.image,
    required this.id,
    required this.delete,
    required this.reference,
  });

  BannerModel copyWith({
    String? image,
    String? id,
    bool? delete,
    DocumentReference? reference,
  }) =>
      BannerModel(
        image: image ?? this.image,
        id: id ?? this.id,
        delete: delete ?? this.delete,
        reference: reference ?? this.reference,
      );

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    image: json["image"],
    id: json["id"],
    delete: json["delete"],
    reference: json["reference"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "id": id,
    "delete": delete,
    "reference": reference,
  };
}
