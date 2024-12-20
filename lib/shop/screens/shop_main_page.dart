// lib/shop/screens/shop_main_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sobat_mobile/shop/models/shop_model.dart';  // Pastikan menggunakan ShopEntry dari shop_model.dart
import 'package:sobat_mobile/shop/widgets/shop_card.dart';
import 'package:sobat_mobile/shop/screens/shop_form.dart';
import 'package:sobat_mobile/widgets/left_drawer.dart';
import 'package:http/http.dart' as http;

class ShopMainPage extends StatefulWidget {
  const ShopMainPage({super.key});

  @override
  State<ShopMainPage> createState() => _ShopMainPageState();
}

class _ShopMainPageState extends State<ShopMainPage> {
  String userRole = '';

  Future<List<ShopEntry>> fetchShops(CookieRequest request) async {
    try {
      print("Attempting to fetch shops...");
      
      final response = await http.get(
        Uri.parse('http://localhost:8000/shop/show-json/'),  // Gunakan localhost untuk web
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> decoded = json.decode(response.body);
        return decoded.map((data) => ShopEntry.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load shops: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print("Error fetching shops: $e");
      print("Stack trace: $stackTrace");
      rethrow;
    }
  }

  Future<void> fetchUserRole(CookieRequest request) async {
    try {
      final response = await request.get('http://10.0.2.2:8000/user/role/');
      if (response.containsKey('role')) {
        setState(() {
          userRole = response['role'];
        });
      } else {
        throw Exception("Role information not available");
      }
    } catch (e) {
      debugPrint("Error fetching user role: $e");
      setState(() {
        userRole = '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    fetchUserRole(request);
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
                return ShopCard(shop: shop); // Gunakan ShopEntry dari shop_model.dart
              },
            );
          }
        },
      ),
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
          : null,
    );
  }
}
