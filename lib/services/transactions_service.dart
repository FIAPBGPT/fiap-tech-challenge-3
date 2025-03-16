import 'package:bytebank/config/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class TransactionsService {
  final DioClient _dioClient = DioClient();

  Future<List<Map<String, dynamic>>> loadTransactions() async {
    String? userId =
        (await SharedPreferences.getInstance()).getString('user_id');
    Response response = await _dioClient.dio.get('/$userId/transactions');

    List<dynamic> transacoes = response.data['result'] ?? [];

    // Se a API retornar vazia, usa o mock
    return transacoes.isEmpty
        ? mockTransactions
        : List<Map<String, dynamic>>.from(transacoes);
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

  await Future.delayed(Duration(seconds: 2));

  for (var transacao in transacoes) {
    try {
      print("Processando transação: $transacao");

      DateTime data = DateTime.parse(transacao['date']);
      DateTime mesAno = DateTime(data.year, data.month);
      print("Data da transação: $data, Mês/Ano: $mesAno");

      if (!transacoesAgrupadas.containsKey(mesAno)) {
        transacoesAgrupadas[mesAno] = {};
      }

      String tipo = transacao['transactionType'];


      double valor = (transacao['amount'] is int)
          ? (transacao['amount'] as int).toDouble()
          : transacao['amount'] as double;

      transacoesAgrupadas[mesAno]![tipo] =
          (transacoesAgrupadas[mesAno]![tipo] ?? 0) + valor;
    } catch (e) {
      print("Erro ao processar transação: $e");
    }
  }

  var sortedKeys = transacoesAgrupadas.keys.toList()
    ..sort((a, b) => a.compareTo(b));

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
