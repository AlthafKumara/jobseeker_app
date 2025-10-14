import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jobseeker_app/controllers/hrd_controller.dart';
import 'package:jobseeker_app/models/hrd_model.dart';
import 'package:jobseeker_app/widgets/colors.dart';
import 'package:jobseeker_app/widgets/hrd_bottom_nav.dart';

class HrdProfile extends StatefulWidget {
  const HrdProfile({super.key});

  @override
  State<HrdProfile> createState() => _HrdProfileState();
}

class _HrdProfileState extends State<HrdProfile> {
  final HrdController _controller = HrdController();

  String? logoUrl;
  File? _pickedImage;
  bool _isLoading = false;
  HrdModel? _profile;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLogo();
    _loadProfile();
  }

  /// Ambil logo awal dari controller
  Future<void> _loadLogo() async {
    final url = await _controller.loadInitialLogo();
    setState(() => logoUrl = url);
  }

  /// Pilih gambar dan update logo lewat controller
  Future<void> _pickAndUpdateLogo() async {
    setState(() => _isLoading = true);
    final result = await _controller.pickAndUpdateLogo();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Terjadi kesalahan')),
      );
    }

    if (result['success'] == true) {
      setState(() {
        logoUrl = result['logoUrl'];
        _pickedImage = result['imageFile'];
      });
    }

    setState(() => _isLoading = false);
  }

  // LOAD PROFILE
  Future<void> _loadProfile() async {
    final profile = await _controller.getProfile();
    setState(() {
      _isLoading = false;
      if (profile != null) {
        _profile = profile;
      } else {
        _errorMessage = 'Gagal memuat profil HRD';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 20),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Profile',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: "Lato",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () async {
                            final updated = await Navigator.pushNamed(
                                context, '/hrd_update_profile');
                            if (updated == true) {
                              _loadProfile();
                            }
                          },
                          child: Icon(
                            Icons.edit,
                            color: ColorsApp.primarydark,
                            size: 20,
                          )),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // =============================
                  // CIRCLE AVATAR + UPDATE BUTTON
                  // =============================
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: ColorsApp.Grey3,
                        backgroundImage: _pickedImage != null
                            ? FileImage(_pickedImage!)
                            : (logoUrl != null
                                ? NetworkImage(logoUrl!) as ImageProvider
                                : const AssetImage('assets/image/house.png')),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: InkWell(
                          onTap: _isLoading ? null : _pickAndUpdateLogo,
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _isLoading
                                  ? ColorsApp.Grey3
                                  : ColorsApp.primarydark,
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
                                    size: 20,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _profile?.name ?? "",
                        style: TextStyle(
                          color: ColorsApp.black,
                          fontFamily: "Lato",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _profile?.address ?? "",
                        style: TextStyle(
                          color: ColorsApp.Grey2,
                          fontFamily: "Lato",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
      bottomNavigationBar: HrdBottomNav(3),
    );
  }
}
