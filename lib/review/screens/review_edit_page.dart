import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditReviewPage extends StatefulWidget {
  final String reviewID;
  final String productID;
  final int initialRating;
  final String initialComment;

  const EditReviewPage({
    super.key,
    required this.reviewID,
    required this.productID,
    required this.initialRating,
    required this.initialComment,
  });

  @override
  State<EditReviewPage> createState() => _EditReviewPageState();
}

class _EditReviewPageState extends State<EditReviewPage> {
  final _formKey = GlobalKey<FormState>();
  String _comment = "";
  int? _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
    _comment = widget.initialComment;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Review'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<int>(
                  value: _rating,
                  decoration: InputDecoration(
                    hintText: "Rating",
                    labelText: "Rating",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  items: List.generate(5, (index) {
                    int rating = index + 1;
                    return DropdownMenuItem(
                      value: rating,
                      child: Text("$rating Star${rating > 1 ? 's' : ''}"),
                    );
                  }),
                  onChanged: (int? value) {
                    setState(() {
                      _rating = value;
                    });
                  },
                  validator: (int? value) {
                    if (value == null) {
                      return "Please rate the product!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _comment,
                  decoration: InputDecoration(
                    hintText: "Comment",
                    labelText: "Comment",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _comment = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Fill in the comment!";
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await request.postJson(
                          "http://localhost:8000/review/${widget.productID}/${widget.reviewID}/edit-flutter/",
                          jsonEncode(<String, dynamic>{
                            'rating': _rating,
                            'comment': _comment,
                          }),
                        );
                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Review has been updated!"),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("An error occurred. Please try again."),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Update",
                      style: TextStyle(color: Colors.white),
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
