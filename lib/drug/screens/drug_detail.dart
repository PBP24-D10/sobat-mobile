import 'package:flutter/material.dart';
import 'package:sobat_mobile/drug/models/drug_entry.dart';

class ProductDetailPage extends StatelessWidget {
  final DrugModel product;

  // Define the base URL
  final String baseUrl = 'http://localhost:8000/media/';

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Construct the full URL for the image
    String imageUrl = '$baseUrl${product.fields.image}';

    return Scaffold(
      appBar: AppBar(
        title: Text(product.fields.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Center(
              child: Image.network(
                imageUrl,  // Use the full URL here
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width - 32, // Adjusting to the screen width minus padding
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Text('Unable to load image', textAlign: TextAlign.center);
                },
              ),
            ),
            const SizedBox(height: 24),
            // Name
            Text(
              "Nama:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              product.fields.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 16),
            // Price
            Text(
              "Harga:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey),
            ),
            Text(
              "\$${product.fields.price}",
              style: TextStyle(fontSize: 18, color: Colors.teal),
            ),
            const SizedBox(height: 16),
            // Description
            Text(
              "Deskripsi:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              product.fields.desc,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            // Other attributes
            // Example: Drug Type
            Text(
              "Tipe Obat:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              product.fields.drugType,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            // Example: Drug Form
            Text(
              "Bentuk Obat:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              product.fields.drugForm,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            // Back Button (Optional since AppBar has a back button)
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Kembali"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
