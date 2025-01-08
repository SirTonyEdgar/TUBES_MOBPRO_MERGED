import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pilih_peran.dart';
import 'profil_pekerja.dart';
import '../bantuan.dart';
import 'bottom_navbar_pekerja.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _name = 'User';
  String _email = 'example@example.com';
  String _profilePicture = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('username') ?? 'User';
      _email = prefs.getString('email') ?? 'example@example.com';
      _profilePicture = prefs.getString('profilePicture') ?? '';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _name = 'User';
      _email = 'example@example.com';
      _profilePicture = '';
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PilihPeranPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Pengaturan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: _profilePicture.isNotEmpty
                        ? FileImage(File(_profilePicture)) as ImageProvider
                        : const AssetImage('assets/default_profile.png'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _email,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Akun',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_2_outlined),
                    title: const Text('Profil Data'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilPekerja(),
                        ),
                      ).then((_) {
                        _loadProfileData();
                      });
                    },
                  ),
                  const Divider(height: 1, thickness: 1, color: Colors.black),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Bantuan'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HalamanBantuan(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, thickness: 1, color: Colors.black),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Preferensi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 1, thickness: 1, color: Colors.black),
              ListTile(
                leading: const Icon(Icons.dark_mode_outlined),
                title: const Text('Mode Gelap'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1, thickness: 1, color: Colors.black),
              const Spacer(),
              Center(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: TextButton(
                    onPressed: _logout,
                    child: const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarPekerja(
        currentIndex: 4,
      ),
    );
  }
}
