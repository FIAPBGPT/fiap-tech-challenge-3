import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dio_client.dart';

class AuthService {
  final DioClient _dioClient = DioClient();

  Future<bool> login(String email, String password) async {
    print('Email: $email, Password: $password');
    print({
      'email': email,
      'password': password,
    });
    try {
      Response response = await _dioClient.dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      print("Response: ${response.data}");
      print("Response: ${response.data['message']}");
      print("Token: ${response.data['result']['token']}");

      if (response.data['message'] == 'Usuário Autenticado com Sucesso!') {
        print(response.data['result']['token']);
        String token = response.data['result']['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return true;
      }
    } catch (e) {
      print('Login failed: $e');
    }
    return false;
  }
}
