class CartModel {

  String prdctName;
  double price;
  String image;
  String size;
  String color;
  int quantity;
  String id;
  int discount;
  String brand;
  String category;

  CartModel({
    required this.prdctName,
    required this.price,
    required this.image,
    required this.id,
    required this.category,
    required this.brand,
    required this.color,
    required this.size,
    required this.quantity,
    required this.discount,
  });
  CartModel copyWith({
    String? prdctName,
    double? price,
    String? image,
    String? id,
    String? size,
    String? color,
    int? quantity,
    int? discount,
    String? category,
    String? brand,
  }) =>
      CartModel(
        prdctName: prdctName ?? this.prdctName,
        price: price ?? this.price,
        id: id ?? this.id,
        image: image ?? this.image,
        category: category ?? this.category,
        brand: brand ?? this.brand,
        color: color ?? this.color,
        size: size??this.size,
        quantity: quantity??this.quantity,
        discount: discount??this.discount
      );

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    prdctName: json["prdctName"],
    price: double.tryParse(json["price"].toString())??0,
    image: json["image"],
    id: json["id"],
    category: json["category"],
    brand: json["brand"],
    color: json["color"],
    size: json["size"],
    quantity:int.tryParse(json["quantity"].toString())??0,
    discount:int.tryParse(json["discount"].toString())??0,
  );

  Map<String, dynamic> toJson() => {
    "prdctName": prdctName,
    "price": price,
    "image":image,
    "id":id,
    "quantity":quantity,
    "discount":discount,
    "color":color,
    "size":size,
    "brand":brand,
    "category":category
  };
}