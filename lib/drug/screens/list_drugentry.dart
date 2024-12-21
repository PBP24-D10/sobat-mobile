import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sobat_mobile/drug/models/drug_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sobat_mobile/drug/screens/drug_detail.dart';
import 'package:sobat_mobile/drug/screens/drugentry_form.dart'; // Assuming the form is in this file
import 'package:http/http.dart' as http;

class DrugEntryPage extends StatefulWidget {
  const DrugEntryPage({super.key});

  @override
  State<DrugEntryPage> createState() => _DrugEntryPageState();
}

class _DrugEntryPageState extends State<DrugEntryPage> {
  Future<List<DrugModel>> fetchProductEntries(CookieRequest request) async {
    final response = await request.get('http://localhost:8000/product/json/');
    var data = response;

    List<DrugModel> listProduct = [];
    for (var d in data) {
      if (d != null) {
        try {
          final entry = DrugModel.fromJson(d);

          listProduct.add(entry);
        } catch (e) {
          // Handle any error during data parsing
        }
      }
    }
    return listProduct;
  }

  Future<String?> fetchCsrfToken() async {
    try {
      final response = await http
          .get(Uri.parse('http://127.0.0.1:8000/favorite/get-csrf-token/'));
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['csrf_token'];
      }
    } catch (error) {
      print('Error fetching CSRF token: $error');
    }
    return null;
  }

  Future<void> addToFavorite(String productId, CookieRequest request) async {
    try {
      // Kirim permintaan POST ke endpoint favorit
      final response = await request
          .post('http://127.0.0.1:8000/favorite/api/add/$productId/', {});
      // headers: {
      //   'Content-Type': 'application/json',
      //   // 'X-CSRFToken': csrfToken, // Menambahkan CSRF token
      // },

      // if (response.statusCode == 200) {
      //   // Jika berhasil, ubah UI sesuai dengan respons
      //   print('Produk berhasil ditambahkan ke favorit!');
      //   // Menampilkan pesan atau memperbarui UI sesuai respons
      // } else {
      //   print(
      //       'Gagal menambahkan produk ke favorit. Status: ${response.statusCode}');
      //   // Tampilkan pesan error
      // }
    } catch (error) {
      print('Terjadi kesalahan: $error');
    }
  }
  // Future<bool> deleteProduct(CookieRequest request, String productId) async {
  //   final response = await request.delete('http://localhost:8000/product/delete/$productId/');
  //   if (response.statusCode == 200) {
  //     return true; // Berhasil menghapus
  //   } else {
  //     return false; // Gagal menghapus
  //   }
  // }

  Future<bool> deleteProduct(String productId) async {
    final url = 'http://localhost:8000/product/delete-drug/$productId/';
    final response = await http.get(Uri.parse(url));

    return response.statusCode == 200;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Entry List'),
      ),
      body: FutureBuilder(
        future: fetchProductEntries(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum ada data produk pada Grosa.',
                      style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final product = snapshot.data![index];

                  return InkWell(
                    onTap: () {
                      // Navigasi ke halaman detail produk
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            product: product.fields,
                            detailRoute: () =>
                                addToFavorite(product.pk, request),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nama Produk: ${product.fields.name}",
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text("Deskripsi: ${product.fields.desc}"),
                          const SizedBox(height: 10),
                          Text("Harga: \$${product.fields.price}"),
                          // Row for edit and delete buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  // Navigate to edit form, passing the selected product
                                  // Navigator.push(
                                  // context,
                                  // MaterialPageRoute(
                                  //   builder: (context) => DrugEntryForm(product: product),
                                  // ),
                                  // );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  bool success = await deleteProduct(
                                      product.pk.toString());
                                  if (success) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text('Product successfully deleted'),
                                    ));
                                    // Optionally refresh the list or navigate away
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Failed to delete product'),
                                    ));
                                  }
                                },
                                // child: Text('Delete Product'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
      // Floating action button to navigate to the drug entry form for adding new drug
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddDrugForm()), // Navigate to the add drug form
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
