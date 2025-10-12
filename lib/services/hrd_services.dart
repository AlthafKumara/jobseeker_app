import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/hrd_model.dart';

class HrdService {
  static const String baseUrl = 'https://jobseeker-database.vercel.app/api';

  /// ✅ Fungsi untuk melengkapi profil HRD
  /// Mengembalikan Map dengan status success, message, dan data profile
  Future<Map<String, dynamic>> completeHrdProfile({
    required String name,
    required String address,
    required String phone,
    required String description,
    required String logo, // base64 string
  }) async {
    try {
      // Ambil token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print("ini adalah token hrd: $token");

      if (token == null) {
        return {
          'success': false,
          'message': 'No token found. Please login first.',
        };
      }

      // Endpoint API
      final url = Uri.parse('$baseUrl/auth/complete-hrd-profile');

      // Body request
      final body = jsonEncode({
        'name': name,
        'address': address,
        'phone': phone,
        'description': description,
        'logo': logo,
      });

      // Kirim POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token, // ✅ kirim token di header
        },
        body: body,
      );

      // Decode response dari server
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // Parse data ke model HRD
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
              'Failed to complete HRD profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }
}
