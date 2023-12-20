import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String name;
  String id;
  String email;
  bool delete;
  String profilePic;
  List<Map<String,dynamic>> cart;
  List<String> cartId;
  DateTime date;
  DocumentReference reference;

  UserModel({
    required this.name,
    required this.id,
    required this.delete,
    required this.reference,
    required this.cartId,
    required this.cart,
    required this.email,
    required this.profilePic,
    required this.date
  });
  UserModel copyWith({
    String? name,
    String? id,
    bool? delete,
    String? email,
    String? profilePic,
    List<Map<String,dynamic>>? cart,
    List<String>? cartId,
    DateTime? date,
    DocumentReference? reference,
  })=>
      UserModel
        (name: name?? this.name,
        id: id?? this.id,
        delete: delete?? this.delete,
        reference: reference?? this.reference,
        email: email ?? this.email,
        date: date ?? this.date,
        profilePic: profilePic ?? this.profilePic,
          cartId: cartId??this.cartId,
        cart: cart?? this.cart
      );
  factory UserModel.fromjson(dynamic json)=>UserModel(
      name: json["name"],
      id: json["id"],
      delete: json["delete"],
      reference: json["reference"],
      email: json['email'],
      date: json["date"].toDate(),
      profilePic: json["profilePic"],
    cartId:List<String>.from(json["cartId"]),
    cart:List<Map<String,dynamic>>.from(json["cart"]),
  );
  Map<String,dynamic> toJson()=>{
    "name":name,
    "id":id,
    "delete":delete,
    "reference":reference,
    'email':email,
    "profilePic":profilePic,
    "cart":cart,
    "cartId":cartId,
    'date':date
  };
}