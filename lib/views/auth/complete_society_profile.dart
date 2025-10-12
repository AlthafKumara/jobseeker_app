import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobseeker_app/models/society_model.dart';
import 'package:jobseeker_app/services/society_services.dart';
import 'package:jobseeker_app/widgets/colors.dart';
import 'package:jobseeker_app/widgets/customtextfield.dart';

class CompleteSocietyProfilePage extends StatefulWidget {
  const CompleteSocietyProfilePage({super.key});

  @override
  State<CompleteSocietyProfilePage> createState() =>
      _CompleteSocietyProfilePageState();
}

class _CompleteSocietyProfilePageState
    extends State<CompleteSocietyProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final SocietyService _societyService = SocietyService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGender;
  String? _base64Image;

  bool _isLoading = false;
  Society? _profile;

  Future<void> _loadDefaultImage() async {
    final bytes = await rootBundle.load('assets/image/user.png');
    setState(() {
      _base64Image = base64Encode(bytes.buffer.asUint8List());
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDefaultImage();
  }

  /// Fungsi untuk submit data ke API
  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_base64Image == null) {
      await _loadDefaultImage();
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _societyService.completeSocietyProfile(
      name: _nameController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      dateOfBirth: _selectedDate!.toIso8601String(),
      gender: _selectedGender!,
      profilePicture: _base64Image!,
    );

    setState(() {
      _isLoading = false;
    });

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
      _profile = result['profile'] as Society;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/bg_auth.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/image/Logo.png", height: 30),
                          const SizedBox(width: 5),
                          const Text(
                            "Workscout",
                            style: TextStyle(
                              fontFamily: "Lato",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _nameController,
                              label: "Full Name",
                              hintText: "Please enter your full name",
                              keyboardType: TextInputType.name,
                              enabled: !_isLoading,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              controller: _addressController,
                              label: "Address",
                              hintText: "Please enter your address",
                              keyboardType: TextInputType.streetAddress,
                              enabled: !_isLoading,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              controller: _phoneController,
                              label: "Phone",
                              hintText: "Please enter your phone number",
                              keyboardType: TextInputType.phone,
                              enabled: !_isLoading,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            /// ✅ Date of Birth field with validation
                            FormField<DateTime>(
                              validator: (value) {
                                if (_selectedDate == null) {
                                  return 'Please select your date of birth';
                                }
                                return null;
                              },
                              builder: (FormFieldState<DateTime> fieldState) {
                                final bool hasError = fieldState.hasError;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Date of Birth'),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        // Day
                                        Expanded(
                                          flex: 2,
                                          child: _buildDateBox(
                                            hint: 'DD',
                                            controller: _dayController,
                                            onTap: () async {
                                              final picked =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: _selectedDate ??
                                                    DateTime(2000),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime.now(),
                                              );
                                              if (picked != null) {
                                                setState(() {
                                                  _selectedDate = picked;
                                                  _dayController.text = picked
                                                      .day
                                                      .toString()
                                                      .padLeft(2, '0');
                                                  _monthController.text = picked
                                                      .month
                                                      .toString()
                                                      .padLeft(2, '0');
                                                  _yearController.text =
                                                      picked.year.toString();
                                                });
                                                fieldState.didChange(picked);
                                              }
                                            },
                                            hasError: hasError,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Text('—',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.grey)),
                                        ),
                                        // Month
                                        Expanded(
                                          flex: 2,
                                          child: _buildDateBox(
                                            hint: 'MM',
                                            controller: _monthController,
                                            onTap: () async {
                                              final picked =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: _selectedDate ??
                                                    DateTime(2000),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime.now(),
                                              );
                                              if (picked != null) {
                                                setState(() {
                                                  _selectedDate = picked;
                                                  _dayController.text = picked
                                                      .day
                                                      .toString()
                                                      .padLeft(2, '0');
                                                  _monthController.text = picked
                                                      .month
                                                      .toString()
                                                      .padLeft(2, '0');
                                                  _yearController.text =
                                                      picked.year.toString();
                                                });
                                                fieldState.didChange(picked);
                                              }
                                            },
                                            hasError: hasError,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Text('—',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.grey)),
                                        ),
                                        // Year
                                        Expanded(
                                          flex: 3,
                                          child: _buildDateBox(
                                            hint: 'YYYY',
                                            controller: _yearController,
                                            onTap: () async {
                                              final picked =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: _selectedDate ??
                                                    DateTime(2000),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime.now(),
                                              );
                                              if (picked != null) {
                                                setState(() {
                                                  _selectedDate = picked;
                                                  _dayController.text = picked
                                                      .day
                                                      .toString()
                                                      .padLeft(2, '0');
                                                  _monthController.text = picked
                                                      .month
                                                      .toString()
                                                      .padLeft(2, '0');
                                                  _yearController.text =
                                                      picked.year.toString();
                                                });
                                                fieldState.didChange(picked);
                                              }
                                            },
                                            hasError: hasError,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (fieldState.hasError)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 4),
                                        child: Text(
                                          fieldState.errorText!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                            fontFamily: "Lato",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),

                            const SizedBox(height: 12),
                            _buildLabel("Select Gender"),
                            const SizedBox(height: 5),
                            DropdownButtonHideUnderline(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: Opacity(
                                  opacity: _isLoading
                                      ? 0.7
                                      : 1.0, // redup saat loading
                                  child: IgnorePointer(
                                    ignoring: _isLoading, // tidak bisa ditekan
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedGender,
                                      items: const [
                                        DropdownMenuItem(
                                            value: 'Male', child: Text('Male')),
                                        DropdownMenuItem(
                                            value: 'Female',
                                            child: Text('Female')),
                                      ],
                                      hint: const Text('Select Gender'),
                                      onChanged: (val) {
                                        setState(() {
                                          _selectedGender = val;
                                        });
                                      },
                                      validator: (val) => val == null
                                          ? 'Gender is required'
                                          : null,
                                      dropdownColor: ColorsApp.white1,
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: ColorsApp.white1,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorsApp.Grey3),
                                          borderRadius:
                                              BorderRadius.circular(11),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorsApp.Grey3),
                                          borderRadius:
                                              BorderRadius.circular(11),
                                        ),
                                        errorBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(11)),
                                        ),
                                        focusedErrorBorder:
                                            const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(11)),
                                        ),
                                        hintText: 'Select Gender',
                                        hintStyle: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.w700,
                                          color: ColorsApp.Grey2,
                                        ),
                                        errorStyle: const TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.w400,
                                          color: Colors.red,
                                          height: 1.2,
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Lato",
                                        fontWeight: FontWeight.w700,
                                        color: ColorsApp.Grey1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitProfile,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ColorsApp.white,
                        backgroundColor: ColorsApp.primarydark,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Lato",
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateBox({
    required String hint,
    required TextEditingController controller,
    required VoidCallback onTap,
    bool hasError = false,
  }) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        readOnly: true,
        enabled: !_isLoading,
        onTap: onTap,
        style: TextStyle(
          fontSize: 13,
          fontFamily: "Lato",
          fontWeight: FontWeight.w700,
          color: ColorsApp.Grey1,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorsApp.white1,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasError ? Colors.red : ColorsApp.Grey3,
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasError ? Colors.red : ColorsApp.Grey3,
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 13,
            fontFamily: "Lato",
            fontWeight: FontWeight.w700,
            color: ColorsApp.Grey2,
          ),
        ),
      ),
    );
  }
}

Widget _buildLabel(String text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontFamily: "Lato",
          fontWeight: FontWeight.w700,
          color: ColorsApp.black,
        ),
      ),
    ],
  );
}
