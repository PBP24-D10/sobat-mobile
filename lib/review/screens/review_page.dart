import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sobat_mobile/review/widgets/review_card.dart';
import 'package:sobat_mobile/review/screens/review_add_form.dart';
import 'package:sobat_mobile/review/models/review.dart';

class ReviewPage extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String productID;

  const ReviewPage({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productID,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  Future<List<Review>> fetchReviews(CookieRequest request) async {
    var id = widget.productID;
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

  late Future<List<Review>> _reviewFuture;

  @override
  void initState() {
    super.initState();
    _reviewFuture = fetchReviews(context.read<CookieRequest>());
  }

  void refreshReviews() {
    setState(() {
      _reviewFuture = fetchReviews(context.read<CookieRequest>());
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    // String role = request.jsonData['role'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: FutureBuilder(
        future: _reviewFuture,
        builder: (context, AsyncSnapshot<List<Review>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load reviews. Please try again.'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          widget.productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.productPrice,
                          style: const TextStyle(
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
                      // if (role == 'pengguna')
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewFormPage(productID: widget.productID),
                              ),
                            ).then((value) {
                              if (value == true) refreshReviews();
                            });
                          },
                          child: const Text('Add Review'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          widget.productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.productPrice,
                          style: const TextStyle(
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
                      // if (role == 'pengguna')
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewFormPage(productID: widget.productID),
                              ),
                            ).then((value) {
                              if (value == true) refreshReviews();
                            });
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
                    children: reviews.map((review) {
                      return ReviewTile(
                        review,
                        onDelete: refreshReviews,
                      );
                    }).toList(),
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
