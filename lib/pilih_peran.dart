import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pekerja/welcome_pk.dart';
import 'perusahaan/welcome_pr.dart';
import 'kebijakan_privasi.dart';
import 'syarat_ketentuan.dart';

void main() {
  runApp(PilihPeranApp());
}

class PilihPeranApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PilihPeranPage(),
    );
  }
}

class PilihPeranPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, bottom: 8.0),
              child: Text(
                'Pilih Peran Anda',
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/gambar_peran_calon_pekerja.png',
                    height: 150,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Temukan pekerjaan impianmu di sini',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Calon Pekerja',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/gambar_peran_perusahaan.png',
                    height: 150,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Rekrut orang yang Anda butuhkan,\nmudah dan cepat',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreenPerusahaan()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Perusahaan',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      showPrivacyPolicyDialog(context);
                    },
                    child: Text(
                      'Kebijakan Privasi',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                  Text('|', style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      showTermsAndConditionsDialog(context);
                    },
                    child: Text(
                      'Syarat & Ketentuan',
                      style: GoogleFonts.poppins(),
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
