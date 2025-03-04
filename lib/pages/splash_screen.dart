import 'package:bytebank/config/auth_service.dart';
import 'package:bytebank/pages/login.dart';
import 'package:bytebank/pages/sign_in_screen.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // For the delay

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();

    // Wait for 4 seconds, then navigate to LoginPage
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        // MaterialPageRoute(builder: (context) => LoginPage()),
        MaterialPageRoute(
            builder: (context) => SignInScreen(authService: authService)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.baseGreenBytebank, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/logo.png', width: 150), // Your logo
            SizedBox(height: 20),
            Text(AppConstants.appDev,
                style:
                    TextStyle(fontSize: 16, color: Colors.white)), // App Devs
            SizedBox(height: 20),
            CircularProgressIndicator(), // Loading indicator
          ],
        ),
      ),
    );
  }
}
