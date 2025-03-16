import 'package:bytebank/widgets/graficos/graficoPizza.dart';
import 'package:flutter/material.dart';
import '../services/transactions_service.dart';

class ResumoTransacoesPage extends StatefulWidget {
  @override
  _ResumoTransacoesPageState createState() => _ResumoTransacoesPageState();
}

class _ResumoTransacoesPageState extends State<ResumoTransacoesPage> {
  final TransactionsService _transactionsService = TransactionsService();
  late Future<List<Map<String, dynamic>>> _transactionsFuture;
  late Future<Map<String, double>> futureGraficoPizza;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = _transactionsService.loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resumo das Transações')),
      body: Center(
        child: Column(
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _transactionsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                print('tes: ${snapshot.data}');
                // Após carregar as transações, agrupar os valores por tipo e mês
                futureGraficoPizza =
                    _transactionsService.agruparValoresPorTipo(snapshot.data!);

                return Column(
                  children: [
                    FutureBuilder<Map<String, double>>(
                      future: futureGraficoPizza,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          // ignore: curly_braces_in_flow_control_structures
                          return CircularProgressIndicator();
                        return GraficoPizza(valores: snapshot.data!);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
