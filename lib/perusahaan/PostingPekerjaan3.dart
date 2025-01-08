import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PostingPekerjaan4.dart';

class PostingPekerjaanStep3 extends StatefulWidget {
  @override
  _PostingPekerjaanStep3State createState() => _PostingPekerjaanStep3State();
}

class _PostingPekerjaanStep3State extends State<PostingPekerjaanStep3> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController videoLinkController = TextEditingController();

  // Fungsi untuk menyimpan data ke SharedPreferences
  Future<void> saveDataToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('deskripsiPekerjaan', descriptionController.text);
    await prefs.setString('linkReferensi', videoLinkController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Data berhasil disimpan!")),
    );
  }

  // Fungsi untuk validasi input
  bool validateInput() {
    if (descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Deskripsi pekerjaan harus diisi!")),
      );
      return false;
    }
    return true;
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
              "Tulis info lowongan kerja Anda",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Deskripsi Pekerjaan
            Text(
              "Deskripsi Pekerjaan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Masukkan detail pekerjaan atau dapatkan panduan tentang apa saja yang harus ditulis.",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Masukkan deskripsi pekerjaan",
              ),
            ),
            SizedBox(height: 16),

            // Video (Opsional)
            Text(
              "Video (Opsional)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Tambahkan video ke iklan Anda dengan link YouTube. Video ini akan muncul di bagian bawah iklan.",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            TextField(
              controller: videoLinkController,
              decoration: InputDecoration(
                labelText: "Masukkan link video YouTube",
                hintText: "Misalnya: https://www.youtube.com/watch?v=abc123",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),

            // Tombol Berikutnya
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (validateInput()) {
                    saveDataToSharedPreferences().then((_) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostingPekerjaanStep4()),
                      );
                    });
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
}
