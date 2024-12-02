import 'package:flutter/material.dart';
import 'review_card.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {

  final List<ReviewItem> reviews = [
    ReviewItem(
      rating: 5,
      comment: "Highly recommended.",
      userName: "Bob",
      datePublished: DateTime(2024, 12, 2),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Product Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Rp 111,111",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add review functionality
                  },
                  child: const Text('Add Review'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Average Rating: ${(reviews.isNotEmpty ? reviews.map((e) => e.rating).reduce((a, b) => a + b) / reviews.length : 0).toStringAsFixed(1)}/5",
                style: TextStyle(
                  color: Colors.yellow[800],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Search by User or Comment",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  items: const [
                    DropdownMenuItem(value: "All", child: Text("All Ratings")),
                    DropdownMenuItem(value: "1", child: Text("1 Star")),
                    DropdownMenuItem(value: "2", child: Text("2 Stars")),
                    DropdownMenuItem(value: "3", child: Text("3 Stars")),
                    DropdownMenuItem(value: "4", child: Text("4 Stars")),
                    DropdownMenuItem(value: "5", child: Text("5 Stars")),
                  ],
                  onChanged: (value) {},
                  hint: const Text("All Ratings"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (reviews.isNotEmpty)
              Column(
                children: reviews.map((review) => ReviewTile(review)).toList(),
              )
            else
              const Center(
                child: Text(
                  "No Reviews Are Present",
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}