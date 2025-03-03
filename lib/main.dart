import 'package:bytebank/pages/dashboard.dart';
import 'package:bytebank/pages/sign_in_screen.dart';
import 'package:bytebank/pages/sign_up_screen.dart';
import 'package:bytebank/pages/transactions.dart';
import 'package:bytebank/providers/transaction.provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
        initialRoute: '/sign-in',
        routes: {
          '/sign-in': (context) => SignInScreen(),
          '/sign-up': (context) => SignUpScreen(),
          '/transactions': (context) => TransactionsPage(),
        },
      ),
    );
  }
}
