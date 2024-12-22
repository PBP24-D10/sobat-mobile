import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sobat_mobile/daftar_favorite/screens/daftar_favorite.dart';
import 'package:sobat_mobile/daftar_favorite/widgets/list_product.dart';
import 'package:sobat_mobile/widgets/bottom_navigation.dart';
import 'package:sobat_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sobat_mobile/authentication/login.dart';
import 'package:sobat_mobile/widgets/shop_container.dart';
import 'package:sobat_mobile/widgets/tagline.dart';
import 'package:sobat_mobile/widgets/widget_custom.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<Icon> bottomNavItems = [
  Icon(Icons.home),
  Icon(Icons.medication_outlined),
  Icon(Icons.store),
];

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    String role = request.jsonData['role'];
    String username = request.jsonData['username'];

    return Scaffold(
      bottomNavigationBar: bottomNavigationBar(request: request),
      appBar: AppBar(
        title: const Wrap(
          spacing: 10, // Menambahkan jarak antar ikon
          alignment: WrapAlignment.center,
          children: [
            // IconButton(
            //   icon: Icon(Icons.logout),
            // onPressed: () async {
            //   final response = await request
            //       .logout("http://127.0.0.1:8000/logout_mobile/");
            //   String message = response["message"];
            //   if (context.mounted) {
            //     if (response['status']) {
            //       String uname = response["username"];
            //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //         content: Text("$message Sampai jumpa, $uname."),
            //       ));
            //       Navigator.pushReplacement(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const LoginPage()),
            //       );
            //     } else {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(
            //           content: Text(message),
            //         ),
            //       );
            //     }
            //   }
            // },
            // ),
          ],
        ),
      ),
      drawer: LeftDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Hey",
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    username,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Discover the best medicines and herbal \nremedies for your health",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  )
                ],
              ),
              // SizedBox(
              //   height: 100,
              //   child: ListView(
              //     shrinkWrap: true,
              //     scrollDirection: Axis.horizontal,
              //     children: [
              //       cart(),
              //       cart(),
              //       cart(),
              //       cart(),
              //       cart(),
              //       cart(),
              //       cart(),
              //       cart(),
              //       cart(),
              //     ],
              //   ),
              // ),
              Center(
                child: Text(
                  "Our Product",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[300],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Image(
                          image: AssetImage('assets/modern.png'),
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: 90,
                        ),
                      ),
                      Expanded(
                        child: Image(
                          image: AssetImage('assets/traditional.png'),
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: 90,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // tagline(),
              SizedBox(
                height: 20,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [WidgetCustom(), WidgetCustom()],
              // )
            ],
          ),
        ),
      ),
      // body:
      // SingleChildScrollView(child:
      // Center(
      //   child: role == 'apoteker'
      //       ? const Text(
      //           'Welcome, Apoteker!',
      //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      //         )
      //       : const Text(
      //           'Welcome, Pengguna!',
      //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      //         ),
      // ),
      // ),
    );
  }
}
