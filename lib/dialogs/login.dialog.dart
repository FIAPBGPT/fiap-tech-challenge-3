import 'package:bytebank/config/auth_service.dart';
import 'package:bytebank/pages/dashboard.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:bytebank/widgets/button.dart';
import 'package:flutter/material.dart';

class LoginDialog extends StatefulWidget {
  final AuthService authService;

  const LoginDialog({super.key, required this.authService});

  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    bool success = await widget.authService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pop(); // Close modal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Realizado com Sucesso!')),
      );
      // Navigate to Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else {
      setState(() => _errorMessage = 'Email ou Senha inválido(a).');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('lib/assets/login-form-image.png', width: 150),
          SizedBox(height: 20),
          Text(
            'Login!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Senha'),
            obscureText: true,
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Close modal
          child: Text('Cancelar'),
        ),
        // ElevatedButton(
        //   onPressed: _isLoading ? null : () => _handleLogin(),
        //   child: _isLoading ? CircularProgressIndicator() : Text('Criar conta'),
        // ),
        CustomButton(
          text: _isLoading ? CircularProgressIndicator() : 'Criar conta',
          onPressed: _isLoading ? null : () => _handleLogin(),
          type: ButtonType.elevated,
          color: AppConstants.baseOrangeBytebank,
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
