import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'PostingPekerjaan5.dart';

class PostingPekerjaanStep4 extends StatefulWidget {
  @override
  _PostingPekerjaanStep4State createState() => _PostingPekerjaanStep4State();
}

class _PostingPekerjaanStep4State extends State<PostingPekerjaanStep4> {
  List<String> recommendedQuestions = [
    "Berapa gaji bulanan yang anda inginkan?",
    "Berapa tahun pengalaman anda sebagai Staff Administrasi?",
    "Produk Microsoft apa saja yang bisa anda gunakan?",
    "Bagaimana anda menilai kemampuan bahasa Inggris anda?",
    "Apakah anda bersedia bepergian untuk pekerjaan ini?",
    "Bahasa apa saja yang fasih anda gunakan?",
    "Apakah anda bersedia menjalani pemeriksaan latar belakang pekerja?",
  ];

  List<String> selectedQuestions = [];
  TextEditingController internalReferenceController = TextEditingController();

  // Fungsi untuk mengambil data dari SharedPreferences
  Future<Map<String, dynamic>> getDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    print("SharedPreferences Data:");
    print("ID Perusahaan: ${prefs.getString('idPerusahaan')}");
    print("Email: ${prefs.getString('email')}");
    print("Nama: ${prefs.getString('name')}");
    print("Company Name: ${prefs.getString('companyName')}");
    print("Phone: ${prefs.getString('phone')}");
    String? idPerusahaan = prefs.getString('idPerusahaan');

    if (idPerusahaan == null || idPerusahaan.isEmpty) {
      throw Exception("ID Perusahaan tidak ditemukan di SharedPreferences");
    }

    return {
      'idPerusahaan': prefs.getString('idPerusahaan') ?? '',
      'judulPekerjaan': prefs.getString('judulPekerjaan') ?? '',
      'lokasiPekerjaan': prefs.getString('lokasiPekerjaan') ?? '',
      'kategoriJabatan': prefs.getString('kategoriJabatan') ?? '',
      'kategoriGaji': prefs.getString('kategoriGaji') ?? '',
      'jenisGaji': prefs.getString('jenisGaji') ?? '',
      'kisaranGaji': prefs.getString('kisaranGaji') ?? '',
      'deskripsiPekerjaan': prefs.getString('deskripsiPekerjaan') ?? '',
      'linkReferensi': prefs.getString('linkReferensi') ?? '',
      'pertanyaan': prefs.getStringList('pertanyaan') ?? [],
    };
  }

  // Fungsi untuk mengirim data ke backend
  Future<void> sendDataToBackend() async {
    final url = "http://10.0.3.2:3000/api/uploadPekerjaan"; // URL backend

    try {
      // Ambil data dari SharedPreferences
      final data = await getDataFromSharedPreferences();
      data['pertanyaan'] = selectedQuestions;
      print("Data yang akan dikirim ke backend: $data");

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Data berhasil dikirim: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Iklan berhasil diposting!")),
        );

        // Pindah ke halaman berikutnya
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostingPekerjaanStep5()),
        );
      } else {
        print("Gagal mengirim data: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memposting iklan!")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan saat memposting iklan!")),
      );
    }
  }

  // Fungsi untuk validasi input
  bool validateInput() {
    if (selectedQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pilih minimal 1 pertanyaan!")),
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
              "Kelola lamaran kandidat (opsional)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 16),

            // Deskripsi dan jumlah pertanyaan
            Text(
              "Pertanyaan untuk kandidat",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Tambahkan hingga 8 pertanyaan yang mudah dijawab ke iklan lowongan Anda. Saat meninjau kandidat, Anda akan dapat dengan mudah menyaring kandidat yang cocok dengan jawaban pilihan Anda.",
            ),
            SizedBox(height: 16),
            Text(
              "${selectedQuestions.length}/8 pertanyaan dipilih",
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 16),

            // Rekomendasi pertanyaan
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: recommendedQuestions.length,
              itemBuilder: (context, index) {
                String question = recommendedQuestions[index];
                bool isSelected = selectedQuestions.contains(question);

                return CheckboxListTile(
                  title: Text(question),
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true && selectedQuestions.length < 8) {
                        selectedQuestions.add(question);
                      } else if (value == false) {
                        selectedQuestions.remove(question);
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                );
              },
            ),
            SizedBox(height: 16),

            // Referensi pekerjaan internal
            Text(
              "Referensi pekerjaan internal (opsional)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: internalReferenceController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Masukkan referensi pekerjaan internal",
              ),
            ),
            SizedBox(height: 32),

            // Tombol Posting Iklan Saya
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (validateInput()) {
                    sendDataToBackend();
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Posting Iklan Saya"),
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
