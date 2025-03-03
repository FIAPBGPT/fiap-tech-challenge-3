import 'package:bytebank/config/auth_service.dart';
import 'package:bytebank/dialogs/login.dialog.dart';
import 'package:bytebank/dialogs/register.dialog.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService authService = AuthService();

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LoginDialog(authService: authService),
    );
  }

  void _showRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => RegisterDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Bem vindo ao ByteBank App'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showLoginDialog(context),
            child: Text('Login'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showRegisterDialog(context),
            child: Text('Cadastrar'),
          ),
        ],
      ),
    );
  }
}
