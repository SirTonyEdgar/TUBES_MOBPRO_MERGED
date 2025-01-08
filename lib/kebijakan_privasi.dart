import 'package:flutter/material.dart';

void showPrivacyPolicyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Kebijakan Privasi'),
        content: Container(
          width: double.maxFinite,
          height: 300.0,
          child: ListView(
            children: const <Widget>[
              Text(
                "Kebijakan privasi ini menjelaskan bagaimana informasi Anda dikumpulkan, digunakan, dan dilindungi. "
                "Dengan menggunakan aplikasi ini, Anda menyetujui pengumpulan informasi sesuai kebijakan ini.",
              ),
              SizedBox(height: 10),
              Text(
                "1. Pengumpulan Data: Kami mengumpulkan informasi pribadi yang diberikan oleh pengguna.",
              ),
              SizedBox(height: 10),
              Text(
                "2. Penggunaan Data: Data akan digunakan untuk meningkatkan layanan kami.",
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Tutup"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
