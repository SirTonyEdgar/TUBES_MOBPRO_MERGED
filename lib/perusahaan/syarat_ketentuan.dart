import 'package:flutter/material.dart';

void showTermsAndConditionsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Syarat & Ketentuan'),
        content: Container(
          width: double.maxFinite,
          height: 300.0,
          child: ListView(
            children: const <Widget>[
              Text(
                "Dengan menggunakan aplikasi ini, Anda setuju untuk mematuhi syarat dan ketentuan berikut.",
              ),
              SizedBox(height: 10),
              Text(
                "1. Penggunaan Aplikasi: Aplikasi hanya boleh digunakan sesuai hukum yang berlaku.",
              ),
              SizedBox(height: 10),
              Text(
                "2. Kewajiban Pengguna: Pengguna bertanggung jawab atas semua aktivitas yang dilakukan di aplikasi ini.",
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
