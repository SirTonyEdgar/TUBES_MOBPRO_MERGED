import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomepagePerusahaan.dart';

class PostingPekerjaanStep5 extends StatelessWidget {
  // Fungsi untuk membersihkan data SharedPreferences
  Future<void> clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Hapus hanya data yang terkait dengan PostingPekerjaan
    await prefs.remove('judulPekerjaan');
    await prefs.remove('lokasiPekerjaan');
    await prefs.remove('kategoriJabatan');
    await prefs.remove('kategoriGaji');
    await prefs.remove('jenisGaji');
    await prefs.remove('kisaranGaji');
    await prefs.remove('deskripsiPekerjaan');
    await prefs.remove('pertanyaan');
    await prefs.remove('linkReferensi');

    print("Data SharedPreferences untuk PostingPekerjaan telah dibersihkan.");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Mencegah kembali ke halaman sebelumnya
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Posting Pekerjaan"),
          automaticallyImplyLeading: false, // Hilangkan tombol back
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ilustrasi dan Teks
              Column(
                children: [
                  // Gambar ilustrasi
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 100,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Teks
                  Text(
                    "Lowongan kerja Anda berhasil diposting!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Terima kasih telah menggunakan layanan kami.",
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Spacer(),
              // Tombol Selesai
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () async {
                    await clearSharedPreferences(); // Hapus data PostingPekerjaan
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomNavigationBar()),
                      (route) => false,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Selesai"),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
