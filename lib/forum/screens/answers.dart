import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sobat_mobile/drug/models/drug_entry.dart';
import 'package:sobat_mobile/forum/models/answer_entry.dart';
import 'package:sobat_mobile/forum/models/question_entry.dart';
import 'package:sobat_mobile/forum/screens/answers.dart';
import 'package:sobat_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class AnswersPage extends StatefulWidget {
  final Question question;

  const AnswersPage({super.key, required this.question});

  @override
  State<AnswersPage> createState() => _AnswersPageState();
}

class _AnswersPageState extends State<AnswersPage> {
  Future<List<Answer>> fetchAnswers(CookieRequest request) async {
    String questionId = widget.question.pk;

    final response = await request
        .get('http://127.0.0.1:8000/forum/show_json_answer/$questionId/');

    // Melakukan decode response menjadi bentuk json
    var data = response;

    // Melakukan konversi data json menjadi object Question
    List<Answer> listAnswer = [];
    for (var d in data) {
      if (d != null) {
        listAnswer.add(Answer.fromJson(d));
      }
    }
    return listAnswer;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    int id = request.jsonData['id'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum Q&A'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the question text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.question.fields.question,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Answers:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          // FutureBuilder for answers
          Expanded(
            child: FutureBuilder(
              future: fetchAnswers(request),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                  // return Center(
                  //   child: ElevatedButton(
                  //     onPressed: () async {
                  //       final response = await request.postJson(
                  //           "http://127.0.0.1:8000/review/9366302cbaf74bc09f190542e868403b/create-flutter/",
                  //           jsonEncode(<String, dynamic>{
                  //             'rating': 2,
                  //             'comment': "jelek",
                  //           }),
                  //       );
                  //     },
                  //     child: const Text("buat"),
                  //   ),
                  // );
                  return Center(
                    child: Text(
                      'role: $id',
                      style: const TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) => GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${snapshot.data![index].fields.user}"),
                            const SizedBox(height: 10),
                            Text("${snapshot.data![index].fields.answer}"),
                            const SizedBox(height: 10),
                            Text(
                                "Likes: ${snapshot.data![index].fields.numLikes}"),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
