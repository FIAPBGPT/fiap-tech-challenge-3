import 'package:bytebank/app_colors.dart';
import 'package:bytebank/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';
  bool _termsAccepted = false;

  void _register() async {
    if (!_termsAccepted) {
      setState(() => _errorMessage = 'É necessário aceitar o termos!');

      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
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
                  'Preencha os campos abaixo para cria a sua conta corrente.',
                  style: TextStyle(
                    color: AppColors.primary,
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
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                    SizedBox(height: 6),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Digite seu nome completo',
                        filled: true,
                        fillColor: AppColors.fieldsBackround,
                        prefixIcon: Icon(
                          Icons.person,
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
                        prefixIcon: Icon(
                          Icons.email,
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
                      activeColor: AppColors.link,
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
                  onPressed: _register,
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
                    'Criar conta',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.submitButtonText,
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
