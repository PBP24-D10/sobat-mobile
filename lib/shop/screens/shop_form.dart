import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sobat_mobile/shop/screens/shop_main_page.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ShopFormPage extends StatefulWidget {
  const ShopFormPage({super.key});

  @override
  State<ShopFormPage> createState() => _ShopFormPageState();
}

class _ShopFormPageState extends State<ShopFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _openingTimeController = TextEditingController();
  final TextEditingController _closingTimeController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
    super.dispose();
  }

  // Time picker
  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  // Image picker
  Future<void> _selectImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  // Convert time format to "HH:MM"
  String formatTime(String time) {
    final DateTime parsedTime = DateFormat.jm().parse(time);
    return DateFormat('HH:mm').format(parsedTime);
  }

  // Convert image to base64
  String? _imageToBase64(File? image) {
    if (image == null) return null;
    final bytes = image.readAsBytesSync();
    return 'data:image/${image.path.split('.').last};base64,${base64Encode(bytes)}';
  }

  Future<void> _submitForm(CookieRequest request) async {
    if (!_formKey.currentState!.validate()) return;

    final shopData = {
      'name': _nameController.text,
      'address': _addressController.text,
      'opening_time': formatTime(_openingTimeController.text),
      'closing_time': formatTime(_closingTimeController.text),
      'profile_image': _imageToBase64(_selectedImage),
    };

    try {
      final response = await request.post(
        'http://127.0.0.1:8000/shop/create_shop_flutter/',
        shopData,
      );

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Shop "${_nameController.text}" created successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ShopMainPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create shop: ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Shop'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Shop Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Shop Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a shop name' : null,
              ),
              const SizedBox(height: 15),

              // Address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Shop Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a shop address' : null,
              ),
              const SizedBox(height: 15),

              // Profile Image
              GestureDetector(
                onTap: _selectImage,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.image),
                      const SizedBox(width: 8),
                      Text(_selectedImage == null
                          ? 'Select Profile Image'
                          : 'Image Selected'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Opening Time
              TextFormField(
                controller: _openingTimeController,
                decoration: const InputDecoration(
                  labelText: 'Opening Time',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectTime(context, _openingTimeController),
              ),
              const SizedBox(height: 15),

              // Closing Time
              TextFormField(
                controller: _closingTimeController,
                decoration: const InputDecoration(
                  labelText: 'Closing Time',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectTime(context, _closingTimeController),
              ),
              const SizedBox(height: 25),

              // Submit Button
              ElevatedButton(
                onPressed: () => _submitForm(request),
                child: const Text('Add Shop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


extension CookieRequestExtension on CookieRequest {
  Future<Map<String, dynamic>> postWithFiles(
    String url,
    Map<String, dynamic> data, {
    required Map<String, File> files,
  }) async {
    final uri = Uri.parse(url);
    final request = http.MultipartRequest('POST', uri);

    // Add data to body
    data.forEach((key, value) {
      if (value is Map) {
        value.forEach((subKey, subValue) {
          request.fields['$key[$subKey]'] = subValue.toString();
        });
      } else {
        request.fields[key] = value.toString();
      }
    });

    // Add files to request
    files.forEach((key, file) {
      request.files.add(http.MultipartFile(
        key,
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: file.path.split('/').last,
      ));
    });

    // Add header for cookie authentication
    request.headers.addAll(headers);

    // Send request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return response.statusCode == 200
        ? Map<String, dynamic>.from(json.decode(response.body))
        : {
            'status': 'error',
            'message': 'Failed with status code ${response.statusCode}',
          };
  }
}
