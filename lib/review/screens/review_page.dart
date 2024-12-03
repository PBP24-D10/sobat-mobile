import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sobat_mobile/review/widgets/review_card.dart';
import 'package:sobat_mobile/review/screens/review_form.dart';
import 'package:sobat_mobile/review/models/review.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  Future<List<Review>> fetchReviews(CookieRequest request) async {
    var id = 'a95e7d2e-d80d-4016-af7a-56329ba8af07';
    final response = await request.get('http://localhost:8000/review/$id/json/');
    var data = response;
    List<Review> reviewList = [];
    for (var d in data) {
      if (d != null) {
        reviewList.add(Review.fromJson(d));
      }
    }
    return reviewList;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: FutureBuilder(
        future: fetchReviews(request),
        builder: (context, AsyncSnapshot<List<Review>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load reviews. Please try again.'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No Reviews Are Present",
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          } else {
            final reviews = snapshot.data!;
            final averageRating = reviews.isNotEmpty
                ? reviews.map((e) => e.rating).reduce((a, b) => a + b) / reviews.length
                : 0.0;

            return SingleChildScrollView(
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReviewFormPage(),
                            ),
                          );
                        },
                        child: const Text('Add Review'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Average Rating: ${averageRating.toStringAsFixed(1)}/5",
                      style: TextStyle(
                        color: Colors.yellow[800],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: reviews.map((review) => ReviewTile(review)).toList(),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
