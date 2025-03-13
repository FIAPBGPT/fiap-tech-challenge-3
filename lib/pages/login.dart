import 'package:bytebank/config/auth_service.dart';
import 'package:bytebank/dialogs/login.dialog.dart';
import 'package:bytebank/dialogs/register.dialog.dart';
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
      appBar: _buildAppBar(),
      backgroundColor: AppConstants.background,
      body: Container(
        decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppConstants.baseBlueBytebank, AppConstants.fieldsBackround],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text(
            'Experimente mais liberdade no controle da sua vida financeira. Crie sua conta com a gente!',
            style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: AppConstants.baseBlackBytebank),
            textAlign: TextAlign.center,
          ),
          Image.asset('lib/assets/banner.png', height: 300),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: 'Já tenho conta',
                onPressed: () => Navigator.pushNamed(context, Routes.signIn),
                type: ButtonType.elevated,
                color: AppConstants.baseBlackBytebank,
              ),
              SizedBox(width: 16),
              CustomButton(
                text: 'Abrir conta',
                onPressed: () => Navigator.pushNamed(context, Routes.signUp),
                type: ButtonType.outlined,
                color: AppConstants.baseBlackBytebank,
              ),
              SizedBox(height: 16),
            ],
          )



            // Text(
            //   'Bem-vindo ao ByteBank App',
            //   style: TextStyle(fontSize: 21),
            //   textAlign: TextAlign.center,
            // ),
            // SizedBox(height: 45),
            // CustomButton(
            //   text: 'Já tenho conta',
            //   onPressed: () {
            //     Navigator.pushNamed(context, Routes.signIn);
            //   },
            //   type: ButtonType.elevated,
            //   color: AppConstants.baseBlackBytebank,
            // ),
            // SizedBox(height: 15),
            // CustomButton(
            //   text: 'Abrir conta',
            //   onPressed: () {
            //     Navigator.pushNamed(context, Routes.signUp);
            //   },
            //   type: ButtonType.outlined,
            //   color: AppConstants.baseBlackBytebank,
            // )
          ],
        ),
      ),
    );
  }

  
   AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppConstants.baseBlackBytebank,
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
