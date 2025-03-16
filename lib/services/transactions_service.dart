import 'package:bytebank/config/dio_client.dart';
import 'package:intl/intl.dart';
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
    String? userId =
        (await SharedPreferences.getInstance()).getString('user_id');
    Response response = await _dioClient.dio.get('/$userId/transactions');

    List<dynamic> transacoesJson = response.data['result'] ?? [];

    // Se a API retornar vazia, usa o mock
    return transacoesJson.isEmpty
        ? mockTransactions
        : List<Map<String, dynamic>>.from(transacoesJson);
  }

  Future<Map<String, double>> agruparValoresPorTipo(
      List<dynamic> transacoes) async {
    await Future.delayed(Duration(seconds: 2));

    return transacoes.fold<Map<String, double>>({}, (map, transacao) {
      map[transacao['transactionType']] =
          (map[transacao['transactionType']] ?? 0) + transacao['amount'];
      return map;
    });
  }

  Future<Map<DateTime, Map<String, double>>> agruparTransacoesPorMes(
      List<Map<String, dynamic>> transacoes) async {
    Map<DateTime, Map<String, double>> transacoesAgrupadas = {};

    for (var transacao in transacoes) {
      DateTime data = DateTime.parse(transacao['date']);
      DateTime mesAno = DateTime(data.year, data.month);

      if (!transacoesAgrupadas.containsKey(mesAno)) {
        transacoesAgrupadas[mesAno] = {};
      }

      String tipo = transacao['transactionType'];
      double valor = transacao['amount'];

      transacoesAgrupadas[mesAno]![tipo] =
          (transacoesAgrupadas[mesAno]![tipo] ?? 0) + valor;
    }

    // Ordenando as chaves (mesAno) do mapa por mês e ano
    var sortedKeys = transacoesAgrupadas.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    // Reconstruindo o mapa ordenado
    Map<DateTime, Map<String, double>> transacoesOrdenadas = {};
    for (var key in sortedKeys) {
      transacoesOrdenadas[key] = transacoesAgrupadas[key]!;
    }

    return transacoesOrdenadas;
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
