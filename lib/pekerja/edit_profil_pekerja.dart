import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';

class EditProfilPekerja extends StatefulWidget {
  final String initialName;
  final String initialEmail;

  EditProfilPekerja({
    required this.initialName,
    required this.initialEmail,
  });

  @override
  _EditProfilPekerjaState createState() => _EditProfilPekerjaState();
}

class _EditProfilPekerjaState extends State<EditProfilPekerja> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final idPekerja = prefs.getInt('idPekerja');

    if (idPekerja == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID pekerja tidak ditemukan.')),
      );
      return;
    }

    bool updateSuccess = true;

    // Perbarui username jika ada perubahan
    if (_nameController.text.isNotEmpty &&
        _nameController.text != widget.initialName) {
      updateSuccess = await _apiService.updateProfileData(
        idPekerja.toString(),
        'username',
        _nameController.text,
      );
    }

    // Perbarui email jika ada perubahan
    if (_emailController.text.isNotEmpty &&
        _emailController.text != widget.initialEmail) {
      updateSuccess = updateSuccess &&
          await _apiService.updateProfileData(
            idPekerja.toString(),
            'email',
            _emailController.text,
          );
    }

    if (updateSuccess) {
      await prefs.setString('username', _nameController.text);
      await prefs.setString('email', _emailController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui.')),
        );
        Navigator.pop(context, {
          'name': _nameController.text,
          'email': _emailController.text,
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui profil.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Edit Profil',
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: Text(
                    'Batal',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: _saveProfileData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    'Simpan',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
