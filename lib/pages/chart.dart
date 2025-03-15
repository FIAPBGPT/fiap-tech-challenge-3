import 'package:bytebank/config/dio_client.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResumoTransacoesPage extends StatefulWidget {
  @override
  _ResumoTransacoesPageState createState() => _ResumoTransacoesPageState();
}

class _ResumoTransacoesPageState extends State<ResumoTransacoesPage> {
  late Future<Map<String, double>> futureData;
  final DioClient _dioClient = DioClient();
  List<dynamic> _transactions = [];

  Future<List<dynamic>> _loadTransactions() async {
    String? userId = (await SharedPreferences.getInstance()).getString('user_id');
    Response response = await _dioClient.dio.get('/$userId/transactions');
    return response.data['result'] ?? []; // Fallback empty list
  }

  Future<Map<String, double>> _agruparValoresPorTipo() async {
    await Future.delayed(Duration(seconds: 2));
    List<dynamic> transacoes = _transactions.isEmpty ? mockTransactions : _transactions;

    return transacoes.fold<Map<String, double>>({}, (map, transacao) {
      map[transacao.transactionType] = (map[transacao.transactionType] ?? 0) + transacao.amount;
      return map;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTransactions().then((response) => setState(() => _transactions = response));
    futureData = _agruparValoresPorTipo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resumo das Transações')),
      body: FutureBuilder<Map<String, double>>(
        future: futureData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          Map<String, double> valores = snapshot.data!;
          double total = valores.values.reduce((a, b) => a + b);
          List<String> tipos = valores.keys.toList();
          List<Color> cores = [
            AppConstants.baseOrangeBytebank,
            AppConstants.baseGreenBytebank,
            AppConstants.additionalInfoColor,
            AppConstants.accentColor
          ];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  child: PieChart(
                    PieChartData(
                      sections: valores.entries.map((entry) {
                        int index = tipos.indexOf(entry.key);
                        return PieChartSectionData(
                          value: entry.value,
                          title: '${((entry.value / total) * 100).toStringAsFixed(1)}%',
                          color: cores[index % cores.length],
                          radius: 70,
                          titleStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.baseBackgroundBytebank,
                          ),
                        );
                      }).toList(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 60,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  children: tipos.map((tipo) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 10, height: 10, color: cores[tipos.indexOf(tipo) % cores.length]),
                        SizedBox(width: 5),
                        Text('$tipo - ${valores[tipo]!.toInt()}'),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class Transaction {
  final String id;
  final String userId;
  final double amount;
  final String transactionType;
  final String description;
  final DateTime date;

  Transaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.transactionType,
    required this.description,
    required this.date,
  });
}

// Mock de Transações para fallback
List<Transaction> mockTransactions = [
  Transaction(id: "1", userId: "teste", amount: 30, transactionType: "credito", description: "Salário", date: DateTime.now().subtract(Duration(days: 2))),
  Transaction(id: "2", userId: "teste", amount: 100.00, transactionType: "pix", description: "Pagamento do amigo", date: DateTime.now().subtract(Duration(days: 1))),
];
