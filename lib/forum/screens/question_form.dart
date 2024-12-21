import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sobat_mobile/drug/models/drug_entry.dart';
import 'package:sobat_mobile/forum/screens/forum.dart';

class QuestionFormPage extends StatefulWidget {
  const QuestionFormPage({super.key});

  @override
  State<QuestionFormPage> createState() => _QuestionFormPageState();
}

class _QuestionFormPageState extends State<QuestionFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _drugAsked = "-1";
  DrugModel? _selectedDrug; // Add this line to store the selected drug
  final TextEditingController _questionTitle = TextEditingController();
  final TextEditingController _question = TextEditingController();
  final String baseUrl = 'http://127.0.0.1:8000/media/';

  Future<List<DrugModel>> fetchProductEntries(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/product/json/');

    List<DrugModel> listProduct = [];
    for (var d in response) {
      if (d != null) {
        final entry = DrugModel.fromJson(d);
        listProduct.add(entry);
      }
    }
    return listProduct;
  }

  Widget _buildSelectedDrugCard() {
    if (_selectedDrug == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                baseUrl + _selectedDrug!.fields.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedDrug!.fields.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp${_selectedDrug!.fields.price.toString()}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDrug(BuildContext context, List<DrugModel> products) {
    String searchQuery = '';
    List<DrugModel> filteredProducts = List.from(products);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text("Select a Drug"),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search drugs...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase();
                          filteredProducts = products
                              .where((drug) => drug.fields.name
                                  .toLowerCase()
                                  .contains(searchQuery))
                              .toList();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (MediaQuery.of(context).size.width ~/ 150).clamp(2, 4),
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            // Ensure the state updates to trigger a rebuild
                            this.setState(() {
                              _drugAsked = filteredProducts[index].pk.toString();
                              _selectedDrug = filteredProducts[index];
                            });
                            Navigator.of(context).pop();
                          },
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      baseUrl + filteredProducts[index].fields.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: Text('No Image'),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    filteredProducts[index].fields.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add a Question',
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<DrugModel>>(
        future: fetchProductEntries(request),
        builder: (BuildContext context, AsyncSnapshot<List<DrugModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error fetching products."));
          } else if (snapshot.hasData) {
            final products = snapshot.data!;
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSelectedDrugCard(), // Add the selected drug card
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => _selectDrug(context, products),
                        child: Text(_drugAsked.isEmpty
                            ? "Select Drug Asked"
                            : "Change Selected Drug"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _questionTitle,
                        decoration: InputDecoration(
                          hintText: "Question Title",
                          labelText: "Question Title",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Question Title cannot be empty!";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _question,
                        decoration: InputDecoration(
                          hintText: "Question",
                          labelText: "Question",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Question cannot be empty!";
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
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final response = await request.postJson(
                                "http://127.0.0.1:8000/forum/add_question_flutter/$_drugAsked/",
                                jsonEncode(<String, String>{
                                  'question_title': _questionTitle.text,
                                  'question': _question.text,
                                }),
                              );

                              if (context.mounted) {
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Question successfully added!"),
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const ForumPage()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "An error occurred, please try again."),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text("No products available."));
          }
        },
      ),
    );
  }
}
