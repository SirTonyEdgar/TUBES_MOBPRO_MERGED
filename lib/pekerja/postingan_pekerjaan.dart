import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lamaran_pekerjaan1.dart';

class PostinganPekerjaanScreen extends StatelessWidget {
  final Map<String, dynamic> jobPost;

  const PostinganPekerjaanScreen({Key? key, required this.jobPost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pekerjaan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.business,
                      size: 36,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    jobPost['judulPekerjaan'] ?? 'Judul Tidak Tersedia',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    jobPost['namaPerusahaan'] ?? 'Perusahaan Tidak Tersedia',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton(context, 'Deskripsi', isActive: true),
                _buildTabButton(context, 'Perusahaan', isActive: false),
                _buildTabButton(context, 'Review', isActive: false),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deskripsi',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      jobPost['deskripsiPekerjaan'] ??
                          'Deskripsi Tidak Tersedia',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Kisaran Gaji',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      jobPost['kisaranGaji'] != null &&
                              jobPost['jenisGaji'] != null
                          ? 'Rp. ${jobPost['kisaranGaji']} ${jobPost['jenisGaji']}'
                          : 'Gaji Tidak Tersedia',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LamaranPekerjaan1(
                          companyName: jobPost['namaPerusahaan'] ??
                              'Perusahaan Tidak Tersedia',
                          idPekerjaan: jobPost['idPekerjaan'] ?? 0,
                          jobTitle: jobPost['judulPekerjaan'] ??
                              'Judul Tidak Tersedia',
                          businessName: jobPost['namaPerusahaan'] ??
                              'Nama Bisnis Tidak Tersedia',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Lamar Pekerjaan',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String text,
      {bool isActive = false}) {
    return GestureDetector(
      onTap: isActive
          ? null
          : () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tab $text belum aktif.')),
              );
            },
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
          color: isActive ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}
