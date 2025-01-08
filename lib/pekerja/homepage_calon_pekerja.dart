import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service_jobpost.dart';
import 'postingan_pekerjaan.dart';
import 'bottom_navbar_pekerja.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomepageCalonPekerja extends StatefulWidget {
  @override
  _HomepageCalonPekerjaState createState() => _HomepageCalonPekerjaState();
}

class _HomepageCalonPekerjaState extends State<HomepageCalonPekerja> {
  final ApiServiceJobPost apiService = ApiServiceJobPost();
  Set<String> savedJobIds = {};

  @override
  void initState() {
    super.initState();
    _loadSavedJobs();
  }

  Future<void> _loadSavedJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedJobs = prefs.getStringList('savedJobs') ?? [];
    setState(() {
      savedJobIds = savedJobs.map((job) {
        final decodedJob = jsonDecode(job) as Map<String, dynamic>;
        return decodedJob['idPekerjaan'].toString();
      }).toSet();
    });
  }

  void toggleSaveJob(Map<String, dynamic> jobData) async {
    final prefs = await SharedPreferences.getInstance();
    final savedJobs = prefs.getStringList('savedJobs') ?? [];
    final jobId = jobData['idPekerjaan'].toString();
    final encodedJob = jsonEncode(jobData);

    setState(() {
      if (savedJobIds.contains(jobId)) {
        // Remove job if already saved
        savedJobIds.remove(jobId);
        savedJobs.remove(encodedJob);
      } else {
        // Save job if not saved
        savedJobIds.add(jobId);
        savedJobs.add(encodedJob);
      }
    });

    await prefs.setStringList('savedJobs', savedJobs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Workers Union',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 24),
            Text(
              'Pekerjaan yang Tersedia',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildAvailableJobs(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarPekerja(
        currentIndex: 0,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F4FD),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari pekerjaan',
                border: InputBorder.none,
              ),
              style: GoogleFonts.poppins(fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableJobs(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: apiService.getJobPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text('Gagal memuat pekerjaan'));
        }
        final jobPosts = snapshot.data!;
        return ListView.builder(
          itemCount: jobPosts.length,
          itemBuilder: (context, index) {
            final job = jobPosts[index];
            return _buildJobCard(
              context,
              jobData: job,
              title: job['judulPekerjaan'] ?? 'Judul Tidak Tersedia',
              company: job['namaPerusahaan'] ?? 'Perusahaan Tidak Tersedia',
              description: _shortenDescription(
                job['deskripsiPekerjaan'] ?? 'Deskripsi Tidak Tersedia',
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildJobCard(
    BuildContext context, {
    required Map<String, dynamic> jobData,
    required String title,
    required String company,
    required String description,
  }) {
    final jobId = jobData['idPekerjaan'].toString();
    final isSaved = savedJobIds.contains(jobId);

    return GestureDetector(
      onTap: () {
        print('Job clicked: ${jobData['judulPekerjaan']}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostinganPekerjaanScreen(jobPost: jobData),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.business,
                size: 24,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    company,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_outline,
                color: isSaved ? Colors.blue : Colors.grey,
              ),
              onPressed: () => toggleSaveJob(jobData),
            ),
          ],
        ),
      ),
    );
  }

  String _shortenDescription(String description, {int maxLength = 100}) {
    if (description.length > maxLength) {
      return '${description.substring(0, maxLength)}...';
    }
    return description;
  }
}
