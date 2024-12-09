import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sobat_mobile/shop/models/shop_model.dart';
import 'package:sobat_mobile/shop/widgets/shop_card.dart';
import 'package:sobat_mobile/shop/screens/shop_form.dart';
import 'package:sobat_mobile/widgets/left_drawer.dart';

class ShopMainPage extends StatefulWidget {
  const ShopMainPage({super.key});

  @override
  State<ShopMainPage> createState() => _ShopMainPageState();
}

class _ShopMainPageState extends State<ShopMainPage> {
  String userRole = ''; // to store user role from backend

  Future<List<ShopEntry>> fetchShops(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/shop/json/');
      if (response is List) {
        return response.map((data) => ShopEntry.fromJson(data)).toList();
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      debugPrint("Error fetching shops: $e");
      return [];
    }
  }

  Future<void> fetchUserRole(CookieRequest request) async {
    try {
      // Assuming backend provides user role in this endpoint
      final response = await request.get('http://127.0.0.1:8000/user/role/');
      if (response.containsKey('role')) {
        setState(() {
          userRole = response['role']; // set user role
        });
      } else {
        throw Exception("Role information not available");
      }
    } catch (e) {
      debugPrint("Error fetching user role: $e");
      setState(() {
        userRole = ''; // fallback if role cannot be fetched
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    fetchUserRole(request); // fetch user role on init
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Our Shops',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchShops(request),
        builder: (context, AsyncSnapshot<List<ShopEntry>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Failed to fetch shops: ${snapshot.error}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No shops available.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final shop = snapshot.data![index];
                return ShopCard(shop: shop);
              },
            );
          }
        },
      ),
      // Floating Action Button to Add New Shop
      floatingActionButton: userRole == 'apoteker'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopFormPage()),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null, // If user is not an apoteker, do not show the button
    );
  }
}
