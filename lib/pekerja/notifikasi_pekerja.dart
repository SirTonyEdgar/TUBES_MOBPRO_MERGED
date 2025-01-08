import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bottom_navbar_pekerja.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Notifikasi',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 1.0),
        child: Column(
          children: [
            Divider(
              color: Colors.black,
              height: 20,
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            Expanded(
              child: ListView(
                children: [
                  NotificationTile(
                    companyName: 'PT Sumber Alfaria Trijaya',
                    logo: 'assets/Logo_Alfamart.png',
                    day: 'Minggu',
                    message: 'Permintaan kerja kasir anda diterima',
                  ),
                  Divider(
                    color: Colors.black,
                    height: 1,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  NotificationTile(
                    companyName: 'PT Varian Global Perencana',
                    logo: 'assets/logo_varian_global_perencana.jpeg',
                    day: 'Sabtu',
                    message: 'Permintaan kerja admin anda diterima',
                  ),
                  Divider(
                    color: Colors.black,
                    height: 1,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarPekerja(
        currentIndex: 3,
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String companyName;
  final String logo;
  final String day;
  final String message;

  NotificationTile({
    required this.companyName,
    required this.logo,
    required this.day,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      companyName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      day,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Image.asset(
                  logo,
                  width: 60,
                  height: 40,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 8),
                Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
