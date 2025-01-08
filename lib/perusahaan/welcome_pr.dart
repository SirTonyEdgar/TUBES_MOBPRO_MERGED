import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'masuk_pr.dart';
import 'daftar_pr.dart';
import '../kebijakan_privasi.dart';
import '../syarat_ketentuan.dart';

class WelcomeScreenPerusahaan extends StatelessWidget {
  const WelcomeScreenPerusahaan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/gambar_peran_perusahaan.png'),
                  Text(
                    'Workers Union',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreenPerusahaan()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(200, 50),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Masuk',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HalamanRegistrasiPerusahaan()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(200, 50),
                    ),
                    child: Text(
                      'Daftar',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
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
                const Text('|', style: TextStyle(color: Colors.grey)),
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
    );
  }
}
