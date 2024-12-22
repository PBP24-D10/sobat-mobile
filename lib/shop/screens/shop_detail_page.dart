// screens/shop_detail_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sobat_mobile/shop/models/shop_model.dart';
import 'package:sobat_mobile/drug/models/drug_entry.dart';
import 'package:sobat_mobile/shop/screens/shop_form.dart';
import 'package:sobat_mobile/shop/widgets/drug_card.dart';
import 'package:sobat_mobile/shop/screens/shop_profile_edit.dart';

class ShopDetailPage extends StatefulWidget {
  final ShopEntry shop;

  const ShopDetailPage({super.key, required this.shop});

  @override
  _ShopDetailPageState createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  static const String baseUrl = 'http://localhost:8000';
  List<DrugModel>? _drugs;
  List<DrugModel> _filteredDrugs = [];
  bool _isLoading = true;
  String _error = '';
  bool _isOwner = false;

  @override
  void initState() {
    super.initState();
    _loadDrugs();
    _checkOwnership();
  }

  Future<void> _checkOwnership() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final flutterUserId = prefs.getInt('user_id') ?? -1; // Gunakan nilai default -1 jika null

      setState(() {
        _isOwner = flutterUserId != -1 && flutterUserId == widget.shop.fields.owner;
      });

    } catch (e) {
      setState(() {
        _isOwner = false;
      });
      print('Error fetching user ID: $e');
    }
  }

  void _navigateToEditProfile() async {
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShopEditPage(shop: widget.shop),
          ),
      );

      if (result != null && result is Map<String, dynamic>) {
          // Update the shop data in the state
          setState(() {
              widget.shop.fields.name = result['name'];
              widget.shop.fields.address = result['address'];
              widget.shop.fields.openingTime = result['opening_time'];
              widget.shop.fields.closingTime = result['closing_time'];
              widget.shop.fields.profileImage = result['profile_image'];
          });
          
          // Refresh the page
          if (mounted) {
              setState(() {});
          }
      }
  }

  void _navigateToManageProducts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopManageProductsPage(shop: widget.shop),
      ),
    );
  }

  Future<void> _loadDrugs() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/product/json/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('application/json') ?? false) {
          final List<DrugModel> drugs = welcomeFromJson(response.body);
          setState(() {
            _drugs = drugs;
            _filteredDrugs = drugs
                .where((drug) => drug.fields.shops.contains(widget.shop.pk))
                .toList();
            _isLoading = false;
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading products: $e');
      setState(() {
        _filteredDrugs = [];
        _isLoading = false;
        _error = 'Failed to load products. Please try again later.';
      });
    }
  }

  void _searchDrug(String query) {
    if (_drugs == null) return;

    setState(() {
      if (query.isEmpty) {
        _filteredDrugs = _drugs!;
      } else {
        _filteredDrugs = _drugs!.where((drug) {
          return drug.fields.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Widget _buildOwnerActions() {
    if (!_isOwner) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _navigateToEditProfile,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _navigateToManageProducts,
              icon: const Icon(Icons.inventory),
              label: const Text('Manage Products'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.shop.fields.name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadDrugs,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShopDetails(),
              _buildOwnerActions(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  onChanged: _searchDrug,
                  decoration: InputDecoration(
                    hintText: 'Search for a product...',
                    prefixIcon: Icon(Icons.search,
                        color: Theme.of(context).colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              _error.isNotEmpty
                  ? _buildErrorWidget()
                  : _isLoading
                      ? _buildLoadingWidget()
                      : _buildDrugList(),
            ],
          ),
        ),
      ),
      floatingActionButton: _isOwner
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopFormPage()),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _error,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDrugs,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading products...'),
          ],
        ),
      ),
    );
  }

  Widget _buildShopDetails() {
    return Column(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
          child: widget.shop.fields.profileImage.isNotEmpty
              ? Image.network(
                  widget.shop.fields.profileImage.startsWith('http')
                      ? widget.shop.fields.profileImage
                      : '$baseUrl${widget.shop.fields.profileImage}',
                  fit: BoxFit.cover,
                  headers: const {
                    'Access-Control-Allow-Origin': '*',
                  },
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading shop image: $error');
                    return Center(
                      child: Icon(
                        Icons.storefront,
                        size: 100,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                )
              : Center(
                  child: Icon(
                    Icons.storefront,
                    size: 100,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.shop.fields.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              DetailRow(
                icon: Icons.location_on,
                title: 'Address',
                content: widget.shop.fields.address,
              ),
              const SizedBox(height: 10),
              DetailRow(
                icon: Icons.access_time,
                title: 'Operating Hours',
                content:
                    '${widget.shop.fields.openingTime} - ${widget.shop.fields.closingTime}',
              ),
              const SizedBox(height: 10),
              DetailRow(
                icon: Icons.info_outline,
                title: 'Established',
                content: widget.shop.fields.createdAt.toLocal().toString().split(' ')[0],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDrugList() {
    if (_filteredDrugs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.medication_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                "No products available in this shop.",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _filteredDrugs.length,
        itemBuilder: (context, index) {
          final drug = _filteredDrugs[index];
          return DrugCard(drug: drug);
        },
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const DetailRow({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                content,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ShopManageProductsPage extends StatelessWidget {
  final ShopEntry shop;

  const ShopManageProductsPage({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Products')),
      body: const Center(child: Text('Manage Products Page - Coming Soon')),
    );
  }
}