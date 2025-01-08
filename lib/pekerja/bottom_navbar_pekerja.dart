import 'package:flutter/material.dart';
import 'homepage_calon_pekerja.dart';
import 'lamaran_terkirim.dart';
import 'pekerjaan_tersimpan.dart';
import 'notifikasi_pekerja.dart';
import 'pengaturan_pekerja.dart';

class BottomNavBarPekerja extends StatelessWidget {
  final int currentIndex;

  const BottomNavBarPekerja({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomepageCalonPekerja()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LamaranTerkirim()),
            );
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => PekerjaanTersimpanScreen()),
            );
            break;

          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NotificationScreen()),
            );
            break;
          case 4:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: 32),
          activeIcon: Icon(Icons.home, size: 32),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.email_outlined, size: 32),
          activeIcon: Icon(Icons.email, size: 32),
          label: 'Lamaran',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_outline, size: 32),
          activeIcon: Icon(Icons.bookmark, size: 32),
          label: 'Tersimpan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined, size: 32),
          activeIcon: Icon(Icons.notifications, size: 32),
          label: 'Notifikasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined, size: 32),
          activeIcon: Icon(Icons.settings, size: 32),
          label: 'Pengaturan',
        ),
      ],
    );
  }
}
