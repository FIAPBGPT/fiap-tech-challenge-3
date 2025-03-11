import 'package:bytebank/config/auth_service.dart';
import 'package:bytebank/pages/splash_screen.dart';
import 'package:bytebank/pages/dashboard.dart';
import 'package:bytebank/pages/sign_in_screen.dart';
import 'package:bytebank/pages/sign_up_screen.dart';
import 'package:bytebank/pages/transactions.dart';
import 'package:bytebank/providers/transaction.provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionProvider(),
      child: MaterialApp(
        title: 'Bytebank',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
        routes: {
          '/sign-in': (context) => SignInScreen(authService: authService),
          '/sign-up': (context) => SignUpScreen(),
          '/dashboard': (context) => DashboardPage(),
          '/transactions': (context) => TransactionsPage(),
        },
      ),
    );
  }
}
