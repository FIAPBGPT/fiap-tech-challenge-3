import 'package:bytebank/pages/dashboard.dart';
import 'package:bytebank/pages/transactions.dart';
import 'package:bytebank/providers/transaction.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionProvider(),
      child: MaterialApp(
        title: 'Bank Transactions',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DashboardPage(),
        routes: {
          '/transactions': (context) => TransactionsPage(),
        },
      ),
    );
  }
}
