import 'package:flutter/material.dart';
import 'daftar_pr.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'HomepagePerusahaan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenPerusahaan extends StatefulWidget {
  const LoginScreenPerusahaan({super.key});

  @override
  _LoginScreenPerusahaanState createState() => _LoginScreenPerusahaanState();
}

class _LoginScreenPerusahaanState extends State<LoginScreenPerusahaan> {
  final String apiUrl = "http://10.0.3.2:3000/api/verifyPasswordPerusahaan";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;

  Future<void> loginPerusahaan(
      String email, String password, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      print("Response body: ${response.body}"); // Debug respons API

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData["passwordCorrect"] == true) {
          print("Login berhasil!");
          print("User Data: ${responseData['user']}");

          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (responseData['user'] != null) {
            await prefs.setString('idPerusahaan',
                responseData['user']['idPerusahaan'].toString());
            await prefs.setString('email',
                responseData['user']['email'] ?? "Email tidak ditemukan");
            await prefs.setString(
                'companyName',
                responseData['user']['namaBisnis'] ??
                    "Nama bisnis tidak ditemukan");
            await prefs.setString(
                'phone', responseData['user']['nomorHP'].toString());
            await prefs.setString('name',
                responseData['user']['username'] ?? "Nama tidak ditemukan");
          } else {
            print("Data user tidak ditemukan dalam respons API");
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomNavigationBar(),
            ),
          );
        } else {
          print("Email atau password salah.");
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Login Gagal"),
              content: const Text("Email atau password salah."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      } else {
        print("Error: ${response.body}");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Login Gagal"),
            content: Text("Kesalahan server: ${response.body}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text("Kesalahan koneksi: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Perusahaan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HalamanRegistrasiPerusahaan(),
                ),
              );
            },
            child: const Text(
              'Daftar',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Masuk",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            // Email Input
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(fontFamily: 'Poppins'),
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Password Input
            TextField(
              controller: passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: const TextStyle(fontFamily: 'Poppins'),
                border: const UnderlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Lupa Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Tambahkan aksi lupa password
                },
                child: const Text(
                  "Lupa Password?",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Tombol Masuk
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final email = emailController.text;
                  final password = passwordController.text;
                  loginPerusahaan(email, password, context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Masuk",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
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
