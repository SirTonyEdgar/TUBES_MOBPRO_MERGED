import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'masuk_pr.dart';

class PengaturanPage extends StatefulWidget {
  @override
  _PengaturanPageState createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  String namaPerusahaan = "";
  String kontakUtama = "";
  bool isLoading = true;
  String? idPerusahaan;

  final String apiUrlGetData = 'http://10.0.3.2:3000/api/getDataPerusahaan';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      idPerusahaan = prefs.getString('idPerusahaan'); // Ambil ID perusahaan
      print("ID Perusahaan dari SharedPreferences: $idPerusahaan");

      if (idPerusahaan != null) {
        final response = await http.post(
          Uri.parse(apiUrlGetData),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'idPerusahaan': idPerusahaan}),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          print('Parsed Data: $data');

          setState(() {
            namaPerusahaan = data['data'][0]['namaBisnis'] ??
                "Nama perusahaan tidak ditemukan";
            kontakUtama = data['data'][0]['kontakUtama'] ??
                "Kontak utama tidak ditemukan";
          });
        } else {
          print('Gagal memuat data perusahaan: ${response.body}');
          setState(() {
            namaPerusahaan = "Nama perusahaan tidak ditemukan";
            kontakUtama = "Kontak utama tidak ditemukan";
          });
        }
      } else {
        print("ID Perusahaan tidak ditemukan di SharedPreferences");
        setState(() {
          namaPerusahaan = "Nama perusahaan tidak ditemukan";
          kontakUtama = "Kontak utama tidak ditemukan";
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        namaPerusahaan = "Error: Nama perusahaan tidak ditemukan";
        kontakUtama = "Error: Kontak utama tidak ditemukan";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Pengaturan Perusahaan'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan Perusahaan'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(namaPerusahaan),
            subtitle: Text(kontakUtama),
          ),
          Divider(),
          ListTile(
            title: Text("Detail Personal"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailPersonalPage()),
              );
            },
          ),
          ListTile(
            title: Text("Detail Perusahaan"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailPerusahaanPage()),
              );
            },
          ),
          ListTile(
            title: Text("Perizinan"),
            trailing: Icon(Icons.arrow_forward),
          ),
          ListTile(
            title: Text("Bantuan"),
            trailing: Icon(Icons.arrow_forward),
          ),
          Center(
            child: TextButton(
              onPressed: () async {
                // Hapus data dari SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // Navigasi ke halaman login dan menghapus semua route sebelumnya
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreenPerusahaan()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text(
                "Log Out",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPersonalPage extends StatefulWidget {
  @override
  _DetailPersonalPageState createState() => _DetailPersonalPageState();
}

class _DetailPersonalPageState extends State<DetailPersonalPage> {
  String nama = "";
  String email = "";
  bool isLoading = true;
  String? idPerusahaan;

  final String apiUrlGetData = 'http://10.0.3.2:3000/api/getDataPerusahaan';
  final String apiUrlUpdate = 'http://10.0.3.2:3000/api/updatePersonal';

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idPerusahaan = prefs.getString(
        'idPerusahaan'); // Ambil ID perusahaan dari SharedPreferences

    // Fallback untuk data nama dan email
    nama = prefs.getString('name') ?? "Nama tidak tersedia";
    email = prefs.getString('email') ?? "Email tidak tersedia";

    if (idPerusahaan != null) {
      fetchPersonalData();
    } else {
      print("ID Perusahaan tidak ditemukan");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchPersonalData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrlGetData),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idPerusahaan': idPerusahaan}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Debugging log
        print("API Data: $data");

        setState(() {
          nama = data['name'] ?? nama;
          email = data['email'] ?? email;
        });
      } else {
        print('Gagal memuat data personal: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updatePersonalData(String newNama, String newEmail) async {
    try {
      print("Mengirim data ke API:");
      print("ID Perusahaan: $idPerusahaan");
      print("Nama Baru: $newNama");
      print("Email Baru: $newEmail");

      final response = await http.put(
        Uri.parse(apiUrlUpdate),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idPerusahaan': idPerusahaan,
          'username': newNama,
          'email': newEmail,
        }),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'exist') {
          // Jika email sudah digunakan
          print('Email sudah digunakan: ${responseData['message']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              backgroundColor: Colors.red,
            ),
          );
        } else if (responseData['status'] == 'success') {
          // Jika data berhasil diperbarui
          print('Data personal berhasil diperbarui');
          SharedPreferences prefs = await SharedPreferences.getInstance();

          await prefs.setString('name', newNama);
          await prefs.setString('email', newEmail);

          setState(() {
            nama = newNama;
            email = newEmail;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Data berhasil diperbarui"),
            ),
          );
        } else {
          // Jika status tidak diketahui
          print('Status tidak diketahui: ${responseData['status']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Terjadi kesalahan yang tidak diketahui"),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        // Jika status code bukan 200
        print('Gagal memperbarui data personal: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Terjadi kesalahan pada server"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Tangani kesalahan koneksi atau lainnya
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan saat memperbarui data"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editField(String title, String initialValue, Function(String) onSave) {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $title"),
          content: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Masukkan $title baru",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detail Personal'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Personal'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text("Nama"),
              subtitle: Text(nama.isNotEmpty ? nama : "Nama tidak tersedia"),
              trailing: TextButton(
                onPressed: () {
                  _editField("Nama", nama, (value) {
                    // Ketika edit nama, update nama di database
                    updatePersonalData(value, email);
                  });
                },
                child: Text("Edit"),
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Email"),
              subtitle: Text(email.isNotEmpty ? email : "Email tidak tersedia"),
              trailing: TextButton(
                onPressed: () {
                  _editField("Email", email, (value) {
                    // Ketika edit email, update email di database
                    updatePersonalData(nama, value);
                  });
                },
                child: Text("Edit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPerusahaanPage extends StatefulWidget {
  @override
  _DetailPerusahaanPageState createState() => _DetailPerusahaanPageState();
}

class _DetailPerusahaanPageState extends State<DetailPerusahaanPage> {
  String namaPerusahaan = "";
  String kontakUtama = "";
  String noTelepon = "";
  bool isLoading = true;
  String? idPerusahaan;

  final String apiUrlGetData = 'http://10.0.3.2:3000/api/getDataPerusahaan';
  final String apiUrlUpdate = 'http://10.0.3.2:3000/api/updatePerusahaan';

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil data dari SharedPreferences sebagai fallback
    namaPerusahaan =
        prefs.getString('companyName') ?? "Nama perusahaan tidak tersedia";
    kontakUtama = prefs.getString('kontakUtama') ?? "Email tidak tersedia";
    noTelepon = prefs.getString('phone') ?? "No telepon tidak tersedia";

    idPerusahaan = prefs.getString('idPerusahaan');
    if (idPerusahaan != null) {
      await fetchCompanyData();
    } else {
      print("ID Perusahaan tidak ditemukan");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchCompanyData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrlGetData),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idPerusahaan': idPerusahaan}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Debugging log
        print("Respons API: $data");

        setState(() {
          namaPerusahaan = data['data'][0]['namaBisnis'] ?? namaPerusahaan;
          kontakUtama = data['data'][0]['kontakUtama'] ?? kontakUtama;
          noTelepon = data['data'][0]['nomorHP'] ?? noTelepon;
        });
      } else {
        print('Gagal memuat data perusahaan: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateCompanyData(String newNamaPerusahaan,
      String newKontakUtama, String newNoTelepon) async {
    try {
      final response = await http.put(
        Uri.parse(apiUrlUpdate),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idPerusahaan': idPerusahaan,
          'namaBisnis': newNamaPerusahaan,
          'kontakUtama': newKontakUtama,
          'nomorHP': newNoTelepon,
        }),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print('Data perusahaan berhasil diperbarui');

        // Perbarui local state
        setState(() {
          namaPerusahaan = newNamaPerusahaan;
          kontakUtama = newKontakUtama;
          noTelepon = newNoTelepon;
        });

        // Snackbar notifikasi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Data perusahaan berhasil diperbarui")),
        );
      } else {
        print('Gagal memperbarui data perusahaan: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memperbarui data")),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan saat memperbarui data")),
      );
    }
  }

  void _editField(String title, String initialValue, Function(String) onSave) {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $title"),
          content: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Masukkan $title baru",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detail Perusahaan'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Perusahaan'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text("Nama Perusahaan"),
              subtitle: Text(namaPerusahaan.isNotEmpty
                  ? namaPerusahaan
                  : "Nama perusahaan tidak tersedia"),
              trailing: TextButton(
                onPressed: () {
                  _editField("Nama Perusahaan", namaPerusahaan, (value) {
                    updateCompanyData(value, kontakUtama, noTelepon);
                  });
                },
                child: Text("Edit"),
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Kontak Utama"),
              subtitle: Text(kontakUtama.isNotEmpty
                  ? kontakUtama
                  : "Kontak utama tidak tersedia"),
              trailing: TextButton(
                onPressed: () {
                  _editField("Kontak Utama", kontakUtama, (value) {
                    updateCompanyData(namaPerusahaan, value, noTelepon);
                  });
                },
                child: Text("Edit"),
              ),
            ),
            Divider(),
            ListTile(
              title: Text("No. Telepon"),
              subtitle: Text(noTelepon.isNotEmpty
                  ? noTelepon
                  : "No telepon tidak tersedia"),
              trailing: TextButton(
                onPressed: () {
                  _editField("No. Telepon", noTelepon, (value) {
                    updateCompanyData(namaPerusahaan, kontakUtama, value);
                  });
                },
                child: Text("Edit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
