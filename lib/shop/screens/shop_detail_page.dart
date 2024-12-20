// shop/screens/shop_detail_page

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
  List<DrugModel> _drugs = [];
  List<DrugModel> _filteredDrugs = [];

  @override
  void initState() {
    super.initState();
    _loadDrugs();
  }

  Future<void> _loadDrugs() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/product/json/'), // Update URL ke yang benar
      );

      if (response.statusCode == 200) {
        final List<DrugModel> drugs = welcomeFromJson(response.body);

        // Filter produk berdasarkan UUID toko
        final filteredDrugs = drugs.where((drug) {
          return drug.fields.shops.contains(widget.shop.pk);
        }).toList();

        setState(() {
          _drugs = filteredDrugs;
          _filteredDrugs = filteredDrugs;
        });

        print('Drugs loaded for shop ${widget.shop.pk}: ${filteredDrugs.length}');
      } else {
        throw Exception('Failed to load drugs');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _drugs = [];
        _filteredDrugs = [];
      });
    }
  }

  void _searchDrug(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDrugs = _drugs;
      } else {
        _filteredDrugs = _drugs.where((drug) {
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
      ),
      body: SingleChildScrollView(
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
                ),
              ),
            ),
            _buildDrugList(),
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
            image: widget.shop.fields.profileImage.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(widget.shop.fields.profileImage),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: widget.shop.fields.profileImage.isEmpty
              ? Center(
                  child: Icon(
                    Icons.storefront,
                    size: 100,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : null,
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
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: Text("No products available in this shop.")),
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
