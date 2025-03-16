import 'package:bytebank/config/auth_service.dart';
import 'package:bytebank/routes.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:bytebank/widgets/button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo ao ByteBank App',
              style: TextStyle(fontSize: 21),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 45),
            CustomButton(
              text: 'Já tenho conta',
              onPressed: () {
                Navigator.pushNamed(context, Routes.signIn);
              },
              type: ButtonType.elevated,
              color: AppConstants.baseBlackBytebank,
            ),
            SizedBox(height: 15),
            CustomButton(
              text: 'Abrir conta',
              onPressed: () {
                Navigator.pushNamed(context, Routes.signUp);
              },
              type: ButtonType.outlined,
              color: AppConstants.baseBlackBytebank,
            )
          ],
        ),
      ),
    );
  }
}
