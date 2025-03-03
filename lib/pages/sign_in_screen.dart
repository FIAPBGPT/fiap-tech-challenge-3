import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../routes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';

  void _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      Navigator.pushReplacementNamed(context, Routes.transactions);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                    color: AppColors.primary,
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
                        color: AppColors.primary,
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
                        fillColor: AppColors.fieldsBackround,
                        focusColor: AppColors.link,
                        prefixIcon: Icon(
                          Icons.email,
                          color: AppColors.primary,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: BorderSide(
                            color: AppColors.fieldsBorders,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.link,
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
                        color: AppColors.primary,
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
                        fillColor: AppColors.fieldsBackround,
                        prefixIcon: Icon(
                          Icons.password,
                          color: AppColors.primary,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide:
                              BorderSide(color: AppColors.fieldsBorders),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.link,
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
                      child: Text(
                        'Esqueci a senha!',
                        style: TextStyle(
                          fontSize: 21,
                          color: AppColors.link,
                          height: -1,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.link,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 80,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    backgroundColor: AppColors.submitButton,
                  ),
                  child: Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.submitButtonText,
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
                      color: AppColors.link,
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
