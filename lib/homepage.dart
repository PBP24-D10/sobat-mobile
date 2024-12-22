// lib/homepage.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sobat_mobile/authentication/login.dart';
import 'package:sobat_mobile/colors.dart';
import 'package:sobat_mobile/drug/models/drug_entry.dart';
import 'package:sobat_mobile/drug/screens/drug_detail.dart';
import 'package:sobat_mobile/widgets/left_drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String baseUrl = 'https://m-arvin-sobat.pbp.cs.ui.ac.id/media/';
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(context),
      appBar: AppBar(
        title: const Text("Sobat"),
      ),
      drawer: LeftDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 1200) {
            return _buildLargeScreenLayout(context);
          } else if (constraints.maxWidth > 600) {
            return _buildMediumScreenLayout(context);
          } else {
            return _buildSmallScreenLayout(context);
          }
        },
      ),
    );
  }

  Future<List<DrugModel>> fetchProductEntries(CookieRequest request) async {
    final response = await request
        .get('https://m-arvin-sobat.pbp.cs.ui.ac.id/product/json/');
    var data = response;

    List<DrugModel> listProduct = [];
    for (var d in data) {
      if (d != null) {
        try {
          final entry = DrugModel.fromJson(d);

          listProduct.add(entry);
        } catch (e) {
          // Handle any error during data parsing
          print('Error parsing product data: $e');
        }
      }
    }
    return listProduct;
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(1),
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12.0,
              spreadRadius: 2.0,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4),
          child: GNav(
            tabBackgroundColor: Colors.green.shade900,
            tabBorderRadius: 30,
            iconSize: 20,
            gap: 5,
            tabs: [
              GButton(
                iconActiveColor: Colors.white,
                iconColor: Colors.black,
                icon: FontAwesomeIcons.house,
                onPressed: () {},
              ),
              GButton(
                iconActiveColor: Colors.white,
                iconColor: Colors.black,
                icon: FontAwesomeIcons.prescriptionBottleMedical,
                onPressed: () {},
              ),
              GButton(
                iconActiveColor: Colors.white,
                iconColor: Colors.black,
                icon: FontAwesomeIcons.shop,
                onPressed: () {},
              ),
              GButton(
                icon: FontAwesomeIcons.rightFromBracket,
                iconActiveColor: Colors.white,
                iconColor: Colors.black,
                onPressed: () async {
                  final response = await request.logout(
                      "https://m-arvin-sobat.pbp.cs.ui.ac.id/logout_mobile/");
                  if (context.mounted && response['status']) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallScreenLayout(BuildContext context) {
    final request = context.watch<CookieRequest>();
    String username = request.jsonData["username"];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, $username!",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Our Product",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[300]),
              ),
            ),
            const SizedBox(height: 20),
            _buildProductCategories(),
            const SizedBox(height: 20),
            _buildSectionHeader("Popular Drugs"),
            _buildGrid(context, crossAxisCount: 2),
            _buildSectionHeader("Shops"),
            _buildHorizontalShopList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMediumScreenLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSmallScreenLayout(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLargeScreenLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildGrid(context, crossAxisCount: 4),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildVerticalShopList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child:
              Image.asset('assets/modern.png', fit: BoxFit.contain, height: 90),
        ),
        Expanded(
          child: Image.asset('assets/traditional.png',
              fit: BoxFit.contain, height: 90),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, {required int crossAxisCount}) {
    final request = context.watch<CookieRequest>();
    return FutureBuilder(
        future: fetchProductEntries(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Text(
              'There are no questions yet...',
              style: TextStyle(
                fontSize: 20,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            );
          } else {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio:
                    0.7, // Adjust this value to control item height
              ),
              itemCount: 8,
              itemBuilder: (_, index) {
                final product = snapshot.data![index];
                final imageUrl = '$baseUrl${product.fields.image}';

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          product: product,
                          detailRoute: () => addToFavorite(product.pk, request),
                          onPressed: () => addToResep(product.pk, request),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image container
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                          size: 32,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          // Product details container
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      product.fields.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Rp${product.fields.price}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        });
  }

  Widget _buildHorizontalShopList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(8, (index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child:
                SizedBox(width: 120, height: 100, child: Text('Shop $index')),
          );
        }),
      ),
    );
  }

  Widget _buildVerticalShopList() {
    return Column(
      children: List.generate(8, (index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(title: Text('Shop $index')),
        );
      }),
    );
  }

  Future<void> addToResep(String productId, CookieRequest request) async {
    try {
      // Send POST request to favorite endpoint
      final response = await request.post(
        'https://m-arvin-sobat.pbp.cs.ui.ac.id/resep/flutter_add/$productId/',
        {},
      );

      if (response['status'] == 'success') {
        // If successful, show success dialog
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Berhasil!',
          text: 'Produk berhasil ditambahkan ke resep.',
          autoCloseDuration: Duration(seconds: 1),
          disableBackBtn: true,
          showConfirmBtn: false,
        );

        print('Produk berhasil ditambahkan ke resep!');
        // Optionally, update the UI or state here
      } else {
        // If the product is already in favorites, show error dialog
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Gagal!',
          text: 'Produk sudah ada di resep.',
          confirmBtnText: 'Kembali',
          onConfirmBtnTap: () {
            Navigator.pop(context); // Close the dialog
          },
        );
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
      // Optionally, show an error dialog here
    }
  }

  Future<void> addToFavorite(String productId, CookieRequest request) async {
    try {
      // Send POST request to favorite endpoint
      final response = await request.post(
        'http://m-arvin-sobat.pbp.cs.ui.ac.id/favorite/api/add/$productId/',
        {},
      );

      if (response['status'] == 'success') {
        // If successful, show success dialog
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Berhasil!',
          text: 'Produk berhasil ditambahkan ke favorit.',
          autoCloseDuration: Duration(seconds: 1),
          disableBackBtn: true,
          showConfirmBtn: false,
        );

        print('Produk berhasil ditambahkan ke favorit!');
        // Optionally, update the UI or state here
      } else {
        // If the product is already in favorites, show error dialog
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Gagal!',
          text: 'Produk sudah ada di favorit.',
          confirmBtnText: 'Kembali',
          onConfirmBtnTap: () {
            Navigator.pop(context); // Close the dialog
          },
        );
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
      // Optionally, show an error dialog here
    }
  }
}
