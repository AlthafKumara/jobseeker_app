import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:jobseeker_app/services/society_services.dart';
import '../models/society_model.dart';

class SocietyController {
  final SocietyService _service = SocietyService();
  final ImagePicker _picker = ImagePicker();

  Future<Society?> getProfile() async {
    return await _service.getCurrentSociety();
  }

  Future<bool> updateSocietyData({
    required String name,
    required String address,
    required String phone,
    required String dateOfBirth,
    required String gender,
  }) async {
    final result = await _service.updateSociety(
      name: name,
      address: address,
      phone: phone,
      dateOfBirth: dateOfBirth,
      gender: gender,
    );

    return result['success'] == true;
  }

  Future<Map<String, dynamic>> pickAndUpdateProfilePhoto(String imagePath) async {
  try {
    final result = await _service.updateSocietyPhoto(imagePath: imagePath);

    if (result['success'] == true && result['profile'] != null) {
      final updatedProfile = result['profile'] as Society;
      return {
        'success': true,
        'message': result['message'] ?? 'Profile photo updated successfully ✅',
        'profile': updatedProfile,
        'imageFile': File(imagePath),
      };
    } else {
      return {
        'success': false,
        'message': result['message'] ?? 'Failed to update profile photo ❌',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Error: $e',
    };
  }
}


  /// 🧩 Fungsi khusus ambil foto profil saja dari database
  Future<String?> getProfilePhoto() async {
    final profile = await _service.getCurrentSociety();
    if (profile == null) {
      print("⚠️ Profile not found");
      return null;
    }
    return profile.profilePhoto; // field `profile_photo` dari backend
  }
}
