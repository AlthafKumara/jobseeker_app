import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobseeker_app/services/hrd_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobseeker_app/models/hrd_model.dart';
import 'package:jobseeker_app/widgets/colors.dart';

import '../../widgets/customtextfield.dart';

class CompleteHrdProfileView extends StatefulWidget {
  const CompleteHrdProfileView({super.key});

  @override
  State<CompleteHrdProfileView> createState() => _CompleteHrdProfileViewState();
}

class _CompleteHrdProfileViewState extends State<CompleteHrdProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _selectedImage;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String base64Logo;
    if (_selectedImage != null) {
      final bytes = await _selectedImage!.readAsBytes();
      base64Logo = base64Encode(bytes);
    } else {
      final bytes =
          await DefaultAssetBundle.of(context).load('assets/image/house.png');
      base64Logo = base64Encode(bytes.buffer.asUint8List());
    }

    final token = await _getToken();
    if (token == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Authentication token not found!")),
      );
      return;
    }

    final hrd = HrdModel(
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      phone: _phoneController.text.trim(),
      description: _descriptionController.text.trim(),
      logo: base64Logo,
    );

    final result = await HrdService().completeHrdProfile(
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      phone: _phoneController.text.trim(),
      description: _descriptionController.text.trim(),
      logo: base64Logo,
    );

    final snackBar = SnackBar(
      content: Text(
        result['message'] ??
            (result['success']
                ? 'Profile updated successfully'
                : 'Failed to update profile'),
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: result['success'] ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (result['success']) {
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result["message"]),
        backgroundColor: result["success"] ? Colors.green : Colors.red,
      ),
    );

    if (result["success"]) {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _selectedImage != null
        ? FileImage(_selectedImage!)
        : const AssetImage("assets/image/house.png") as ImageProvider;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 🖼️ Avatar
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: ColorsApp.white1,
                      backgroundImage: imageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: _isLoading ? null : _pickImage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorsApp.primarydark,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child:
                              const Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              CustomTextField(
                controller: _nameController,
                label: "Institution Name",
                hintText: "Enter your institution name",
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _addressController,
                label: "Address",
                hintText: "Enter your address",
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _phoneController,
                label: "Phone Number",
                hintText: "Enter your phone number",
                keyboardType: TextInputType.phone,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: "Description",
                hintText: "Brief description about your company",
                maxLines: 3,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 30),

              // 🔘 Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsApp.primarydark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _submitProfile,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Lato",
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
