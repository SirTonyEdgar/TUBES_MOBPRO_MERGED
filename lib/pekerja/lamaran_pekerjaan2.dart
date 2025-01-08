import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'lamaran_pekerjaan1.dart';
import 'lamaran_pekerjaan3.dart';
import 'profil_pekerja.dart';
import '../services/api_service.dart';
import '../services/api_service_jobpost.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class LamaranPekerjaan2 extends StatefulWidget {
  final String companyName;
  final String jobTitle;
  final String businessName;
  final int idPekerjaan;
  final Map<int, String> textAnswers;
  final Map<int, List<String>> optionAnswers;

  LamaranPekerjaan2({
    required this.companyName,
    required this.jobTitle,
    required this.businessName,
    required this.idPekerjaan,
    required this.textAnswers,
    required this.optionAnswers,
  });

  @override
  _LamaranPekerjaan2State createState() => _LamaranPekerjaan2State();
}

class _LamaranPekerjaan2State extends State<LamaranPekerjaan2> {
  String resumeFileName = "Tidak ada resume atau CV yang disertakan";
  String? riwayatPekerjaan;
  String? informasiPendidikan;
  String? skill;
  String? lisensiNama;

  @override
  void initState() {
    super.initState();
    _fetchPekerjaData();
  }

  Future<void> _fetchPekerjaData() async {
    final prefs = await SharedPreferences.getInstance();
    final idPekerja = prefs.getInt('idPekerja');

    if (idPekerja == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ID Pekerja tidak ditemukan.')),
      );
      return;
    }

    final apiService = ApiService();
    try {
      final pekerjaData = await apiService.getProfileData(idPekerja);

      if (pekerjaData != null) {
        setState(() {
          riwayatPekerjaan = pekerjaData['riwayatPekerjaan'] ?? '-';
          informasiPendidikan = pekerjaData['informasiPendidikan'] ?? '-';
          skill = pekerjaData['skill'] ?? '-';
          lisensiNama = pekerjaData['lisensiNama'] ?? '-';
        });
      }
    } catch (e) {
      print('Error fetching pekerja data: $e');
    }
  }

  Future<void> _submitApplication() async {
    final prefs = await SharedPreferences.getInstance();
    final idPekerja = prefs.getInt('idPekerja');

    if (idPekerja == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ID Pekerja tidak ditemukan.')),
      );
      return;
    }

    // Convert jawabanOpsi menjadi Map<String, String>
    Map<String, String> convertedOptions = {};
    widget.optionAnswers.forEach((key, value) {
      convertedOptions[key.toString()] =
          value.join(", "); // Menggabungkan list menjadi string
    });

    // Menyusun data untuk dikirim
    final apiServiceJobPost = ApiServiceJobPost();

    // Segera arahkan ke LamaranPekerjaan3 tanpa menunggu hasil API
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LamaranPekerjaan3()),
    );

    // Kirim permintaan API untuk mengirim lamaran
    apiServiceJobPost
        .applyForJob(
      idPekerjaan: widget.idPekerjaan,
      jawabanOpsi: convertedOptions, // Menggunakan convertedOptions
      jawabanTeks: widget.textAnswers.toString(),
      tanggalLamaran: DateTime.now().toIso8601String(),
      statusLamaran: 'pending',
    )
        .then((success) {
      // Tanggapi hasil dari API jika perlu
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lamaran berhasil dikirim!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim lamaran.')),
        );
      }
    }).catchError((e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan.')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.jobTitle,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.businessName,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDocumentSection(),
            const SizedBox(height: 16),
            _buildQuestionSection(),
            const SizedBox(height: 16),
            _buildProfileSection(),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: _submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(150, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Kirim Lamaran',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dokumen Disertakan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          title: Text(resumeFileName, style: GoogleFonts.poppins()),
          trailing: ElevatedButton(
            onPressed: () => _uploadFile('resume'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              side: BorderSide(color: Colors.blue),
              minimumSize: Size(100, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Upload',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionSection() {
    final totalQuestions = 7; // Total pertanyaan di database
    final answeredQuestions =
        widget.textAnswers.length + widget.optionAnswers.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pertanyaan Perusahaan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Anda menjawab $answeredQuestions dari $totalQuestions',
          style: GoogleFonts.poppins(),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LamaranPekerjaan1(
                  companyName: widget.businessName,
                  idPekerjaan: widget.idPekerjaan,
                  jobTitle: widget.jobTitle,
                  businessName: widget.businessName,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.black),
              minimumSize: Size(60, 40),
            ),
            child: Text('Edit', style: GoogleFonts.poppins()),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileField('Riwayat Pekerjaan', riwayatPekerjaan ?? '-'),
        _buildProfileField('Pendidikan', informasiPendidikan ?? '-'),
        _buildProfileField('Skill', skill ?? '-'),
        _buildProfileField('Lisensi & Sertifikasi', lisensiNama ?? '-'),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilPekerja(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.black),
              minimumSize: Size(100, 40),
            ),
            child: Text('Edit Profil', style: GoogleFonts.poppins()),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileField(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(value, style: GoogleFonts.poppins()),
    );
  }

  Future<void> _uploadFile(String fileType) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.single.path == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pengunggahan file dibatalkan.')),
      );
      return;
    }

    final file = File(result.files.single.path!);
    final fileName = result.files.single.name;

    final prefs = await SharedPreferences.getInstance();
    final idPekerja = prefs.getInt('idPekerja');

    if (idPekerja == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kesalahan: ID Pekerja tidak ditemukan!')),
      );
      return;
    }

    final url = Uri.parse('http://192.168.18.5:3000/api/uploadFile');
    final request = http.MultipartRequest('POST', url)
      ..fields['fileType'] = fileType
      ..fields['idPekerja'] = idPekerja.toString()
      ..fields['columnName'] = 'resume'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        resumeFileName = fileName;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$fileName berhasil diunggah.')),
      );
    } else {
      print('Failed to upload file: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah $fileType.')),
      );
    }
  }
}
