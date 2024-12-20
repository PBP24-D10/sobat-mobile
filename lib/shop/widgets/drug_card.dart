// shop/widgets/drug_card

import 'package:flutter/material.dart';
import 'package:sobat_mobile/drug/models/drug_entry.dart';

class DrugCard extends StatelessWidget {
  final DrugModel drug;

  const DrugCard({super.key, required this.drug});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: drug.fields.image.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  drug.fields.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(Icons.local_pharmacy, size: 50, color: Colors.grey),
        title: Text(
          drug.fields.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Category: ${drug.fields.category}\nPrice: Rp ${drug.fields.price}",
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        isThreeLine: true,
      ),
    );
  }
}
