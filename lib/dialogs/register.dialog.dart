import 'package:bytebank/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RegisterDialog extends StatefulWidget {
  const RegisterDialog({super.key});

  @override
  _RegisterDialogState createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Dio dio = Dio();
  bool isLoading = false;

  void register() async {
    setState(() => isLoading = true);

    try {
      Response response = await dio.post(
        '${AppConstants.apiBaseUrl}/api/users',
        data: {
          'username': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 201) {
        // Close the dialog
        Navigator.pop(context);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cadastro realizado com sucesso!')),
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
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cadastrar Usuário'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Nome'),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : register,
          child: isLoading ? CircularProgressIndicator() : Text('Cadastrar'),
        ),
      ],
    );
  }
}
