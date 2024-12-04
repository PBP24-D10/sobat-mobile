import 'package:flutter/material.dart';
import 'package:sobat_mobile/review/models/review.dart';

class ReviewTile extends StatelessWidget {
  final Review item;
  const ReviewTile(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "By: ${item.username}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rating: ${item.rating}/5",
                  style: TextStyle(color: Colors.yellow[800]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.comment,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Date Published: ${item.dateCreated.toLocal().toString().split(' ')[0]}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text("Edit"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}