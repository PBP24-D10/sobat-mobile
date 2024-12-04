// import 'package:flutter/material.dart';
// import 'package:sobat_mobile/drug/models/drug_entry.dart';
// // import 'package:grosa/widgets/left_drawer.dart';
// // import 'package:pbp_django_auth/pbp_django_auth.dart';
// // import 'package:provider/provider.dart';
// import 'package:sobat_mobile/drug/screens/drug_detail.dart'; 

// class DrugEntryPage extends StatefulWidget {
//   const DrugEntryPage({super.key});

//   @override
//   State<DrugEntryPage> createState() => _DrugEntryPageState();
// }

// class _DrugEntryPageState extends State<DrugEntryPage> {
//   Future<List<DrugEntry>> fetchProductEntries(CookieRequest request) async {
//     final response = await request.get('http://localhost:8000/json/');

//     // Melakukan decode response menjadi bentuk json
//     var data = response;

//     // Melakukan konversi data json menjadi object DrugEntry
//     List<DrugEntry> listProduct = [];
//     for (var d in data) {
//       if (d != null) {
//         listProduct.add(DrugEntry.fromJson(d));
//       }
//     }
//     return listProduct;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final request = context.watch<CookieRequest>();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Product Entry List'),
//       ),
//       // drawer: const LeftDrawer(),
//       body: FutureBuilder(
//         future: fetchProductEntries(request),
//         builder: (context, AsyncSnapshot snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else {
//             if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Belum ada data produk pada Grosa.',
//                       style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
//                     ),
//                     SizedBox(height: 8),
//                   ],
//                 ),
//               );
//             } else {
//               return ListView.builder(
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (_, index) {
//                   final product = snapshot.data![index];
//                   return InkWell(
//                     onTap: () {
//                       // Navigasi ke halaman detail produk
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ProductDetailPage(product: product),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       padding: const EdgeInsets.all(20.0),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 2,
//                             blurRadius: 5,
//                             offset: const Offset(0, 3), // perubahan posisi bayangan
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Nama Produk: ${product.fields.name}",
//                             style: const TextStyle(
//                               fontSize: 18.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Text("Deskripsi: ${product.fields.description}"),
//                           const SizedBox(height: 10),
//                           Text("Harga: \$${product.fields.price}"),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//           }
//         },
//       ),
//     );
//   }
// }
