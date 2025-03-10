import 'package:bytebank/pages/investimentos.dart';
import 'package:bytebank/pages/main_dashboard.dart';
import 'package:bytebank/pages/sign_in_screen.dart';
import 'package:bytebank/pages/sign_up_screen.dart';
import 'package:bytebank/pages/splash_screen.dart';
import 'package:bytebank/pages/transactions.dart';
import 'package:bytebank/routes.dart';
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
          appBarTheme: AppBarTheme(
            backgroundColor: AppConstants.baseBlueBytebank,
            foregroundColor: AppConstants.baseOrangeBytebank,
          )),
      routes: {
        Routes.signUp: (context) => SignUpScreen(),
        Routes.signIn: (context) => SignInScreen(),
        Routes.transactions: (context) => TransactionsPage(),
        Routes.investimentos: (context) => InvestmentsPage(),
        Routes.outros: (context) => InvestmentsPage(),
      },
      home: SplashScreen(),
    );
  }
}
