import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel{
  String name;
  String id;
  bool delete;
  DocumentReference reference;

  CategoryModel({
    required this.name,
    required this.id,
    required this.delete,
    required this.reference
  });
  CategoryModel copyWith({
    String? name,
    String? id,
    bool? delete,
    DocumentReference? reference,
  })=>
      CategoryModel
        (name: name?? this.name,
        id: id?? this.id,
        delete: delete?? this.delete,
        reference: reference?? this.reference,
      );
  factory CategoryModel.fromjson(dynamic json)=>CategoryModel(
      name: json["name"],
      id: json["id"],
      delete: json["delete"],
      reference: json["reference"]
  );
  Map<String,dynamic> toJson()=>{
    "name":name,
    "id":id,
    "delete":delete,
    "reference":reference,
  };
}