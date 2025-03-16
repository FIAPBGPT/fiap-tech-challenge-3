// import 'package:bytebank/pages/investimentos.dart';
import 'package:bytebank/pages/main_dashboard.dart';
import 'package:bytebank/config/auth_service.dart';
import 'package:bytebank/pages/splash_screen.dart';
import 'package:bytebank/pages/sign_in_screen.dart';
import 'package:bytebank/pages/sign_up_screen.dart';
import 'package:bytebank/pages/transactions.dart';
import 'package:bytebank/providers/transaction.provider.dart';
import 'package:bytebank/routes.dart';
import 'package:bytebank/utils/constants.dart';
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
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: AppConstants.baseBlueBytebank,
            foregroundColor: AppConstants.baseOrangeBytebank,
          ),
        ),
        home: SplashScreen(),
        routes: {
          Routes.dashboard: (context) => MainDashboard(),
          Routes.signIn: (context) => SignInScreen(authService: authService),
          Routes.signUp: (context) => SignUpScreen(),
          Routes.transactions: (context) => TransactionsPage(),
          // Routes.investments: (context) => InvestmentsPage(),
          // Routes.outros: (context) => InvestmentsPage(),
        },
      ),
    );
  }
}
