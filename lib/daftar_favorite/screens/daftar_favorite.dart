import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:sobat_mobile/daftar_favorite/models/models.dart';
import 'package:sobat_mobile/daftar_favorite/widgets/list_product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  Map<String, dynamic> productDetailsMap = {};

  // @override
  // void initState() {
  //   super.initState();
  //   futureProducts = fetchProducts();
  // }

  Future<List<FavoriteEntry>> fetchMood(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/favorite/json/');
    var data = response;

    // Melakukan konversi data json menjadi object MoodEntry
    List<FavoriteEntry> listMood = [];
    for (var d in data) {
      if (d != null) {
        listMood.add(FavoriteEntry.fromJson(d));
        String b = d["fields"]["product"];

        final responses =
            await http.get(Uri.parse('http://127.0.0.1:8000/product/json/$b/'));
        var test = jsonDecode(responses.body);
        var fields = test[0]["fields"];
        productDetailsMap[b] = fields;

        print(productDetailsMap);
        // var test = responseJson;
        // print(test);
      }
    }
    return listMood;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Produk Favorit"),
      ),
      body: FutureBuilder(
        future: fetchMood(CookieRequest()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi kesalahan: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada produk favorit.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                String productId = product.fields.product;

                // Get the product details from the map (this should be updated once product data is loaded)
                // Map<String, dynamic>? productDetails =
                //     productDetailsMap[productId];
                // String productName = productDetails != null
                //     ? productDetails['fields']['name']
                //     : 'Loading...';

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      productTile(
                          name: productDetailsMap[productId]["name"],
                          price: productDetailsMap[productId]["price"]),
                      // Text(
                      //   productDetailsMap[productId]["name"],
                      //   style: const TextStyle(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // const SizedBox(height: 8),
                      // Text(product.fields.catatan),

                      // Text(productDetailsMap[productId].name)
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
