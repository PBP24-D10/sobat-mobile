import 'dart:convert';

ProductEntry productEntryFromJson(String str) =>
    ProductEntry.fromJson(json.decode(str));

String productEntryToJson(ProductEntry data) => json.encode(data.toJson());

class ProductEntry {
  String user;
  String product;
  String catatan;
  String id;

  ProductEntry({
    required this.user,
    required this.product,
    required this.catatan,
    required this.id,
  });

  factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
        id: json["id"],
        user: json["user"],
        product: json["product"],
        catatan: json["catatan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "product": product,
        "catatan": catatan,
      };
}
