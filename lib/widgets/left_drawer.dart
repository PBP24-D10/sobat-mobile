import 'package:flutter/material.dart';
// import 'package:mental_health_tracker/screens/list_moodentry.dart';
// import 'package:mental_health_tracker/screens/menu.dart';
import 'package:sobat_mobile/homepage.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green[300],
            ),
            child: const Column(
              children: [
                Text(
                  'Solo Obat',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Ayo Cari Obat Terbaikmu!",
                  // TODO: Tambahkan gaya teks dengan center alignment, font ukuran 15, warna putih, dan weight biasa
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Daftar Favorite'),
            // Bagian redirection ke MoodEntryFormPage
            onTap: () {
              /*
      TODO: Buatlah routing ke MoodEntryFormPage di sini,
      setelah halaman MoodEntryFormPage sudah dibuat.
      */
            },
          ),
          ListTile(
            leading: const Icon(Icons.medication_outlined),
            title: const Text('Product'),
            onTap: () {
              // Route menu ke halaman mood
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ()),
              // );
            },
          ),
        ],
      ),
    );
  }
}
