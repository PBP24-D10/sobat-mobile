import 'package:flutter/material.dart';
import 'package:sobat_mobile/shop/models/shop_model.dart';

class ShopDetailPage extends StatelessWidget {
  final ShopEntry shop;

  const ShopDetailPage({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          shop.fields.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Profile Image
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                image: shop.fields.profileImage.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(shop.fields.profileImage),
                      fit: BoxFit.cover,
                    )
                  : null,
              ),
              child: shop.fields.profileImage.isEmpty
                ? Center(
                    child: Icon(
                      Icons.storefront,
                      size: 100,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : null,
            ),

            // Shop Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shop Name
                  Text(
                    shop.fields.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Address
                  DetailRow(
                    icon: Icons.location_on,
                    title: 'Address',
                    content: shop.fields.address,
                  ),
                  const SizedBox(height: 10),

                  // Operating Hours
                  DetailRow(
                    icon: Icons.access_time,
                    title: 'Operating Hours',
                    content: '${shop.fields.openingTime} - ${shop.fields.closingTime}',
                  ),
                  const SizedBox(height: 10),

                  // Additional Details
                  DetailRow(
                    icon: Icons.info_outline,
                    title: 'Established',
                    content: shop.fields.createdAt.toString().split(' ')[0],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const DetailRow({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}