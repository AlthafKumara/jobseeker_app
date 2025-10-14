import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:jobseeker_app/models/hrd_model.dart';
import 'package:jobseeker_app/services/hrd_services.dart';

class HrdController {
  final HrdService _service = HrdService();
  final ImagePicker _picker = ImagePicker();

  /// Ambil logo HRD saat pertama kali load halaman
  Future<String> loadInitialLogo() async {
    try {
      final result = await _service.getHrdProfile();
      if (result['success'] == true && result['profile'] != null) {
        final profile = result['profile'] as HrdModel;
        return profile.logo ?? 'Assets/image/house.png';
      } else {
        return 'Assets/image/house.png';
      }
    } catch (_) {
      return 'Assets/image/house.png';
    }
  }

  /// Pilih gambar dari galeri dan update logo HRD ke backend
  Future<Map<String, dynamic>> pickAndUpdateLogo() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked == null) {
        return {'success': false, 'message': 'Tidak ada gambar dipilih.'};
      }

      final result = await _service.updateHrdLogo(imagePath: picked.path);

      if (result['success'] == true && result['profile'] != null) {
        final updatedProfile = result['profile'] as HrdModel;
        return {
          'success': true,
          'message': result['message'] ?? 'Logo berhasil diperbarui ✅',
          'logoUrl': updatedProfile.logo,
          'imageFile': File(picked.path),
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Gagal memperbarui logo ❌',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  Future<HrdModel?> getProfile() async {
    final result = await _service.getHrdProfile();

    if (result['success'] == true && result['profile'] != null) {
      return result['profile'] as HrdModel;
    } else {
      print('❌ Gagal memuat profil HRD: ${result['message']}');
      return null;
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String address,
    required String phone,
    required String description,
  }) async {
    final result = await _service.updateHrdProfile(
      name: name,
      address: address,
      phone: phone,
      description: description,
    );

    if (result['success'] == true) {
      final updatedProfile = result['profile'] as HrdModel;
      return {
        'success': true,
        'message': result['message'] ?? 'Profile updated successfully ✅',
        'profile': updatedProfile,
      };
    } else {
      return {
        'success': false,
        'message': result['message'] ?? 'Failed to update profile ❌',
      };
    }
  }
}
