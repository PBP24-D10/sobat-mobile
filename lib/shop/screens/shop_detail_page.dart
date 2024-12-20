import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sobat_mobile/shop/models/shop_model.dart';
import 'package:sobat_mobile/drug/models/drug_entry.dart';
import 'package:sobat_mobile/shop/widgets/drug_card.dart';

class ShopDetailPage extends StatefulWidget {
  final ShopEntry shop;

  const ShopDetailPage({super.key, required this.shop});

  @override
  _ShopDetailPageState createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  static const String baseUrl = 'http://localhost:8000'; // Update with your actual base URL
  List<DrugModel>? _drugs; // Changed to nullable to handle loading state
  List<DrugModel> _filteredDrugs = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadDrugs();
  }

  Future<void> _loadDrugs() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/product/json/'),
      );

      if (response.statusCode == 200) {
        final List<DrugModel> drugs = welcomeFromJson(response.body);

        // Filter products based on shop UUID
        final filteredDrugs = drugs.where((drug) {
          return drug.fields.shops.contains(widget.shop.pk);
        }).toList();

        setState(() {
          _drugs = filteredDrugs;
          _filteredDrugs = filteredDrugs;
          _isLoading = false;
        });

      } else {
        throw Exception('Failed to load drugs: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _drugs = [];
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
                      borderSide:
                          BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
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

  // In ShopDetailPage, modify _buildShopDetails():
  Widget _buildShopDetails() {
    // Print the image URL for debugging
    print('Shop Image URL: ${widget.shop.fields.profileImage.startsWith('http') 
      ? widget.shop.fields.profileImage 
      : '$baseUrl${widget.shop.fields.profileImage}'}');
    
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
                    // Add headers if needed for CORS
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