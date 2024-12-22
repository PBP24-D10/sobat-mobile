import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';  // For handling image bytes
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
  XFile? _selectedImage;
  Uint8List? _imageBytes;  // To store image bytes

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
    super.dispose();
  }

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

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final Uint8List imageBytes = await pickedImage.readAsBytes();
      setState(() {
        _selectedImage = pickedImage;
        _imageBytes = imageBytes;
      });
    }
  }

  String formatTime(String time) {
    final DateTime parsedTime = DateFormat.jm().parse(time);
    return DateFormat('HH:mm').format(parsedTime);
  }

  String? _imageToBase64() {
    if (_imageBytes != null) {
      return 'data:image/png;base64,${base64Encode(_imageBytes!)}';
    }
    return null;
  }

  Future<void> _submitForm(CookieRequest request) async {
    if (!_formKey.currentState!.validate()) return;

    final shopData = {
      'name': _nameController.text,
      'address': _addressController.text,
      'opening_time': formatTime(_openingTimeController.text),
      'closing_time': formatTime(_closingTimeController.text),
      'profile_image': _imageToBase64(),
    };

    try {
      final response = await request.post(
        'http://m-arvin-sobat.pbp.cs.ui.ac.id/shop/create_shop_flutter/',
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

  Widget buildImagePreview() {
    if (_imageBytes != null) {
      return Image.memory(
        _imageBytes!,
        height: 100,
      );
    } else {
      return const Text('No image selected');
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
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Shop Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a shop name' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Shop Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a shop address' : null,
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: _selectImage,
                child: Column(
                  children: [
                    Container(
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
                          const Text('Select Profile Image'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildImagePreview(),
                  ],
                ),
              ),
              const SizedBox(height: 15),
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
