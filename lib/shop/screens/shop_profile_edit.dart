import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';  // For handling image bytes on all platforms
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sobat_mobile/shop/models/shop_model.dart';
import 'package:intl/intl.dart';

class ShopEditPage extends StatefulWidget {
  final ShopEntry shop;

  const ShopEditPage({super.key, required this.shop});

  @override
  State<ShopEditPage> createState() => _ShopEditPageState();
}

class _ShopEditPageState extends State<ShopEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _openingTimeController;
  late TextEditingController _closingTimeController;
  XFile? _selectedImage;
  Uint8List? _imageBytes; // For storing the selected image bytes
  String? _currentImageUrl;
  static const String baseUrl = 'http://m-arvin-sobat.pbp.cs.ui.ac.id';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.shop.fields.name);
    _addressController = TextEditingController(text: widget.shop.fields.address);
    _openingTimeController = TextEditingController(text: widget.shop.fields.openingTime);
    _closingTimeController = TextEditingController(text: widget.shop.fields.closingTime);
    _currentImageUrl = widget.shop.fields.profileImage;
  }

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
        _currentImageUrl = null;  // Clear the current image URL to show the new one
      });
    }
  }

  String? _imageToBase64() {
    if (_imageBytes != null) {
      return 'data:image/png;base64,${base64Encode(_imageBytes!)}';
    }
    return null;
  }

  String formatTime(String time) {
    try {
      final DateTime parsedTime = DateFormat.jm().parse(time);
      return DateFormat('HH:mm').format(parsedTime);
    } catch (e) {
      print('Error parsing time: $time, Error: $e');
      return time;
    }
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
        '$baseUrl/shop/edit_shop_flutter/${widget.shop.pk}/',
        shopData,
      );

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Shop updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update shop: ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildImagePreview() {
    if (_imageBytes != null) {
      return Image.memory(_imageBytes!, height: 200, fit: BoxFit.cover);
    } else if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty) {
      return Image.network(
        _currentImageUrl!.startsWith('http') ? _currentImageUrl! : '$baseUrl$_currentImageUrl',
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(child: Text('Error loading image')),
      );
    }
    return const Text('No image selected');
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Shop Profile'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePreview(),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: _selectImage,
                icon: const Icon(Icons.image),
                label: const Text('Change Profile Image'),
              ),
              const SizedBox(height: 20),
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
              TextFormField(
                controller: _openingTimeController,
                decoration: const InputDecoration(
                  labelText: 'Opening Time',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectTime(context, _openingTimeController),
                validator: (value) =>
                    value!.isEmpty ? 'Please select opening time' : null,
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
                validator: (value) =>
                    value!.isEmpty ? 'Please select closing time' : null,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => _submitForm(request),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
