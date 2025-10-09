import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/society_model.dart';

class SocietyService {
  static const String baseUrl = 'https://jobseeker-database.vercel.app/api';

  /// ✅ Fungsi untuk melengkapi profil society
  /// Mengembalikan Map dengan status success, message, dan data profile
  Future<Map<String, dynamic>> completeSocietyProfile({
    required String name,
    required String address,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required String profilePicture, // bisa kirim base64 string
  }) async {
    try {
      // Ambil token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {
          'success': false,
          'message': 'No token found. Please login first.',
        };
      }

      // Endpoint API
      final url = Uri.parse('$baseUrl/auth/complete-society-profile');

      // Body request
      final body = jsonEncode({
        'name': name,
        'address': address,
        'phone': phone,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'profile_picture': profilePicture,
      });

      // Kirim POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token, // kirim token di header
        },
        body: body,
      );

      // Parse response dari server
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // Parse data ke model
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
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }
}
  