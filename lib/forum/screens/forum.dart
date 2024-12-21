import 'package:flutter/material.dart';
import 'package:sobat_mobile/drug/models/drug_entry.dart';
import 'package:sobat_mobile/forum/models/answer_entry.dart';
import 'package:sobat_mobile/forum/models/question_entry.dart';
import 'package:sobat_mobile/forum/screens/answers.dart';
import 'package:sobat_mobile/forum/screens/question_form.dart';
import 'package:sobat_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List<Question> questions = [];
  final String baseUrl = 'http://127.0.0.1:8000/media/';

  Future<String> fetchProductImage(
      CookieRequest request, String productId) async {
    final response =
        await request.get('http://127.0.0.1:8000/product/json/$productId/');
    return DrugModel.fromJson(response[0]).fields.image;
  }

  Future<List<Question>> fetchQuestions(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/forum/json/');
    List<Question> listQuestion = [];

    for (var d in response) {
      if (d != null) {
        Question question = Question.fromJson(d);

        if (question.fields.drugAsked != "") {
          String productId = question.fields.drugAsked;
          String productImage = await fetchProductImage(request, productId);
          question.fields.drugAsked = productImage;
        }

        listQuestion.add(question);
      }
    }
    return listQuestion;
  }

  Future<void> handleLike(
      CookieRequest request, Question question, int userId) async {
    final response = await request
        .post('http://127.0.0.1:8000/forum/like_question/${question.pk}/', {});

    if (response['status'] == 'success') {
      setState(() {
        int index = questions.indexWhere((q) => q.pk == question.pk);
        if (index != -1) {
          if (questions[index].fields.likes.contains(userId)) {
            questions[index].fields.likes.remove(userId);
            questions[index].fields.numLikes--;
          } else {
            questions[index].fields.likes.add(userId);
            questions[index].fields.numLikes++;
          }
        }
      });
    }
  }

  Future<void> handleDelete(CookieRequest request, Question question) async {
    try {
      final response = await request.post(
          'http://127.0.0.1:8000/forum/delete_question_flutter/${question.pk}/',
          {});

      if (response['status'] == 'success') {
        setState(() {
          questions.removeWhere((q) => q.pk == question.pk);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Question deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete question'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    int userId = request.jsonData['id'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum Q&A'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              "Ask questions, get answers, and share your knowledge with the community!",
              style: TextStyle(
                color: Color.fromARGB(255, 33, 77, 29),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchQuestions(request),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Text(
                        'Belum ada pertanyaan pada forum.',
                        style:
                            TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  questions = snapshot.data!;
                  return ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (_, index) => GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            padding: const EdgeInsets.all(12.0),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (questions[index].fields.drugAsked != "")
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          baseUrl + questions[index].fields.drugAsked,
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              height: 80,
                                              width: 80,
                                              color: Colors.grey[300],
                                              child: const Center(
                                                child: Text('No Image'),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        questions[index].fields.questionTitle,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    questions[index].fields.question,
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                handleLike(request,
                                                    questions[index], userId);
                                              },
                                              icon: Icon(
                                                questions[index]
                                                        .fields
                                                        .likes
                                                        .contains(userId)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.red,
                                              ),
                                              iconSize: 24,
                                            ),
                                            Text(
                                                "${questions[index].fields.numLikes}"),
                                          ],
                                        ),
                                        const SizedBox(width: 12),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AnswersPage(
                                                      question:
                                                          questions[index],
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(Icons.comment),
                                              iconSize: 24,
                                            ),
                                            Text(
                                                "${questions[index].fields.numAnswer}"),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // Delete button
                                    IconButton(
                                      onPressed: () {
                                        // Show confirmation dialog
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Delete Question'),
                                              content: const Text(
                                                  'Are you sure you want to delete this question?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    handleDelete(request,
                                                        questions[index]);
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.delete),
                                      iconSize: 24,
                                    ),
                                  ],
                                ),
                                if (index == questions.length-1)
                                  const SizedBox(height: 80),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF254922),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QuestionFormPage(),
              ),
            );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
