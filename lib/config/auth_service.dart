import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dio_client.dart';

class AuthService {
  final DioClient _dioClient = DioClient();

  Future<bool> login(String email, String password) async {
    try {
      Response response = await _dioClient.dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response.data['message'] == 'Usuário Autenticado com Sucesso!') {
        String token = response.data['result']['token'];
        String userId = response.data['result']['user_id'];

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', token);
        await prefs.setString('user_id', userId);

        return true;
      }
    } catch (e) {
      print('Login failed: $e');
    }

    return false;
  }

  // Method to retrieve token from SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Method to retrieve userId from SharedPreferences
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }
}
