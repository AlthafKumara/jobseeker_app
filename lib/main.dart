import 'package:flutter/material.dart';
import 'package:jobseeker_app/views/auth/complete_hrd_profile_view.dart';
import 'package:jobseeker_app/views/auth/complete_society_profile.dart';
import 'package:jobseeker_app/views/auth/onboarding_view.dart';
import 'package:jobseeker_app/views/auth/signup_role_view.dart';
import 'package:jobseeker_app/views/auth/signup_view.dart';
import 'package:jobseeker_app/views/auth/splash_screen.dart';
import 'package:jobseeker_app/views/auth/login_view.dart';
import 'package:jobseeker_app/views/hrd_view/hrd_dashboard.dart';
import 'package:jobseeker_app/views/society_view/society_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        // AUTH
        '/splash': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingView(),
        '/login': (context) => LoginView(),
        '/signup': (context) => SignupView(),
        '/completesociety': (context) => CompleteSocietyProfilePage(),
        '/completehrd': (context) => CompleteHrdProfileView(),

        // DASHBOARD
        '/society_dashboard': (context) => SocietyDashboard(),
        '/hrd_dashboard': (context) => HrdDashboard(),
      },
    );
  }
}
