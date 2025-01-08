import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HalamanBantuan extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Bantuan',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                print('Laporkan Masalah tapped');
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Laporkan Masalah',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16.0),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                print('Pusat Bantuan tapped');
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pusat Bantuan',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16.0),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                print('Bantuan Privasi dan Keamanan tapped');
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bantuan Privasi dan Keamanan',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16.0),
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
