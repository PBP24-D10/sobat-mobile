import 'package:flutter/material.dart';
// import 'package:sobat_mobile/drug/models/drug_entry.dart';
// import 'package:grosa/widgets/left_drawer.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:sobat_mobile/drug/screens/drug_detail.dart'; 

// Model untuk DrugEntry
class DrugEntry {
  final String name;
  final String description;
  final double price;

  DrugEntry({required this.name, required this.description, required this.price});
}

class DrugDummy extends StatefulWidget {
  const DrugDummy({super.key});

  @override
  State<DrugDummy> createState() => _DrugDummyState();
}

class _DrugDummyState extends State<DrugDummy> {
  Future<List<DrugEntry>> fetchDummyProductEntries() async {
    // Dummy data
    await Future.delayed(const Duration(seconds: 1)); // Simulasi delay
    return [
      DrugEntry(name: "Paracetamol", description: "Obat untuk menurunkan demam", price: 5000),
      DrugEntry(name: "Ibuprofen", description: "Obat anti-inflamasi", price: 7500),
      DrugEntry(name: "Amoxicillin", description: "Antibiotik untuk infeksi bakteri", price: 12000),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Entry List'),
      ),
      // drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchDummyProductEntries(),
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
                          builder: (context) => ProductDetailPage(product: product),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // perubahan posisi bayangan
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nama Produk: ${product.name}",
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text("Deskripsi: ${product.description}"),
                          const SizedBox(height: 10),
                          Text("Harga: \$${product.price.toStringAsFixed(2)}"),
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
    );
  }
}

// Dummy ProductDetailPage untuk navigasi
class ProductDetailPage extends StatelessWidget {
  final DrugEntry product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(product.description),
            const SizedBox(height: 16),
            Text("Harga: \$${product.price.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }
}
