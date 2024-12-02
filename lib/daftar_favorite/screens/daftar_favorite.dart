import 'package:flutter/material.dart';
import 'package:sobat_mobile/daftar_favorite/widgets/list_product.dart';

class daftarFavorite extends StatelessWidget {
  const daftarFavorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [productTile(), productTile()],
          )
        ],
      ),
    );
  }
}
