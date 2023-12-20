import 'package:cloud_firestore/cloud_firestore.dart';

class ProductList {

  String prdctName;
  double price;
  bool delete;
  String image;
  String id;
  List<String> cart;
  List<String> favourite;
  String description;
  double ratingOne;
  double ratingTwo;
  double ratingThree;
  double ratingFour;
  double ratingFive;
  String brand;
  int discount;
  String category;
  DateTime date;
  DocumentReference reference;

  ProductList({
    required this.prdctName,
    required this.price,
    required this.delete,
    required this.favourite,
    required this.cart,
    required this.image,
    required this.id,
    required this.description,
    required this.category,
    required this.ratingOne,
    required this.ratingTwo,
    required this.ratingThree,
    required this.ratingFour,
    required this.ratingFive,
    required this.date,
    required this.brand,
    required this.discount,
    required this.reference,
  });

  ProductList copyWith({
    String? prdctName,
    double? price,
    bool? delete,
    List<String>? favourite,
    List<String>? cart,
    double? ratingTwo,
    double? ratingOne,
    double? ratingThree,
    double? ratingFour,
    double? ratingFive,
    String? image,
    String? id,
    String? description,
    String? category,
    String? brand,
    int? discount,
    DateTime? date,
    DocumentReference? reference,
  }) =>
      ProductList(
        prdctName: prdctName ?? this.prdctName,
        price: price ?? this.price,
        delete: delete ?? this.delete,
        id: id ?? this.id,
        date: date ?? this.date,
        description: description ?? this.description,
        reference: reference?? this.reference,
        image: image ?? this.image,
        favourite: favourite ?? this.favourite,
        category: category ?? this.category,
        brand: brand ?? this.brand,
        cart: cart??this.cart,
        discount: discount??this.discount,
          ratingOne: ratingOne??this.ratingOne,
          ratingTwo: ratingTwo??this.ratingTwo,
          ratingThree: ratingThree??this.ratingThree,
          ratingFour: ratingFour??this.ratingFour,
          ratingFive: ratingFive??this.ratingFive,
      );

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
    prdctName: json["prdctName"],
    price: double.tryParse(json["price"].toString())??0,
    delete: json["delete"],
    image: json["image"],
    id: json["id"],
    date: json["date"].toDate(),
    reference: json["reference"],
    description: json["description"],
    favourite: List<String>.from(json["favourite"]),
    category: json["category"],
    brand: json["brand"],
    cart:List<String>.from(json["cart"]),
    discount: int.tryParse(json["discount"].toString())??0,
    ratingOne: double.tryParse(json["ratingOne"].toString())??0,
    ratingTwo: double.tryParse(json["ratingTwo"].toString())??0,
    ratingThree: double.tryParse(json["ratingThree"].toString())??0,
    ratingFour: double.tryParse(json["ratingFour"].toString())??0,
    ratingFive: double.tryParse(json["ratingFive"].toString())??0,
  );

  Map<String, dynamic> toJson() => {
    "prdctName": prdctName,
    "price": price,
    "delete":delete,
    "image":image,
    "id":id,
    "description":description,
    "ratingOne":ratingOne,
    "ratingTwo":ratingTwo,
    "ratingThree":ratingThree,
    "ratingFour":ratingFour,
    "ratingFive":ratingFive,
    "date":date,
    "reference":reference,
    "favourite":favourite,
    "discount":discount,
    "cart":cart,
    "brand":brand,
    "category":category
  };
}