import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // API
  static String apiBaseUrl = dotenv.get(
    'API_URL',
    fallback: 'http://10.0.2.2:5000',
  );

  // App colors
  static const Color primaryColor = Color(0xFF4CAF50); // Green color
  static const Color secondaryColor = Color(0xFF2196F3); // Blue color
  static const Color accentColor = Color(0xFFFFC107); // Amber color
  static const Color baseBlueBytebank = Color(0xff004d61);
  static const Color baseGreenBytebank = Color(0xff47a138);
  static const Color baseOrangeBytebank = Color(0xffff5031);
  static const Color baseBlackBytebank = Color(0xff000000);
  static const Color baseBackgroundBytebank = Color(0xffE4EDE3);
  static const Color baseDarkGreyBytebank = Color(0xffcbcbcb);

  static const Color primary = Colors.black;
  static const Color background = Color(0xFFE4EDE3);
  static const Color fieldsBackround = Colors.white;
  static const Color fieldsBorders = Color(0xFFDEE9EA);
  static const Color link = Color(0xFF47A138);
  static const Color shadow = Colors.black12;
  static const Color error = Colors.red;
  static const Color submitButton = Color(0xFFFF5031);
  static const Color submitButtonText = Colors.white;
  static const Color additionalInfoColor = Color(0xFF8B8B8B);
  static const Color cardLightBackground = Colors.white;

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

  static const TextStyle menuTextStyle = TextStyle(
    fontSize: 18,
    fontFamily: "Inter",
    fontWeight: FontWeight.w400,
    color: primary,
  );

  static const TextStyle weatherTextStyle = TextStyle(
    fontSize: 16,
    fontFamily: "Inter",
  );

  static const TextStyle weatherSubtitStyle = TextStyle(
    fontSize: 18,
    shadows: [
      Shadow(
        color: Color(0x89000000),
        offset: Offset(0, 0.1),
        blurRadius: 1,
      ),
    ],
    fontFamily: "Inter",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle weatherTitStyle = TextStyle(
    fontSize: 25,
    shadows: [
      Shadow(
        color: Color(0x89000000),
        offset: Offset(0, 0.3),
        blurRadius: 1,
      ),
    ],
    fontFamily: "Inter",
    fontWeight: FontWeight.bold,
  );

  // Default padding values
  static const EdgeInsets pagePadding = EdgeInsets.all(16.0);

  // Other app constants
  static const String appName = "Bytebank";
  static const String welcomeMessage = "Bem vindo(a) ao Bytebank!";
  static const String appDev = "Desenvolvido pelo melhor grupo de todos :)!";
}
