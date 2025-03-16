import 'package:bytebank/config/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class TransactionsService {
  final DioClient _dioClient = DioClient();

  // Future<List<dynamic>> loadTransactions() async {
  //   String? userId = (await SharedPreferences.getInstance()).getString('user_id');
  //   Response response = await _dioClient.dio.get('/$userId/transactions');
  //   return response.data['result'] ?? [];
  // }

    Future<List<Map<String, dynamic>>> loadTransactions() async {
    String? userId = (await SharedPreferences.getInstance()).getString('user_id');
    Response response = await _dioClient.dio.get('/$userId/transactions');

    List<dynamic> transacoesJson = response.data['result'] ?? [];

    // Se a API retornar vazia, usa o mock
    return transacoesJson.isEmpty ? mockTransactions : List<Map<String, dynamic>>.from(transacoesJson);
  }

  Future<Map<String, double>> agruparValoresPorTipo(List<dynamic> transacoes) async {
    await Future.delayed(Duration(seconds: 2));

    return transacoes.fold<Map<String, double>>({}, (map, transacao) {
      map[transacao['transactionType']] = (map[transacao['transactionType']] ?? 0) + transacao['amount'];
      return map;
    });
  }

}

List<Map<String, dynamic>> mockTransactions = [
  {
    "id": "1",
    "userId": "teste",
    "amount": 30.0,
    "transactionType": "Crédito",
    "description": "Salário",
    "date": DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
  },
  {
    "id": "2",
    "userId": "teste",
    "amount": 100.0,
    "transactionType": "Pix",
    "description": "Pagamento do amigo",
    "date": DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
  },
  {
    "id": "3",
    "userId": "teste",
    "amount": 500.0,
    "transactionType": "Débito",
    "description": "Aluguel",
    "date": DateTime.now().subtract(Duration(days: 30)).toIso8601String(),
  },
  {
    "id": "4",
    "userId": "teste",
    "amount": 200.0,
    "transactionType": "Transferência",
    "description": "Investimento",
    "date": DateTime.now().subtract(Duration(days: 45)).toIso8601String(),
  },
];
