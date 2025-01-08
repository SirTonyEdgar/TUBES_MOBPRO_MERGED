import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Colors.blue,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 14),
          bodyMedium: TextStyle(fontSize: 14),
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      home: CompanyProfilePage(),
    );
  }
}

class CompanyProfilePage extends StatelessWidget {
  const CompanyProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          title: const Text(
            'Profil Perusahaan',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 150,
              child: Image.asset(
                'assets/logoperusahaan.png',
                fit: BoxFit.contain,
                width: 400,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bank Central Asia',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.green, size: 16),
                      Icon(Icons.star, color: Colors.green, size: 16),
                      Icon(Icons.star, color: Colors.green, size: 16),
                      Icon(Icons.star, color: Colors.green, size: 16),
                      Icon(Icons.star_half, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Text('4.7 total rating from 1277 reviews',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            // Tab Bar
            const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: 'Tentang'),
                Tab(text: 'Kehidupan & Budaya'),
                Tab(text: 'Pekerjaan'),
              ],
            ),
            // Tab Views
            Expanded(
              child: TabBarView(
                children: [
                  // Tentang Tab
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: const [
                        Text(
                          'Overview Perusahaan',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Website: http://karir.bca.co.id\n'
                          'Industri: Perbankan & Jasa Keuangan\n'
                          'Ukuran Perusahaan: Lebih dari 10.000 karyawan\n',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Kami mengimbau agar Anda berhati-hati saat melamar pekerjaan dengan selalu memastikan iklan lowongan tersebut sesuai dengan profil perusahaannya.',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Waspadalah jika Anda menemukan hal-hal di bawah ini:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '- PT Bank Central Asia Tbk tidak pernah memungut biaya apapun dalam proses rekrutmen.\n'
                          '- PT Bank Central Asia Tbk tidak pernah bekerja sama dengan travel agent / biro perjalanan tertentu dalam proses rekrutmen.\n\n'
                          'Apabila Anda diminta untuk membayar sejumlah uang dalam bentuk pembayaran tiket pesawat dan hotel atau akomodasi lainnya agar diabaikan.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  // Kehidupan & Budaya Tab
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: const [
                        Text(
                          'Kenapa Bergabung dengan Kami',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'BCA sangat menghargai sumber daya manusia yang ada sebagai aset dan modal utama yang mendukung keberhasilan perusahaan dalam mencapai pertumbuhan bisnis yang berkelanjutan. Kami percaya bahwa kompetensi BCA merupakan kunci untuk memberikan layanan terbaik bagi pelanggan.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  // Pekerjaan Tab
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.work_outline,
                              size: 64, color: Colors.blue),
                          const SizedBox(height: 16),
                          const Text(
                            'Bank Central Asia tidak memiliki pekerjaan aktif saat ini. Silakan gunakan Pencarian Kerja kami untuk mencari lowongan yang terbuka.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
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
