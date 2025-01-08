import 'package:flutter/material.dart';
import 'masuk_pr.dart'; // File untuk halaman masuk
import 'privacy_terms.dart'; // File untuk kebijakan privasi & syarat ketentuan
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> daftarPerusahaan(String email, String name, String companyName,
    String phone, String password) async {
  const String apiUrl = "http://10.0.3.2:3000/api/daftarPerusahaan";

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "username": name,
        "namaBisnis": companyName,
        "nomorHP": phone,
        "password": password,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('idPerusahaan', responseData['idPerusahaan'] ?? "");
      await prefs.setString('email', email);
      await prefs.setString('name', name);
      await prefs.setString('companyName', companyName);
      await prefs.setString('phone', phone);

      // Log hasil penyimpanan
      print("Saved idPerusahaan: ${prefs.getString('idPerusahaan')}");
    } else {
      print("Gagal mendaftar: ${response.body}");
    }
  } catch (e) {
    print("Error: $e");
  }
}

Future<bool> checkEmail(String email) async {
  const String apiUrl = "http://10.0.3.2:3000/api/checkEmailPerusahaan";

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData["data"] == null ||
          (responseData["data"] as List).isEmpty) {
        print("Email belum terdaftar");
        return true; // Email belum terdaftar
      } else {
        print("Email sudah terdaftar");
        return false; // Email sudah terdaftar
      }
    } else {
      print("Error: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Error: $e");
    return true;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HalamanRegistrasiPerusahaan(),
    );
  }
}

class HalamanRegistrasiPerusahaan extends StatefulWidget {
  @override
  _HalamanRegistrasiPerusahaanState createState() =>
      _HalamanRegistrasiPerusahaanState();
}

class _HalamanRegistrasiPerusahaanState
    extends State<HalamanRegistrasiPerusahaan> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  String? validateEmail(String? value) {
    const emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    } else if (!RegExp(emailRegex).hasMatch(value)) {
      return 'Masukkan email yang valid';
    }
    return null;
  }

  String? validatePassword(String? value) {
    const passwordRegex =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    } else if (!RegExp(passwordRegex).hasMatch(value)) {
      return 'Password harus memiliki minimal 8 karakter, termasuk huruf besar, huruf kecil, angka, dan simbol';
    }
    return null;
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginScreenPerusahaan()),
              );
            },
            child: const Text(
              "Masuk",
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Daftar",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(fontFamily: 'Poppins'),
                  border: UnderlineInputBorder(),
                ),
                validator: validateEmail,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nama",
                  labelStyle: TextStyle(fontFamily: 'Poppins'),
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: companyNameController,
                decoration: const InputDecoration(
                  labelText: "Nama Perusahaan",
                  labelStyle: TextStyle(fontFamily: 'Poppins'),
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "No Hp",
                  labelStyle: TextStyle(fontFamily: 'Poppins'),
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
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
                validator: validatePassword,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final email = emailController.text;
                      final name = nameController.text;
                      final companyName = companyNameController.text;
                      final phone = phoneController.text;
                      final password = passwordController.text;
                      final isEmailAvailable = await checkEmail(email);
                      if (isEmailAvailable) {
                        await daftarPerusahaan(
                            email, name, companyName, phone, password);
                      } else {
                        print("Email sudah terdaftar, gunakan email lain");
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Daftar",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        showPrivacyPolicyDialog(context);
                      },
                      icon: const Icon(
                        Icons.privacy_tip,
                        size: 16,
                        color: Color(0xFF6A0DAD),
                      ),
                      label: const Text(
                        'Kebijakan Privasi',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Color(0xFF6A0DAD),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    TextButton.icon(
                      onPressed: () {
                        showTermsAndConditionsDialog(context);
                      },
                      icon: const Icon(
                        Icons.description,
                        size: 16,
                        color: Color(0xFF6A0DAD),
                      ),
                      label: const Text(
                        'Syarat & Ketentuan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Color(0xFF6A0DAD),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
