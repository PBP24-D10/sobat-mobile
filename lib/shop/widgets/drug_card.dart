// shop/widgets/drug_card

import 'package:flutter/material.dart';
import 'package:sobat_mobile/drug/models/drug_entry.dart';

class DrugCard extends StatelessWidget {
  final DrugModel drug;
  static const String baseUrl = 'http://m-arvin-sobat.pbp.cs.ui.ac.id'; 

  const DrugCard({super.key, required this.drug});

  String _getImageUrl(String imagePath) {
    if (imagePath.isEmpty) return '';
    if (imagePath.startsWith('http')) return imagePath;
    
    // Encode the image path to handle spaces and special characters
    final encodedPath = Uri.encodeFull(imagePath);
    return '$baseUrl/media/${encodedPath.startsWith('/') ? encodedPath.substring(1) : encodedPath}';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _getImageUrl(drug.fields.image);
    print('Drug Image URL: $imageUrl'); // For debugging

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: drug.fields.image.isNotEmpty
              ? Image.network(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading drug image: $error');
                    return const Icon(
                      Icons.local_pharmacy,
                      color: Colors.grey,
                      size: 30,
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    );
                  },
                )
              : const Icon(
                  Icons.local_pharmacy,
                  color: Colors.grey,
                  size: 30,
                ),
        ),
        title: Text(
          drug.fields.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Category: ${drug.fields.category}",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              "Price: Rp ${drug.fields.price.toString()}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}