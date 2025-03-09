import 'package:bytebank/pages/investimentos.dart';
import 'package:bytebank/pages/main_dashboard.dart';
import 'package:bytebank/pages/transactions.dart';
import 'package:bytebank/utils/app_routes.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ByteBank",
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: AppConstants.baseBlueBytebank,
            secondary: AppConstants.baseOrangeBytebank,
            tertiary: AppConstants.baseBackgroundBytebank,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: AppConstants.baseBlueBytebank,
            foregroundColor: AppConstants.baseOrangeBytebank,
          )),
      routes: {
        AppRoutes.TRANSACOES: (context) => TransactionsPage(),
        AppRoutes.INVESTIMENTOS: (context) => InvestmentsPage(),
        AppRoutes.OUTROS: (context) => InvestmentsPage(),
      },
      home: MainDashboard(),
    );
  }
}
