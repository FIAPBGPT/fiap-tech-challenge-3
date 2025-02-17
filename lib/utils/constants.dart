import 'package:flutter/material.dart';

class AppConstants {
  // App colors
  static const Color primaryColor = Color(0xFF4CAF50); // Green color
  static const Color secondaryColor = Color(0xFF2196F3); // Blue color
  static const Color accentColor = Color(0xFFFFC107); // Amber color
  
  // Text styles
  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle subHeaderTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black54,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );

  // Default padding values
  static const EdgeInsets pagePadding = EdgeInsets.all(16.0);
  
  // Other app constants
  static const String appName = "Bank Transactions";
  static const String welcomeMessage = "Welcome to your Dashboard!";
}
