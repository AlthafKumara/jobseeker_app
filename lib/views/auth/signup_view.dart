import 'package:flutter/material.dart';
import 'package:jobseeker_app/widgets/colors.dart';
import '../../models/signup_data.dart';
import 'signup_role_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isEmailValid = true;
  String? _emailErrorText;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void _goToNextStep() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validate email format
    if (!_isValidEmail(email)) {
      setState(() {
        _isEmailValid = false;
        _emailErrorText = 'Please enter a valid email address';
      });
      return;
    } else {
      setState(() {
        _isEmailValid = true;
        _emailErrorText = null;
      });
    }

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar('All fields are required', isError: true);
      return;
    }
    if (password.length < 8) {
      _showSnackBar('Password must be at least 8 characters long',
          isError: true);
      return;
    }

    final signupData = SignupData(name: name, email: email, password: password);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SignupRoleView(signUpData: signupData),
      ),
    );
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/bg_auth.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset("assets/image/Logo.png", height: 50),
                const SizedBox(height: 24),
                const Text(
                  'Create Your Workscout Account',
                  style: TextStyle(
                    fontFamily: "Lato",
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Join Workscout to find your perfect job. Create an account for personalized matches and career resources.',
                  style: TextStyle(
                    fontFamily: "Lato",
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 64),

                // Name Field
                _buildLabel("Full Name"),
                _buildTextField(_nameController, "Please enter your full name",
                    TextInputType.name),

                const SizedBox(height: 18),

                // Email Field
                _buildLabel("Email"),
                _buildTextField(_emailController,
                    "Please enter your email address", TextInputType.emailAddress, isEmail: true),

                // Email validation error message
                if (_emailErrorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _emailErrorText!,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w400,
                        color: Colors.red,
                      ),
                    ),
                  ),

                const SizedBox(height: 18),

                // Password Field
                _buildLabel("Password"),
                Container(
                  height: 50,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.w700,
                      color: ColorsApp.Grey1,
                    ),
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
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
                      hintText: 'Please enter your password',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w700,
                        color: ColorsApp.Grey2,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: ColorsApp.primarydark,
                          size: 17,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Password must be at least 8 characters long",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w700,
                    color: ColorsApp.Grey2,
                  ),
                ),
                const SizedBox(height: 20),

                // NEXT BUTTON
                ElevatedButton(
                  onPressed: _isLoading ? null : _goToNextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsApp.primarydark,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: "Lato",
                            color: ColorsApp.Grey4,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 12),

                // Link ke login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Lato",
                        color: ColorsApp.Grey1,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: ColorsApp.primarydark,
                          fontSize: 13,
                          fontFamily: "Lato",
                          fontWeight: FontWeight.w600,
                          color: ColorsApp.primarydark,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontFamily: "Lato",
        fontWeight: FontWeight.w700,
        color: ColorsApp.black,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      TextInputType inputType, {bool isEmail = false}) {
    return Container(
      height: 50,
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        onChanged: isEmail ? (value) {
          // Validate email as user types
          if (value.isNotEmpty) {
            if (!_isValidEmail(value)) {
              setState(() {
                _isEmailValid = false;
                _emailErrorText = 'Please enter a valid email address';
              });
            } else {
              setState(() {
                _isEmailValid = true;
                _emailErrorText = null;
              });
            }
          } else {
            setState(() {
              _emailErrorText = null;
            });
          }
        } : null,
        style: TextStyle(
          fontSize: 13,
          fontFamily: "Lato",
          fontWeight: FontWeight.w700,
          color: ColorsApp.Grey1,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: isEmail && !_isEmailValid ? Colors.red.withOpacity(0.1) : ColorsApp.white1,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isEmail && !_isEmailValid ? Colors.red : ColorsApp.Grey3,
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isEmail && !_isEmailValid ? Colors.red : ColorsApp.Grey3,
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
