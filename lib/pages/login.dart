import 'package:bytebank/config/auth_service.dart';
import 'package:bytebank/dialogs/login.dialog.dart';
import 'package:bytebank/dialogs/register.dialog.dart';
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
      appBar: _buildAppBar(),
      body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF004D61), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(
            'Experimente mais liberdade no controle da sua vida financeira. Crie sua conta com a gente!',
            style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          SizedBox(width: 16),
          Image.asset('lib/assets/banner.png', height: 300),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: 'Já tenho conta',
                onPressed: () => _showLoginDialog(context),
                type: ButtonType.elevated,
                color: AppConstants.baseBlackBytebank,
              ),
              SizedBox(height: 16),
              SizedBox(width: 16),
              CustomButton(
                text: 'Abrir conta',
                onPressed: () => _showRegisterDialog(context),
                type: ButtonType.outlined,
                color: AppConstants.baseBlackBytebank,
              ),
              SizedBox(height: 16),
            ],
          )
        ],
      ),
    ));
  }

  
   AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.green),
            onPressed: () => print('Menu button clicked'),
          ),
          Image.asset('lib/assets/logo_home.png', height: 50),
        ],
      ),
    );
  }
}
