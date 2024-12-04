import 'package:flutter/material.dart';
import 'package:sobat_mobile/daftar_favorite/screens/daftar_favorite.dart';
import 'package:sobat_mobile/daftar_favorite/widgets/list_product.dart';
import 'package:sobat_mobile/widgets/left_drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.medication_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.store),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
      drawer: LeftDrawer(),
      body: Center(
        child: Text('Hello, world!'),
      ),
    );
  }
}
