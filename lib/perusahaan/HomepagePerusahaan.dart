import 'package:flutter/material.dart';
import 'PengaturanPerusahaan.dart';
import 'ProfilPerusahaan.dart';
import 'PostingPekerjaan1.dart';
import 'PekerjaanPerusahaan.dart';
import 'NotifikasiPerusahaan.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      home: CustomNavigationBar(),
    );
  }
}

class CustomNavigationBar extends StatefulWidget {
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<CustomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomepagePerusahaan(),
    PekerjaanPage(),
    PostingPekerjaanStep1(),
    NotifikasiPage(),
    PengaturanPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Pekerjaan'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Tambah'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifikasi'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }
}

class HomepagePerusahaan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workers Union",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Cari Perusahaan",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              ),
            ),
            SizedBox(height: 20),

            // Section Perusahaan Unggulan
            Text(
              "Perusahaan Unggulan",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),

            // GestureDetector untuk membuka halaman profil perusahaan
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompanyProfilePage()),
                );
              },
              child: FeaturedCompanyCard(
                logo: "assets/bca.png",
                name: "BCA",
                description:
                    "Bahagia menjadi bagian dari PT Bank Central Asia Tbk.",
                rating: 4.8,
                reviews: 59,
              ),
            ),
            SizedBox(height: 20),

            // Section Rekomendasi Perusahaan
            Text(
              "Disarankan",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            CompanyRecommendationCard(
              logo: "assets/mandiri.png", // Ganti dengan logo lain jika ada
              name: "Mandiri",
              description:
                  "Bank Mandiri bertekad menjadi institusi keuangan terbaik di ASEAN.",
              rating: 4.8,
              reviews: 59,
            ),
            SizedBox(height: 10),
            CompanyRecommendationCard(
              logo: "assets/indomaret.png", // Ganti dengan logo lain jika ada
              name: "Indomaret",
              description:
                  "Indomaret adalah jaringan minimarket yang menyediakan kebutuhan sehari-hari.",
              rating: 4.7,
              reviews: 59,
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturedCompanyCard extends StatelessWidget {
  final String logo;
  final String name;
  final String description;
  final double rating;
  final int reviews;

  FeaturedCompanyCard({
    required this.logo,
    required this.name,
    required this.description,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Image.asset(logo, width: 40, height: 40),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(description,
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      SizedBox(width: 4),
                      Text("$rating (${reviews})",
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompanyRecommendationCard extends StatelessWidget {
  final String logo;
  final String name;
  final String description;
  final double rating;
  final int reviews;

  CompanyRecommendationCard({
    required this.logo,
    required this.name,
    required this.description,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Image.asset(logo, width: 40, height: 40),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(description,
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      SizedBox(width: 4),
                      Text("$rating (${reviews})",
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
