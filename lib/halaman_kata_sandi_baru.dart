import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pekerja/masuk_pk.dart';

class HalamanKataSandiBaru extends StatelessWidget {
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
              Text('Pilih kata sandi baru',
                  style: GoogleFonts.poppins(fontSize: 24)),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 350.0,
                child: Text('Buat kata sandi dengan panjang minimal 8 karakter',
                    style: GoogleFonts.poppins(fontSize: 12)),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Kata sandi baru',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Ketik ulang kata sandi baru',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
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
