import 'package:bytebank/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Modelo de Transação
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

/// Mock de Transações
List<Transaction> mockTransactions = [
  Transaction(id: "1", userId: "user123", amount: 1500.50, transactionType: "credito", description: "Salário", date: DateTime.now().subtract(Duration(days: 2))),
  Transaction(id: "2", userId: "user123", amount: 100.00, transactionType: "pix", description: "Pagamento do amigo", date: DateTime.now().subtract(Duration(days: 1))),
  Transaction(id: "3", userId: "user456", amount: 500.75, transactionType: "debito", description: "Compra no mercado", date: DateTime.now()),
  Transaction(id: "4", userId: "user123", amount: 200.00, transactionType: "pix", description: "Transferência", date: DateTime.now().subtract(Duration(days: 3))),
  Transaction(id: "5", userId: "user789", amount: 700.00, transactionType: "credito", description: "Freelance", date: DateTime.now().subtract(Duration(days: 4))),
];

class ResumoTransacoesPage extends StatefulWidget {
  @override
  _ResumoTransacoesPageState createState() => _ResumoTransacoesPageState();
}

class _ResumoTransacoesPageState extends State<ResumoTransacoesPage> {
  late Future<Map<String, double>> futureData;
  final List<Color> cores = [
    AppConstants.baseBackgroundBytebank, AppConstants.baseGreenBytebank, AppConstants.baseOrangeBytebank, AppConstants.accentColor
  ];

  @override
  void initState() {
    super.initState();
    futureData = _agruparValoresPorTipo();
  }

  Future<Map<String, double>> _agruparValoresPorTipo() async {
    await Future.delayed(Duration(seconds: 2)); 
    Map<String, double> mapaValores = {};

    for (var transacao in mockTransactions) {
      mapaValores[transacao.transactionType] =
          (mapaValores[transacao.transactionType] ?? 0) + transacao.amount;
    }

    return mapaValores;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resumo das Transações')),
      body: FutureBuilder<Map<String, double>>(
        future: futureData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          Map<String, double> valores = snapshot.data!;
          double total = valores.values.fold(0, (a, b) => a + b);
          List<String> tipos = valores.keys.toList();

          return Center(
            child: Padding(
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
                            titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppConstants.baseBackgroundBytebank),
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
                    children: List.generate(tipos.length, (index) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 10, height: 10, color: cores[index % cores.length]),
                          SizedBox(width: 5),
                          Text('${tipos[index]} - ${valores[tipos[index]]!.toInt()}'),
                        ],
                      );
                    }),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
