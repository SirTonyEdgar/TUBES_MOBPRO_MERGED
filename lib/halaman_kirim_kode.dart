import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'halaman_kata_sandi_baru.dart';

class HalamanKirimKodeLupaKataSandi extends StatelessWidget {
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
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Kami baru saja mengirimkan kode ke email anda',
                  style: GoogleFonts.poppins(fontSize: 24)),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 350.0,
                child: Text(
                    'Masukkan 6 digit kode verifikasi yang dikirimkan ke ******@gmail.com.',
                    style: GoogleFonts.poppins(fontSize: 12)),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Kode 6 digit',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Kirim ulang kode',
                    style: GoogleFonts.poppins(color: Colors.blue)),
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HalamanKataSandiBaru()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0A66C2),
                    minimumSize: Size(280.0, 50),
                  ),
                  child: Text('Kirim',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ));
  }
}
