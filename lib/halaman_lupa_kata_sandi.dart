import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'halaman_kirim_kode.dart';

class HalamanLupaKataSandi extends StatelessWidget {
  const HalamanLupaKataSandi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Workers Union',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Lupa Kata Sandi?',
                  style: GoogleFonts.poppins(fontSize: 30)),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 350.0,
                child: Text(
                    'Setel ulang kata sandi anda dengan memasukkan email anda',
                    style: GoogleFonts.poppins(fontSize: 14)),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: const TextField(
                  decoration: InputDecoration(
                    labelText: 'Email anda',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HalamanKirimKodeLupaKataSandi()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A66C2),
                    minimumSize: const Size(280.0, 50),
                  ),
                  child: Text('Reset Kata Sandi',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Kembali',
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF000000),
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ));
  }
}
