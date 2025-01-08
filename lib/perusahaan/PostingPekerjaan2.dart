import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PostingPekerjaan3.dart';

class PostingPekerjaanStep2 extends StatefulWidget {
  @override
  _PostingPekerjaanStep2State createState() => _PostingPekerjaanStep2State();
}

class _PostingPekerjaanStep2State extends State<PostingPekerjaanStep2> {
  String? selectedPackage; // Menyimpan paket yang dipilih
  String? idPerusahaan; // Menyimpan ID perusahaan dari SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadIdPerusahaan(); // Panggil fungsi untuk memuat ID perusahaan
  }

  // Fungsi untuk mengambil ID perusahaan dari SharedPreferences
  Future<void> _loadIdPerusahaan() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      idPerusahaan = prefs.getString('idPerusahaan');
    });

    if (idPerusahaan == null) {
      print("ID Perusahaan tidak ditemukan!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ID Perusahaan tidak ditemukan!")),
      );
    } else {
      print("ID Perusahaan ditemukan: $idPerusahaan");
    }
  }

  // Fungsi untuk menyimpan paket yang dipilih ke SharedPreferences
  Future<void> _saveSelectedPackage() async {
    if (idPerusahaan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ID Perusahaan tidak ditemukan!")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedPackage', selectedPackage!);
    print("Paket yang dipilih disimpan: $selectedPackage");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posting Pekerjaan"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Jenis Iklan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 16),

            // Paket Basic
            buildPackageCard(
              context,
              title: "Basic",
              price: "Rp. 0",
              description: [
                "Tampilkan kandidat terbaik dengan Basic Ad",
                "Pemasangan iklan selama 30 hari",
                "Iklan dengan visibilitas lebih tinggi ke kandidat",
                "Dapatkan kandidat secara cepat",
              ],
            ),

            // Paket Premium
            buildPackageCard(
              context,
              title: "Premium",
              price: "Rp. 1.240.000",
              description: [
                "Tampilkan kandidat terbaik dan cepat dengan pemasangan iklan berprioritas",
                "Pemasangan iklan selama 30 hari",
                "Tambahkan gambar perusahaan untuk memperkenalkan brand perusahaan Anda",
              ],
            ),

            // Paket Premium Plus
            buildPackageCard(
              context,
              title: "Premium Plus",
              price: "Rp. 2.850.000",
              description: [
                "Tampilkan kandidat terbaik dan cepat dengan pemasangan iklan berprioritas",
                "Pemasangan iklan selama 30 hari",
                "Tambahkan gambar perusahaan untuk memperkenalkan brand perusahaan Anda",
                "Account manager berdedikasi untuk Anda",
              ],
            ),

            SizedBox(height: 24),

            // Tombol Berikutnya
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedPackage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text("Silakan pilih paket terlebih dahulu!")),
                    );
                  } else {
                    await _saveSelectedPackage(); // Simpan paket yang dipilih
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostingPekerjaanStep3()),
                    );
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Berikutnya"),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPackageCard(
    BuildContext context, {
    required String title,
    required String price,
    required List<String> description,
  }) {
    final isSelected = selectedPackage == title; // Cek apakah paket dipilih
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPackage = title; // Set paket yang dipilih
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Paket dan Harga
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isSelected ? Colors.blue : Colors.black,
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isSelected ? Colors.blue : Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Deskripsi Paket
            ...description.map((desc) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    desc,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                )),

            SizedBox(height: 12),

            // Tombol Pilih/Dipilih
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedPackage = title; // Set paket yang dipilih
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isSelected ? Colors.blue : Colors.grey.shade300,
                ),
                child: Text(
                  isSelected ? "Dipilih" : "Pilih",
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
