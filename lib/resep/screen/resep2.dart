import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sobat_mobile/drug/models/drug_entry.dart';
import 'package:sobat_mobile/drug/screens/drug_detail.dart';
import 'package:sobat_mobile/resep/models/resep_model.dart';

void main() => runApp(CartList());

class CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CartPage(),
    );
  }
}

Future<List<Resep>> fetchProducts() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/resep/json/'));
  
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Resep.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {'name': 'Aciblock', 'price': 7200, 'quantity': 1, 'subtotal': 7200},
    {'name': 'Aspar-K', 'price': 42000, 'quantity': 2, 'subtotal': 84000},
    {'name': 'Fenofibrate Hexpharm 100mg', 'price': 2927, 'quantity': 2, 'subtotal': 5854},
  ];

  @override
  Widget build(BuildContext context) {
    int totalPrice = products.fold(0, (sum, item) => sum + (item['subtotal'] as num).toInt());

    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  child: ListTile(
                    leading: Image.asset('assets/product_placeholder.png', width: 50), // Ganti dengan gambar produk
                    title: Text(product['name']),
                    subtitle: Text('Price: Rp ${product['price']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {}, // Tambahkan logika pengurangan jumlah
                        ),
                        Text('${product['quantity']}'),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {}, // Tambahkan logika penambahan jumlah
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Total Price: Rp $totalPrice'),
          ),
          ElevatedButton(
            onPressed: () {
              _showConfirmationDialog(context, products, totalPrice);
            },
            child: Text('Checkout'),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, List<Map<String, dynamic>> products, int totalPrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              SizedBox(width: 8),
              Text('Purchase Summary'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...products.map((product) {
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text(
                      'Jumlah: ${product['quantity']} - Total: Rp ${product['subtotal']}'),
                );
              }).toList(),
              SizedBox(height: 16),
              Text(
                'Total Price: Rp $totalPrice',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Logika untuk menghapus semua produk
              },
              child: Text('Remove all medications', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Back to prescription'),
            ),
          ],
        );
      },
    );
  }
}
