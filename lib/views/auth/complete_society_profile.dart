import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobseeker_app/models/society_model.dart';
import 'package:jobseeker_app/services/society_services.dart';
import 'package:jobseeker_app/widgets/colors.dart';

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

    if (_selectedDate == null || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Lengkapi semua field termasuk tanggal lahir dan gender.')),
      );
      return;
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
      profilePicture: _base64Image!, // 🔹 kirim gambar default
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      Navigator.pushReplacementNamed(context, "/login");
      setState(() {
        _profile = result['profile'] as Society;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(result['message'] ?? 'Profile completed successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(result['message'] ?? 'Failed to complete profile')),
      );
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
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
                                _buildLabel('Name'),
                                const SizedBox(height: 5),
                                _buildTextField(
                                  _nameController,
                                  'Name',
                                  TextInputType.text,
                                  validator: (val) =>
                                      val!.isEmpty ? 'Name is required' : null,
                                ),
                                const SizedBox(height: 12),
                                _buildLabel('Address'),
                                const SizedBox(height: 5),
                                _buildTextField(
                                  _addressController,
                                  'Address',
                                  TextInputType.text,
                                  validator: (val) => val!.isEmpty
                                      ? 'Address is required'
                                      : null,
                                ),
                                const SizedBox(height: 12),
                                _buildLabel('Phone'),
                                const SizedBox(height: 5),
                                _buildTextField(
                                  _phoneController,
                                  'Phone',
                                  TextInputType.phone,
                                  validator: (val) =>
                                      val!.isEmpty ? 'Phone is required' : null,
                                ),
                                const SizedBox(height: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Date of Birth'),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        // Day
                                        Expanded(
                                          flex: 2,
                                          child: SizedBox(
                                            height: 50,
                                            child: TextFormField(
                                              controller: _dayController,
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Lato",
                                                fontWeight: FontWeight.w700,
                                                color: ColorsApp.Grey1,
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: ColorsApp.white1,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ColorsApp.Grey3),
                                                  borderRadius:
                                                      BorderRadius.circular(11),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ColorsApp.Grey3),
                                                  borderRadius:
                                                      BorderRadius.circular(11),
                                                ),
                                                hintText: 'DD',
                                                hintStyle: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: "Lato",
                                                  fontWeight: FontWeight.w700,
                                                  color: ColorsApp.Grey2,
                                                ),
                                              ),
                                              readOnly: true,
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
                                                    _monthController.text =
                                                        picked.month
                                                            .toString()
                                                            .padLeft(2, '0');
                                                    _yearController.text =
                                                        picked.year.toString();
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Text(
                                            '—',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        // Month
                                        Expanded(
                                          flex: 2,
                                          child: SizedBox(
                                            height: 50,
                                            child: TextFormField(
                                              controller: _monthController,
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Lato",
                                                fontWeight: FontWeight.w700,
                                                color: ColorsApp.Grey1,
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: ColorsApp.white1,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ColorsApp.Grey3),
                                                  borderRadius:
                                                      BorderRadius.circular(11),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ColorsApp.Grey3),
                                                  borderRadius:
                                                      BorderRadius.circular(11),
                                                ),
                                                hintText: 'MM',
                                                hintStyle: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: "Lato",
                                                  fontWeight: FontWeight.w700,
                                                  color: ColorsApp.Grey2,
                                                ),
                                              ),
                                              readOnly: true,
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
                                                    _monthController.text =
                                                        picked.month
                                                            .toString()
                                                            .padLeft(2, '0');
                                                    _yearController.text =
                                                        picked.year.toString();
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Text(
                                            '—',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        // Year
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            height: 50,
                                            child: TextFormField(
                                              controller: _yearController,
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Lato",
                                                fontWeight: FontWeight.w700,
                                                color: ColorsApp.Grey1,
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: ColorsApp.white1,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ColorsApp.Grey3),
                                                  borderRadius:
                                                      BorderRadius.circular(11),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ColorsApp.Grey3),
                                                  borderRadius:
                                                      BorderRadius.circular(11),
                                                ),
                                                hintText: 'YYYY',
                                                hintStyle: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: "Lato",
                                                  fontWeight: FontWeight.w700,
                                                  color: ColorsApp.Grey2,
                                                ),
                                              ),
                                              readOnly: true,
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
                                                    _monthController.text =
                                                        picked.month
                                                            .toString()
                                                            .padLeft(2, '0');
                                                    _yearController.text =
                                                        picked.year.toString();
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _buildLabel("Select Gender"),
                                SizedBox(
                                  height: 5,
                                ),
                                DropdownButtonFormField<String>(
                                  value: _selectedGender,
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'Male', child: Text('Male')),
                                    DropdownMenuItem(
                                        value: 'Female', child: Text('Female')),
                                  ],
                                  hint: const Text('Select Gender'),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedGender = val;
                                    });
                                  },
                                  validator: (val) =>
                                      val == null ? 'Gender is required' : null,
                                  dropdownColor: ColorsApp.primarylight,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ColorsApp.white1,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: ColorsApp.Grey3),
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: ColorsApp.Grey3),
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    hintText: 'Select Gender',
                                    hintStyle: TextStyle(
                                      fontSize: 13,
                                      fontFamily: "Lato",
                                      fontWeight: FontWeight.w700,
                                      color: ColorsApp.Grey2,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.w700,
                                    color: ColorsApp.Grey1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitProfile,
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Lato",
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: ColorsApp.white,
                            backgroundColor: ColorsApp.primarydark,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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

Widget _buildTextField(
  TextEditingController controller,
  String hint,
  TextInputType inputType, {
  String? Function(String?)? validator,
}) {
  return SizedBox(
    height: 50,
    child: TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: validator,
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
          borderSide: BorderSide(color: ColorsApp.Grey3),
          borderRadius: BorderRadius.circular(11),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorsApp.Grey3),
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
