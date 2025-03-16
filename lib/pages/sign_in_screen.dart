import 'package:bytebank/config/auth_service.dart';
import 'package:bytebank/pages/dashboard.dart';
import 'package:bytebank/pages/main_dashboard.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:flutter/material.dart';
import '../routes.dart';

class SignInScreen extends StatefulWidget {
  final AuthService authService;

  const SignInScreen({super.key, required this.authService});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  String _errorMessage = '';

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    bool success = await widget.authService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Realizado com Sucesso!')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainDashboard(),
        ),
        (route) => false, // Removes all previous routes
      );
    } else {
      setState(() => _errorMessage = 'Email ou Senha inválido(a).');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Cover
                Image.asset(
                  'assets/images/login-cover.png',
                ),

                // Space
                SizedBox(height: 21),

                // Title
                Text(
                  'Login',
                  style: TextStyle(
                    color: AppConstants.primary,
                    fontSize: 33,
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
                        focusColor: AppConstants.link,
                        prefixIcon: Icon(
                          Icons.email,
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
                    TextButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(0),
                        ),
                      ),
                      onPressed: () {
                        print('Esqueci a senha!');
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Esqueci a senha!',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppConstants.link,
                              height: -1,
                              decoration: TextDecoration.underline,
                              decorationColor: AppConstants.link,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                    ),
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

                // Sign In Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : () => _handleLogin(),
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
                          'Entrar',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppConstants.submitButtonText,
                          ),
                        ),
                ),

                // Link to the Sign Up Page
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.signUp);
                  },
                  child: Text(
                    'Crie uma conta',
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
