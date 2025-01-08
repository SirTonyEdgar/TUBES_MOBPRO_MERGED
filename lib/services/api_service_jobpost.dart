import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';
import 'dart:io';

class ApiServiceJobPost {
  // Mengambil daftar pekerjaan
  Future<List<Map<String, dynamic>>?> getJobPosts() async {
    final url = Uri.parse('$baseUrl/jobPosts');
    try {
      final response = await http.get(url);
      print('API Response: ${response.body}');
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        print('Failed to fetch job posts: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching job posts: $e');
      return null;
    }
  }

  // Mengambil detail pekerjaan berdasarkan ID
  Future<Map<String, dynamic>?> getJobPostDetail(int id) async {
    final url = Uri.parse('$baseUrl/jobPosts/$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(jsonDecode(response.body));
      } else {
        print('Failed to fetch job post detail: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching job post detail: $e');
      return null;
    }
  }

  Future<bool> applyForJob({
    required int idPekerjaan,
    required Map<String, String> jawabanOpsi,
    required String jawabanTeks,
    required String tanggalLamaran,
    required String statusLamaran,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final akunPekerja = prefs.getInt('idPekerja');

    if (akunPekerja == null) {
      print('Error: idPekerja tidak ditemukan.');
      return false;
    }

    // Menambahkan jobPosts/apply ke baseUrl
    final url = Uri.parse('$baseUrl/jobPosts/apply'); // Ini sudah benar

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idPekerjaan': idPekerjaan,
          'akunPekerja': akunPekerja,
          'jawabanOpsi': jawabanOpsi,
          'jawabanTeks': jawabanTeks,
          'tanggalLamaran': tanggalLamaran,
          'statusLamaran': statusLamaran,
        }),
      );

      if (response.statusCode == 201) {
        print('Job application submitted successfully.');
        return true;
      } else {
        print('Failed to apply for job: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error applying for job: $e');
      return false;
    }
  }

  Future<bool> uploadFile({
    required String fileType,
    required File file,
    required String columnName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final idPekerja = prefs.getInt('idPekerja');

    if (idPekerja == null) {
      print('Error: idPekerja tidak ditemukan.');
      return false;
    }

    // Batasi hanya untuk resume
    if (columnName != 'resume') {
      print('Invalid columnName: $columnName');
      return false;
    }

    final url = Uri.parse('http://10.0.3.2:3000/api/uploadFile');

    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['fileType'] = fileType
        ..fields['columnName'] = columnName
        ..fields['idPekerja'] = idPekerja.toString()
        ..files.add(
          await http.MultipartFile.fromPath('file', file.path),
        );

      print("Uploading file with parameters:");
      print("fileType: $fileType");
      print("columnName: $columnName");
      print("idPekerja: $idPekerja");

      final response = await request.send();

      if (response.statusCode == 200) {
        print('File uploaded successfully.');
        return true;
      } else {
        print('Failed to upload file: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error uploading file: $e');
      return false;
    }
  }
}
