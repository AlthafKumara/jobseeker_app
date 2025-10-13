import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/society_model.dart';

class SocietyService {
  static const String baseUrl =
      'https://jobseeker-database.vercel.app/api/auth';

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
}
