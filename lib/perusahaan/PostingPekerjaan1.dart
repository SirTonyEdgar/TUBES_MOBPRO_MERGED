import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PostingPekerjaan2.dart'; // Halaman berikutnya

class PostingPekerjaanStep1 extends StatefulWidget {
  @override
  _PostingPekerjaanStep1State createState() => _PostingPekerjaanStep1State();
}

class _PostingPekerjaanStep1State extends State<PostingPekerjaanStep1> {
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController otherCategoryController = TextEditingController();
  final TextEditingController minSalaryController = TextEditingController();
  final TextEditingController maxSalaryController = TextEditingController();

  String? selectedCategory; // Kategori pekerjaan
  String? employmentType; // Kategori Gaji (Purnawaktu/Paruhwaktu)
  String? paymentType; // Jenis Gaji (per jam, per bulan)

  @override
  void initState() {
    super.initState();
    // Tambahkan listener untuk memantau perubahan input kategori lain
    otherCategoryController.addListener(() {
      if (selectedCategory == "other") {
        setState(() {}); // Perbarui UI jika ada perubahan
      }
    });
  }

  // Simpan data ke SharedPreferences
  Future<void> saveDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('judulPekerjaan', jobTitleController.text);
    await prefs.setString('lokasiPekerjaan', locationController.text);
    await prefs.setString(
      'kategoriJabatan',
      selectedCategory == "other"
          ? otherCategoryController.text
          : selectedCategory ?? '',
    );
    await prefs.setString('kategoriGaji', employmentType ?? '');
    await prefs.setString('jenisGaji', paymentType ?? '');
    await prefs.setString(
      'kisaranGaji',
      "${minSalaryController.text} - ${maxSalaryController.text}",
    );

    // Tambahkan log untuk memeriksa data
    print("Data yang disimpan ke SharedPreferences:");
    print("Judul Pekerjaan: ${prefs.getString('judulPekerjaan')}");
    print("Lokasi Pekerjaan: ${prefs.getString('lokasiPekerjaan')}");
    print("Kategori Jabatan: ${prefs.getString('kategoriJabatan')}");
    print("Kategori Gaji: ${prefs.getString('kategoriGaji')}");
    print("Jenis Gaji: ${prefs.getString('jenisGaji')}");
    print("Kisaran Gaji: ${prefs.getString('kisaranGaji')}");
  }

  // Validasi input sebelum menyimpan data
  bool validateInput() {
    if (jobTitleController.text.isEmpty ||
        locationController.text.isEmpty ||
        selectedCategory == null ||
        (selectedCategory == "other" && otherCategoryController.text.isEmpty) ||
        employmentType == null ||
        paymentType == null ||
        minSalaryController.text.isEmpty ||
        maxSalaryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Semua field harus diisi!")),
      );
      return false;
    }

    // Validasi format angka untuk gaji
    if (int.tryParse(minSalaryController.text) == null ||
        int.tryParse(maxSalaryController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gaji harus berupa angka!")),
      );
      return false;
    }

    // Validasi nilai minimum tidak lebih besar dari maksimum
    if (int.parse(minSalaryController.text) >
        int.parse(maxSalaryController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Gaji minimum tidak boleh lebih besar dari maksimum!")),
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
              "Klasifikasikan Peran Anda",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 16),

            // Informasi Pribadi
            TextField(
              controller: jobTitleController,
              decoration: InputDecoration(
                labelText: "Judul Pekerjaan",
                hintText:
                    "Masukkan jabatan sederhana (misalnya Asisten Penjualan)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: "Lokasi",
                hintText: "Masukkan pinggiran kota, kota atau wilayah",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Kategori
            Text(
              "Kategori",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile<String>(
                  value: "Administrasi dan Dukungan Perkantoran",
                  groupValue: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  title: Text("Administrasi dan Dukungan Perkantoran"),
                ),
                RadioListTile<String>(
                  value: "Ritel dan Produk Konsumen",
                  groupValue: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  title: Text("Ritel dan Produk Konsumen"),
                ),
                RadioListTile<String>(
                  value: "Penjualan",
                  groupValue: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  title: Text("Penjualan"),
                ),
                RadioListTile<String>(
                  value: "other",
                  groupValue: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  title: Text("Kategori Lain"),
                ),
                if (selectedCategory == "other")
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: otherCategoryController,
                      decoration: InputDecoration(
                        labelText: "Masukkan kategori lain",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16),

            // Detail Pembayaran
            Text(
              "Detail Pembayaran",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile<String>(
                  value: "Purnawaktu",
                  groupValue: employmentType,
                  onChanged: (value) {
                    setState(() {
                      employmentType = value!;
                    });
                  },
                  title: Text("Purnawaktu"),
                ),
                RadioListTile<String>(
                  value: "Paruhwaktu",
                  groupValue: employmentType,
                  onChanged: (value) {
                    setState(() {
                      employmentType = value!;
                    });
                  },
                  title: Text("Paruhwaktu"),
                ),
              ],
            ),
            SizedBox(height: 16),

            Text(
              "Jenis Gaji",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Column(
              children: [
                RadioListTile<String>(
                  value: "Per Jam",
                  groupValue: paymentType,
                  onChanged: (value) {
                    setState(() {
                      paymentType = value!;
                    });
                  },
                  title: Text("Per Jam"),
                ),
                RadioListTile<String>(
                  value: "Per Bulan",
                  groupValue: paymentType,
                  onChanged: (value) {
                    setState(() {
                      paymentType = value!;
                    });
                  },
                  title: Text("Per Bulan"),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Kisaran Gaji
            Text("Kisaran Gaji"),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minSalaryController,
                    decoration: InputDecoration(
                      labelText: "Mulai",
                      prefixText: "IDR ",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: maxSalaryController,
                    decoration: InputDecoration(
                      labelText: "Hingga",
                      prefixText: "IDR ",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  if (validateInput()) {
                    await saveDataToSharedPreferences();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostingPekerjaanStep2()),
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
}
