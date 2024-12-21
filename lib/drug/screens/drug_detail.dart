import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sobat_mobile/drug/models/drug_entry.dart';

class ProductDetailPage extends StatelessWidget {
  final DrugEntry product;
  final void Function()? detailRoute;

  String formatedPrice(int price) {
    final formattedPrice = NumberFormat.currency(
      locale: 'id_ID', // Locale Indonesia
      symbol: 'Rp ', // Simbol mata uang
      decimalDigits: 0, // Tanpa desimal
    ).format(price);
    return formattedPrice;
  }

  const ProductDetailPage(
      {super.key, required this.product, required this.detailRoute});

  // Define the base URL
  final String baseUrl = 'http://localhost:8000/media/';

  @override
  Widget build(BuildContext context) {
    String imageUrl = '$baseUrl${product.image}';

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Favorite Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: detailRoute,
                    icon: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                    ),
                    iconSize: 30,
                  ),
                ],
              ),
              // Image
              Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width - 32,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Unable to load image',
                        textAlign: TextAlign.center);
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Product Details
              Text(
                product.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              Text(
                product.drugForm,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              Text(
                "Deskripsi",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                product.desc,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Tipe Obat:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                product.drugType,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(25),
          color: const Color.fromARGB(255, 149, 191, 116),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${formatedPrice(product.price)}",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.cartShopping,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Add To Cart',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
  }
}
