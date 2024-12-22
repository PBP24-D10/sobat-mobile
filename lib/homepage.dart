import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:sobat_mobile/authentication/login.dart';
import 'package:sobat_mobile/widgets/left_drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(context),
      appBar: AppBar(
        title: const Text("Sobat"),
      ),
      drawer: LeftDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 1200) {
            return _buildLargeScreenLayout(context);
          } else if (constraints.maxWidth > 600) {
            return _buildMediumScreenLayout(context);
          } else {
            return _buildSmallScreenLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(1),
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12.0,
              spreadRadius: 2.0,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4),
          child: GNav(
            tabBackgroundColor: Colors.green.shade900,
            tabBorderRadius: 30,
            iconSize: 20,
            gap: 5,
            tabs: [
              GButton(
                iconActiveColor: Colors.white,
                iconColor: Colors.black,
                icon: FontAwesomeIcons.house,
                onPressed: () {},
              ),
              GButton(
                iconActiveColor: Colors.white,
                iconColor: Colors.black,
                icon: FontAwesomeIcons.prescriptionBottleMedical,
                onPressed: () {},
              ),
              GButton(
                iconActiveColor: Colors.white,
                iconColor: Colors.black,
                icon: FontAwesomeIcons.shop,
                onPressed: () {},
              ),
              GButton(
                icon: FontAwesomeIcons.rightFromBracket,
                iconActiveColor: Colors.white,
                iconColor: Colors.black,
                onPressed: () async {
                  final response = await request.logout("https://m-arvin-sobat.pbp.cs.ui.ac.id/logout_mobile/");
                  if (context.mounted && response['status']) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallScreenLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hello!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Our Product",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green[300]),
              ),
            ),
            const SizedBox(height: 20),
            _buildProductCategories(),
            const SizedBox(height: 20),
            _buildSectionHeader("Popular Drugs"),
            _buildGrid(context, crossAxisCount: 2),
            _buildSectionHeader("Nearby Shops"),
            _buildHorizontalShopList(),
            _buildSectionHeader("Forum Discussions"),
            _buildForumList(),
            _buildSectionHeader("Your Favorites"),
            _buildGrid(context, crossAxisCount: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildMediumScreenLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSmallScreenLayout(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLargeScreenLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildGrid(context, crossAxisCount: 4),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildVerticalShopList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Image.asset('assets/modern.png', fit: BoxFit.contain, height: 90),
        ),
        Expanded(
          child: Image.asset('assets/traditional.png', fit: BoxFit.contain, height: 90),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, {required int crossAxisCount}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 8,
      itemBuilder: (_, index) => Card(
        color: Colors.white,
        child: Center(child: Text('Product $index')),
      ),
    );
  }

  Widget _buildHorizontalShopList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(8, (index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: SizedBox(width: 120, height: 100, child: Text('Shop $index')),
          );
        }),
      ),
    );
  }

  Widget _buildVerticalShopList() {
    return Column(
      children: List.generate(8, (index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(title: Text('Shop $index')),
        );
      }),
    );
  }

  Widget _buildForumList() {
    return Column(
      children: List.generate(5, (index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(title: Text('Forum Question $index')),
        );
      }),
    );
  }
}