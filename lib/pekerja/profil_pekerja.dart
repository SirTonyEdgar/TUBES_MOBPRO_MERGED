import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/api_service.dart';
import 'edit_profil_pekerja.dart';
import '../services/api_config.dart';

class ProfilPekerja extends StatefulWidget {
  @override
  _ProfilPekerjaState createState() => _ProfilPekerjaState();
}

class _ProfilPekerjaState extends State<ProfilPekerja> {
  String _name = 'User';
  String _email = 'example@example.com';
  String _profilePicture = '';
  String _license = 'Belum ada file';
  String _resume = 'Belum ada file';
  String _licenseType = '';
  String _resumeType = '';
  String _ringkasanPribadi = 'Tambahkan ringkasan pribadi ke profil Anda.';
  String _riwayatPekerjaan = 'Tambahkan pengalaman kerja Anda.';
  String _pendidikan = 'Tambahkan informasi pendidikan Anda.';
  String _skill = 'Tambahkan skill Anda.';
  String _bahasa = 'Tambahkan bahasa yang Anda kuasai.';

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final idPekerja = prefs.getInt('idPekerja');

      if (idPekerja == null) {
        print("Error: idPekerja is null");
        return;
      }

      final profileData = await _apiService.getProfileData(idPekerja);

      if (profileData != null && profileData.isNotEmpty) {
        setState(() {
          _name = profileData['username'] ?? 'User';
          _email = profileData['email'] ?? 'example@example.com';
          _profilePicture = profileData['gambarProfil'] ?? '';

          _ringkasanPribadi = profileData['ringkasan'] ??
              'Tambahkan ringkasan pribadi ke profil Anda.';
          _riwayatPekerjaan = profileData['riwayatPekerjaan'] ??
              'Tambahkan pengalaman kerja Anda.';
          _pendidikan = profileData['informasiPendidikan'] ??
              'Tambahkan informasi pendidikan Anda.';
          _skill = profileData['skill'] ?? 'Tambahkan skill Anda.';
          _bahasa =
              profileData['bahasa'] ?? 'Tambahkan bahasa yang Anda kuasai.';
          _license = profileData['lisensiNama'] ?? 'Belum ada file';
          _licenseType = profileData['lisensiTipe'] ?? '';
          _resume = profileData['resumeNama'] ?? 'Belum ada file';
          _resumeType = profileData['resumeTipe'] ?? '';
        });
      } else {
        print("Error: Profile data is null or empty");
      }
    } catch (e) {
      print("Error loading profile data: $e");
    }
  }

  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilPekerja(
          initialName: _name,
          initialEmail: _email,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _name = result['name'] ?? _name;
        _email = result['email'] ?? _email;
        _profilePicture = result['profilePicture'] ?? _profilePicture;
      });
    }
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _name);
    await prefs.setString('email', _email);
    await prefs.setString('profilePicture', _profilePicture);
  }

  Future<void> _saveToServer(String columnName, String value) async {
    final prefs = await SharedPreferences.getInstance();
    final idPekerja = prefs.getInt('idPekerja');

    if (idPekerja == null) {
      print("Error: idPekerja is null");
      return;
    }

    print("Calling updateProfileData with:");
    print("idPekerja: $idPekerja, columnName: $columnName, value: $value");

    final success = await _apiService.updateProfileData(
      idPekerja.toString(),
      columnName,
      value,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan ke server.')),
      );
      _loadProfileData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan data ke server.')),
      );
    }
  }

  Future<void> _uploadFile(String columnName) async {
    if (!['lisensiSertif', 'resume'].contains(columnName)) {
      throw Exception('Invalid columnName');
    }

    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.single.path == null) {
      return;
    }

    final file = File(result.files.single.path!);
    final fileName = result.files.single.name;
    final fileType = result.files.single.extension ?? 'unknown';

    print("Uploading file: $fileName ($fileType)");

    final success = await _apiService.uploadFile(
      columnName,
      file,
      fileName,
      fileType,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File berhasil diunggah.')),
      );
      _loadProfileData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengunggah file.')),
      );
    }
  }

  void _showTextInputDialog(String title, String initialValue,
      Function(String) onSubmit, String columnName) {
    final TextEditingController controller =
        TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(hintText: 'Masukkan $title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                onSubmit(controller.text);
                _saveToServer(columnName, controller.text);
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFileDisplay(String fileName, String fileType) {
    if (fileName == 'Belum ada file') {
      return Text(
        fileName,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
      );
    }

    IconData icon;
    if (fileType.contains('pdf')) {
      icon = Icons.picture_as_pdf;
    } else if (fileType.contains('image')) {
      icon = Icons.image;
    } else {
      icon = Icons.insert_drive_file;
    }

    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            fileName,
            style: GoogleFonts.poppins(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(String title, String value,
      {bool isFileUpload = false, String? columnName, String? fileType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (isFileUpload && columnName != null) {
                    _uploadFile(columnName);
                  } else if (columnName != null) {
                    _showTextInputDialog(
                      title,
                      value,
                      (updatedValue) => _saveToServer(columnName, updatedValue),
                      columnName,
                    );
                  }
                },
                child: Text(
                  'Tambah/Edit',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          isFileUpload
              ? _buildFileDisplay(value, fileType ?? '')
              : Text(
                  value,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                ),
          const Divider(height: 24, thickness: 1),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Data',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: _profilePicture.startsWith('http')
                      ? NetworkImage(_profilePicture)
                      : _profilePicture.isNotEmpty
                          ? NetworkImage('$baseUrl/${_profilePicture}')
                          : AssetImage('assets/default_profile.png')
                              as ImageProvider,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _name.isNotEmpty ? _name : 'Nama Anda',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      _email.isNotEmpty ? _email : 'Email Anda',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: _navigateToEditProfile,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 20),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Edit profil >',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProfileSection(
              'Ringkasan Pribadi',
              _ringkasanPribadi.isNotEmpty
                  ? _ringkasanPribadi
                  : 'Tambahkan ringkasan pribadi ke profil Anda.',
              columnName: 'ringkasan',
            ),
            _buildProfileSection(
              'Riwayat Pekerjaan',
              _riwayatPekerjaan.isNotEmpty
                  ? _riwayatPekerjaan
                  : 'Tambahkan pengalaman kerja Anda.',
              columnName: 'riwayatPekerjaan',
            ),
            _buildProfileSection(
              'Pendidikan',
              _pendidikan.isNotEmpty
                  ? _pendidikan
                  : 'Tambahkan informasi pendidikan Anda.',
              columnName: 'informasiPendidikan',
            ),
            _buildProfileSection(
              'Skill',
              _skill.isNotEmpty ? _skill : 'Tambahkan skill Anda.',
              columnName: 'skill',
            ),
            _buildProfileSection(
              'Bahasa',
              _bahasa.isNotEmpty
                  ? _bahasa
                  : 'Tambahkan bahasa yang Anda kuasai.',
              columnName: 'bahasa',
            ),
            _buildProfileSection(
              'Lisensi & Sertifikasi',
              _license.isNotEmpty ? _license : 'Belum ada file.',
              isFileUpload: true,
              columnName: 'lisensiSertif',
              fileType: _licenseType,
            ),
            _buildProfileSection(
              'Resume/CV',
              _resume.isNotEmpty ? _resume : 'Belum ada file.',
              isFileUpload: true,
              columnName: 'resume',
              fileType: _resumeType,
            ),
          ],
        ),
      ),
    );
  }
}
