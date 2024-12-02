// // To parse this JSON data, do
// //
// //     final welcome = welcomeFromJson(jsonString);

// import 'dart:convert';
// import 'package:sobat_mobile/drug/screens/list_drugentry.dart';

// List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

// String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class Welcome {
//     Model model;
//     String pk;
//     DrugEntry fields;

//     Welcome({
//         required this.model,
//         required this.pk,
//         required this.fields,
//     });

//     factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
//         model: modelValues.map[json["model"]]!,
//         pk: json["pk"],
//         fields: DrugEntry.fromJson(json["fields"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "model": modelValues.reverse[model],
//         "pk": pk,
//         "fields": fields.toJson(),
//     };
// }

// class DrugEntry {
//     String name;
//     String desc;
//     String category;
//     DrugType drugType;
//     String drugForm;
//     int price;
//     String image;
//     List<String> shops;

//     DrugEntry({
//         required this.name,
//         required this.desc,
//         required this.category,
//         required this.drugType,
//         required this.drugForm,
//         required this.price,
//         required this.image,
//         required this.shops,
//     });

//     factory DrugEntry.fromJson(Map<String, dynamic> json) => DrugEntry(
//         name: json["name"],
//         desc: json["desc"],
//         category: json["category"],
//         drugType: drugTypeValues.map[json["drug_type"]]!,
//         drugForm: json["drug_form"],
//         price: json["price"],
//         image: json["image"],
//         shops: List<String>.from(json["shops"].map((x) => x)),
//     );

//     Map<String, dynamic> toJson() => {
//         "name": name,
//         "desc": desc,
//         "category": category,
//         "drug_type": drugTypeValues.reverse[drugType],
//         "drug_form": drugForm,
//         "price": price,
//         "image": image,
//         "shops": List<dynamic>.from(shops.map((x) => x)),
//     };
// }

// enum DrugType {
//     MODERN,
//     TRADISIONAL
// }

// final drugTypeValues = EnumValues({
//     "Modern": DrugType.MODERN,
//     "Tradisional": DrugType.TRADISIONAL
// });

// enum Model {
//     PRODUCT_DRUGENTRY
// }

// final modelValues = EnumValues({
//     "product.drugentry": Model.PRODUCT_DRUGENTRY
// });

// class EnumValues<T> {
//     Map<String, T> map;
//     late Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//             reverseMap = map.map((k, v) => MapEntry(v, k));
//             return reverseMap;
//     }
// }
