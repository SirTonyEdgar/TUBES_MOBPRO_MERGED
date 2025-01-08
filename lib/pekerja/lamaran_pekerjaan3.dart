import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'homepage_calon_pekerja.dart';

class LamaranPekerjaan3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lamar Pekerjaan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Anda telah mengirimkan lamaran Anda',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Image.asset(
              'assets/woman_sending_mail.png',
              height: 200,
            ),
            const SizedBox(height: 16),
            Text(
              'Bagus sekali, Anda telah mengirimkan lamaran pekerjaan Anda ke perusahaan.',
              style: GoogleFonts.poppins(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomepageCalonPekerja(),
                  ),
                  (route) => false,
                );
              },
              child: Text('Selesai'),
            ),
          ],
        ),
      ),
    );
  }
}
