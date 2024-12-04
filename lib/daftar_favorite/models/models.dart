import 'dart:convert';

FavoriteEntry FavoriteEntryFromJson(String str) =>
    FavoriteEntry.fromJson(json.decode(str));

String FavoriteEntryToJson(FavoriteEntry data) => json.encode(data.toJson());

class FavoriteEntry {
  String user;
  String product;
  String catatan;
  String id;

  FavoriteEntry({
    required this.user,
    required this.product,
    required this.catatan,
    required this.id,
  });

  factory FavoriteEntry.fromJson(Map<String, dynamic> json) => FavoriteEntry(
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
