// import 'package:bytebank/routes.dart';
import 'package:bytebank/config/auth_service.dart';
import 'package:bytebank/pages/sign_in_screen.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final Dio dio = Dio();
  final AuthService authService = AuthService();

  String _errorMessage = '';
  bool _termsAccepted = false;

  void _register() async {
    setState(() => _isLoading = true);
    if (!_termsAccepted) {
      setState(() => _isLoading = false);
      setState(() => _errorMessage = 'É necessário aceitar o termos!');

      return;
    }

    try {
      Response response = await dio.post(
        '${AppConstants.apiBaseUrl}/api/users',
        data: {
          'username': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 201) {
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => SignInScreen(authService: authService)),
          (route) => false, // Removes all previous routes
        );
      } else {
        print('Erro ao cadastrar usuário: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro ao registrar o usuário. Tente novamente.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Cover
                Image.asset(
                  'assets/images/sign-up-cover.png',
                ),

                // Space
                SizedBox(height: 21),

                // Title
                Text(
                  'Preencha os campos abaixo para criar a sua conta corrente.',
                  style: TextStyle(
                    color: AppConstants.primary,
                    fontSize: 31,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                // Space
                SizedBox(height: 21),

                // Email field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nome',
                      style: TextStyle(
                        color: AppConstants.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                    SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Digite seu nome completo',
                        filled: true,
                        fillColor: AppConstants.fieldsBackround,
                        prefixIcon: Icon(
                          Icons.person,
                          color: AppConstants.primary,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: BorderSide(
                            color: AppConstants.fieldsBorders,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppConstants.link,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Space
                SizedBox(height: 21),

                // Email field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'E-mail',
                      style: TextStyle(
                        color: AppConstants.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                    SizedBox(height: 6),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Digite seu e-mail',
                        filled: true,
                        fillColor: AppConstants.fieldsBackround,
                        prefixIcon: Icon(
                          Icons.email,
                          color: AppConstants.primary,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide:
                              BorderSide(color: AppConstants.fieldsBorders),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppConstants.link,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Space
                SizedBox(height: 21),

                // Password field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Senha',
                      style: TextStyle(
                        color: AppConstants.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                    SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Digite sua senha',
                        filled: true,
                        fillColor: AppConstants.fieldsBackround,
                        prefixIcon: Icon(
                          Icons.password,
                          color: AppConstants.primary,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide:
                              BorderSide(color: AppConstants.fieldsBorders),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppConstants.link,
                          ),
                        ),
                      ),
                      obscureText: true,
                    ),
                  ],
                ),

                // Space
                SizedBox(height: 21),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      value: _termsAccepted,
                      activeColor: AppConstants.link,
                      onChanged: (bool? value) {
                        setState(() => _termsAccepted = value!);
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Li e estou ciente quanto às condições de tratamento dos meus dados'
                        ' conforme descrito na Política de Privacidade do banco.',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),

                // Space
                SizedBox(height: 21),

                // Error messages
                Builder(builder: (context) {
                  if (_errorMessage.isNotEmpty) {
                    return Text(
                      _errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),

                // Submit button
                ElevatedButton(
                  onPressed: _isLoading ? null : () => _register(),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 80,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    backgroundColor: AppConstants.submitButton,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Criar conta',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppConstants.submitButtonText,
                          ),
                        ),
                ),

                // Link to the Sign In Page
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Fazer login',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppConstants.link,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
