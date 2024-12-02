// // lib/screens/product_detail.dart
// import 'package:flutter/material.dart';
// import 'package:grosa/models/product_entry.dart';

// class ProductDetailPage extends StatelessWidget {
//   final ProductEntry product;

//   const ProductDetailPage({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // AppBar dengan tombol kembali otomatis
//       appBar: AppBar(
//         title: Text(product.fields.name),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Nama Produk
//             const Text(
//               "Nama Produk:",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             Text(
//               product.fields.name,
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 16),
//             // Deskripsi Produk
//             const Text(
//               "Deskripsi:",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             Text(
//               product.fields.description,
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 16),
//             // Harga Produk
//             const Text(
//               "Harga:",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             Text(
//               "\$${product.fields.price.toString()}",
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 16),
//             // Tambahkan atribut lain jika ada
//             // Contoh: Stok Produk
//             // if (product.fields.stock != null) ...[
//               const Text(
//                 "Stok:",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               Text(
//                 product.fields.stock.toString(),
//                 style: const TextStyle(fontSize: 18),
//               ),
//               const SizedBox(height: 16),
//             // ],
//             // Tombol Kembali (Opsional, karena AppBar sudah memiliki tombol kembali)
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Kembali"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
