import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ApiService {
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/verifyPassword');
    print('Calling URL: $url');
    print('Email: $email, Password: $password');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['passwordCorrect'] == true) {
        return data['user'];
      } else {
        print('Login Failed: Password incorrect');
      }
    } else {
      print('Login Failed: ${response.body}');
    }
    return null;
  }

  Future<bool> createPekerja(
      String username, String email, String password) async {
    final url = Uri.parse('$baseUrl/');
    print('Calling URL: $url');
    print('Payload: {username: $username, email: $email, password: $password}');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error during API call: $e");
      return false;
    }
  }

  Future<bool> updateProfileData(
      String idPekerja, String columnName, String value) async {
    final url = Uri.parse('$baseUrl/updateProfilData');

    print("Sending Data to Server:");
    print("idPekerja: $idPekerja, columnName: $columnName, value: $value");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idPekerja': idPekerja,
          'columnName': columnName,
          'value': value,
        }),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print('Error during API call: $e');
      return false;
    }
  }

  Future<bool> uploadFile(
      String columnName, File file, String fileName, String fileType) async {
    final url = Uri.parse('$baseUrl/uploadFile');
    final prefs = await SharedPreferences.getInstance();
    final idPekerja = prefs.getInt('idPekerja');

    if (idPekerja == null) {
      print('Error: idPekerja is null');
      return false;
    }

    const allowedColumns = ['lisensiSertif', 'resume'];
    if (!allowedColumns.contains(columnName)) {
      print('Error: Invalid columnName - $columnName');
      return false;
    }

    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['idPekerja'] = idPekerja.toString()
        ..fields['columnName'] = columnName
        ..fields['fileName'] = fileName
        ..fields['fileType'] = fileType
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        print('File berhasil diunggah. Status Code: ${response.statusCode}');
        return true;
      } else {
        print('Gagal mengunggah file. Status Code: ${response.statusCode}');
        final responseBody = await response.stream.bytesToString();
        print('Response Body: $responseBody');
        return false;
      }
    } catch (e) {
      print('Error during file upload: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getProfileData(int idPekerja) async {
    final url = Uri.parse('$baseUrl/getProfileData');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idPekerja': idPekerja}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['gambarProfil'] != null) {
          final decodedImage = base64Decode(data['gambarProfil']);
          data['decodedImage'] = decodedImage;
        }

        return data;
      } else {
        print('Failed to fetch profile data.');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}
