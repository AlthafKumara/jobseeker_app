import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobseeker_app/controllers/society_controller.dart';
import 'package:jobseeker_app/models/society_model.dart';
import 'package:jobseeker_app/views/society_view/society_update.dart';
import 'package:jobseeker_app/widgets/colors.dart';
import 'package:jobseeker_app/widgets/society_bottom_nav.dart';

class SocietyProfile extends StatefulWidget {
  const SocietyProfile({super.key});

  @override
  State<SocietyProfile> createState() => _SocietyProfileState();
}

class _SocietyProfileState extends State<SocietyProfile> {
  late SocietyController _controller;
  bool _isLoading = false;

  Society? societyProfile;
  File? _pickedImageFile;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _controller = SocietyController();
    _initProfile();
  }

  /// 🔹 Ambil data profil dari backend
  Future<void> _initProfile() async {
    setState(() => _isLoading = true);

    final profile = await _controller.getProfile();
    final photoUrl = await _controller.getProfilePhoto();

    setState(() {
      societyProfile = profile;
      _photoUrl = photoUrl ?? societyProfile?.profilePhoto;
      _isLoading = false;
    });
  }

  /// 🔹 Pilih & upload foto profil baru
  Future<void> _pickAndUpdateProfilePhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() {
      _pickedImageFile = File(picked.path);
      _isLoading = true;
    });

    final result = await _controller.pickAndUpdateProfilePhoto(picked.path);

    setState(() {
      _isLoading = false;
      if (result['success'] == true) {
        final updatedProfile = result['profile'] as Society;
        societyProfile = updatedProfile;
        _photoUrl = updatedProfile.profilePhoto;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Gagal update foto')),
        );
      }
    });
  }

  /// 🔹 Refresh profil (tarik ke bawah)
  Future<void> _refreshProfile() async {
    await _initProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.white,
      bottomNavigationBar: SocietyBottomNav(3),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ===========================
                // HEADER
                // ===========================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontFamily: "Lato",
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const UpdateSocietyProfileView(),
                          ),
                        );

                        // 🔹 Jika setelah update user berhasil mengubah data, kita bisa refresh halaman
                        if (result == true) {
                          // misalnya panggil ulang fungsi getProfile() atau setState untuk refresh UI
                          _initProfile();
                        }
                      },
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          color: ColorsApp.primarydark,
                          fontFamily: "Lato",
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ===========================
                // PROFILE PICTURE + CAMERA BTN
                // ===========================
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: ColorsApp.Grey3,
                      backgroundImage: _pickedImageFile != null
                          ? FileImage(_pickedImageFile!)
                          : (_photoUrl != null && _photoUrl!.isNotEmpty)
                              ? NetworkImage(_photoUrl!)
                              : const AssetImage('assets/image/user.png')
                                  as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: InkWell(
                        onTap: _isLoading ? null : _pickAndUpdateProfilePhoto,
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: ColorsApp.primarydark,
                            shape: BoxShape.circle,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 15,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ===========================
                // NAME
                // ===========================
                Text(
                  societyProfile?.name ?? '',
                  style: TextStyle(
                    color: ColorsApp.black,
                    fontFamily: "Lato",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                // ===========================
                // ADDRESS
                // ===========================
                Text(
                  societyProfile?.address ?? '',
                  style: TextStyle(
                    color: ColorsApp.Grey2,
                    fontFamily: "Lato",
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Applied",
                          style: TextStyle(
                            color: ColorsApp.Grey2,
                            fontFamily: "Lato",
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "0 Jobs",
                          style: TextStyle(
                            color: ColorsApp.black,
                            fontFamily: "Lato",
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 35,
                      width: 1,
                      color: ColorsApp.Grey2,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Status",
                          style: TextStyle(
                            color: ColorsApp.Grey2,
                            fontFamily: "Lato",
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "Worked",
                          style: TextStyle(
                            color: Colors.green,
                            fontFamily: "Lato",
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Skills",
                      style: TextStyle(
                        color: ColorsApp.black,
                        fontFamily: "Lato",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.edit,
                          color: ColorsApp.primarydark,
                          size: 20,
                        )),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
