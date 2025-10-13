import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/hrd_model.dart';

class HrdService {
  static const String baseUrl =
      'https://jobseeker-database.vercel.app/api/auth';

  /// ✅ Lengkapi profil HRD (upload logo ke Vercel Blob via backend)
  Future<Map<String, dynamic>> completeHrdProfile({
    required String name,
    required String address,
    required String phone,
    required String description,
    required String defaultAssetPath, // contoh: 'assets/image/company.png'
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

      // ✅ Ambil file default logo dari assets
      final byteData = await rootBundle.load(defaultAssetPath);
      final bytes = byteData.buffer.asUint8List();

      // ✅ Konversi ke base64 (akan diterima backend dan diunggah ke Vercel Blob)
      final base64Logo = base64Encode(bytes);

      final uri = Uri.parse('$baseUrl/complete-hrd-profile');
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
          'description': description,
          'logo': base64Logo, // backend handle upload ke blob
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
        final profile = HrdModel.fromJson(responseData['profile']);
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
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }
}
