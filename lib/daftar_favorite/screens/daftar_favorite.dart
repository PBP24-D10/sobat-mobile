import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sobat_mobile/daftar_favorite/models/models.dart';
import 'package:sobat_mobile/daftar_favorite/widgets/list_product.dart';
import 'package:sobat_mobile/drug/models/drug_entry.dart';
import 'package:sobat_mobile/drug/screens/drug_detail.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<FavoriteEntry> favoriteProducts = [];
  final String baseUrl = 'http://localhost:8000/media/';
  // int totalFavorit = 0;

  Map<String, dynamic> productDetailsMap = {};
  Map<String, String> productPKMap = {};
  late Future<void> fetchFuture;
  @override
  void initState() {
    super.initState();

    fetchFuture = fetchMood(CookieRequest()); // Memuat data awal
  }

  Future<List<FavoriteEntry>> fetchMood(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/favorite/json/');
    var data = response;
    print(data);

    // Melakukan konversi data json menjadi object MoodEntry
    List<FavoriteEntry> listMood = [];
    for (var d in data) {
      if (d != null) {
        listMood.add(FavoriteEntry.fromJson(d));
        String b = d["fields"]["product"];

        String pk = d['pk'];
        productPKMap[b] = pk;

        final responses =
            await http.get(Uri.parse('http://127.0.0.1:8000/product/json/$b/'));
        var test = jsonDecode(responses.body);
        var fields = test[0]["fields"];
        productDetailsMap[b] = fields;

        // print(productDetailsMap);
        // var test = responseJson;
        // print(test);
      }
    }
    // print(listMood.toString());
    return listMood;
  }

  Future<DrugModel> fetchDrugDetails(String productId) async {
    print("Fetching product with ID: $productId");

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/product/json/$productId/'),
    );

    if (response.statusCode == 200) {
      // Pastikan respons adalah Map<String, dynamic>
      final List<dynamic> jsonList = jsonDecode(response.body);
      if (jsonList.isNotEmpty) {
        // Ambil elemen pertama dari list
        final Map<String, dynamic> jsonMap = jsonList[0];
        return DrugModel.fromJson(jsonMap);
      } else {
        throw Exception("Data produk tidak ditemukan");
      }
    } else {
      throw Exception("Gagal memuat produk: ${response.statusCode}");
    }
  }

  void navigateToProductDetail(
      BuildContext context, String productId, String productPk) async {
    try {
      DrugModel product = await fetchDrugDetails(productId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(
            product: product.fields,
            detailRoute: () => deleteProduct(productPk),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat detail produk: $e")),
      );
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/favorite/api/$productId/'),
        headers: {
          'Content-Type': 'application/json',
          // Sertakan CSRF token
        },
      );

      if (response.statusCode == 200) {
        print('Produk berhasil dihapus');
        List<FavoriteEntry> updatedFavorites = await fetchMood(CookieRequest());
        setState(() {
          favoriteProducts = updatedFavorites; // Perbarui state
        });
        // await fetchMood(CookieRequest());
      } else {
        print('Gagal menghapus produk. Status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      String productId = product.fields.product;
                      String url = productDetailsMap[productId]["image"];
                      String imageUrl = '$baseUrl$url';
                      String productPk = productPKMap[productId] ?? '';
                      String drugForm =
                          productDetailsMap[productId]["drug_form"];
                      String drugCategory =
                          productDetailsMap[productId]["category"];

                      ;

                      // Get the product details from the map (this should be updated once product data is loaded)
                      // Map<String, dynamic>? productDetails =
                      //     productDetailsMap[productId];
                      // String productName = productDetails != null
                      //     ? productDetails['fields']['name']
                      //     : 'Loading...';

                      return productTile(
                        name: productDetailsMap[productId]["name"],
                        price: productDetailsMap[productId]["price"],
                        imageUrl: imageUrl,
                        onPressed: () => deleteProduct(productPk),
                        drugForm: drugForm,
                        category: drugCategory,
                        detailRoute: () => navigateToProductDetail(
                            context, productId, productPk),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
