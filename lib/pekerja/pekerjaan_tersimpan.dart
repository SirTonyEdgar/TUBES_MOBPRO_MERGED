import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navbar_pekerja.dart';

class PekerjaanTersimpanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali
        title: Text(
          'Pekerjaan Tersimpan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getSavedJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Belum ada pekerjaan yang disimpan.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            );
          }
          final savedJobs = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: savedJobs.length,
            itemBuilder: (context, index) {
              final job = savedJobs[index];
              return _buildJobCard(context, job);
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBarPekerja(
        currentIndex: 2, // Menandai tab "Tersimpan" sebagai aktif
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.business, // Ikon kantor bawaan Flutter
            size: 50,
            color: Colors.blueAccent,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job['judulPekerjaan'] ?? 'Judul Tidak Tersedia',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  job['namaPerusahaan'] ?? 'Perusahaan Tidak Tersedia',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  job['deskripsiPekerjaan'] ?? 'Deskripsi Tidak Tersedia',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => removeSavedJob(job),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getSavedJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedJobs = prefs.getStringList('savedJobs') ?? [];
    return savedJobs
        .map((job) => Map<String, dynamic>.from(jsonDecode(job)))
        .toList();
  }

  void removeSavedJob(Map<String, dynamic> job) async {
    final prefs = await SharedPreferences.getInstance();
    final savedJobs = prefs.getStringList('savedJobs') ?? [];
    savedJobs.remove(jsonEncode(job));
    await prefs.setStringList('savedJobs', savedJobs);
  }
}
