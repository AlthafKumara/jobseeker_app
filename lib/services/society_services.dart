import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/society_model.dart';

class SocietyService {
  static const String baseUrl =
      'https://jobseeker-database.vercel.app/api/auth';

  static const String societyUrl =
      "https://jobseeker-database.vercel.app/api/societies";

  /// ✅ Lengkapi profil society (upload image ke Vercel Blob via backend)
  Future<Map<String, dynamic>> completeSocietyProfile({
    required String name,
    required String address,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required String defaultAssetPath, // ex: 'assets/image/user.png'
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {
          'success': false,
          'message': 'No token found. Please login first.'
        };
      }

      // ✅ Ambil file default dari assets
      final byteData = await rootBundle.load(defaultAssetPath);
      final bytes = byteData.buffer.asUint8List();

      // ✅ Konversi ke base64 (akan diterima backend dan diunggah ke Vercel Blob)
      final base64Image = base64Encode(bytes);

      final uri = Uri.parse('$baseUrl/complete-society-profile');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'name': name,
          'address': address,
          'phone': phone,
          'date_of_birth': dateOfBirth,
          'gender': gender,
          'profile_photo': base64Image, // backend handle upload ke blob
        }),
      );

      print('📥 Status Code: ${response.statusCode}');
      print('📥 Response Body Raw: ${response.body}');

      Map<String, dynamic> responseData = {};
      try {
        responseData = jsonDecode(response.body);
      } catch (e) {
        print('❌ Gagal decode JSON: $e');
        print('📄 Response bukan JSON valid: ${response.body}');
        return {
          'success': false,
          'message': 'Invalid response format from server.',
        };
      }

      if (response.statusCode == 200 && responseData['success'] == true) {
        final profile = Society.fromJson(responseData['profile']);
        return {
          'success': true,
          'message': responseData['message'] ?? 'Profile updated successfully',
          'profile': profile,
        };
      } else {
        return {
          'success': false,
          'message': responseData['error'] ??
              responseData['message'] ??
              'Failed to complete profile',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Society?> getCurrentSociety() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) return null;

      final uri = Uri.parse('$societyUrl/me');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Society.fromJson(data);
      } else {
        print('❌ Failed to fetch society. Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Error fetching society: $e');
      return null;
    }
  }

  /// 🔹 Update tanpa profile photo
  Future<Map<String, dynamic>> updateSociety({
    required String name,
    required String address,
    required String phone,
    required String dateOfBirth,
    required String gender,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return {'success': false, 'message': 'Token missing'};

      final uri = Uri.parse('$societyUrl/me');
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'name': name,
          'address': address,
          'phone': phone,
          'date_of_birth': dateOfBirth,
          'gender': gender,
          'profile_photo': '', // tidak diubah
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'profile': Society.fromJson(data)};
      } else {
        return {'success': false, 'message': data['msg'] ?? 'Failed to update'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// 🔹 Update profile picture saja
  Future<Map<String, dynamic>> updateSocietyPhoto({
    required String imagePath,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {
          'success': false,
          'message': 'No token found. Please login first.',
        };
      }

      final uri = Uri.parse('$societyUrl/me');
      final request = http.MultipartRequest('PUT', uri)
        ..headers['x-auth-token'] = token
        ..files
            .add(await http.MultipartFile.fromPath('profile_photo', imagePath));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('📤 Status Code: ${response.statusCode}');
      print('📥 Response Body: $responseBody');

      final data = jsonDecode(responseBody);

      if (response.statusCode == 200 && data['success'] == true) {
        final profile = Society.fromJson(data['profile']);
        return {
          'success': true,
          'message': data['message'] ?? 'Profile photo updated successfully',
          'profile': profile,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update photo',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }
}
