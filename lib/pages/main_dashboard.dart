import 'package:bytebank/config/auth_service.dart';
import 'package:bytebank/forms/transaction-form.dart';
import 'package:bytebank/pages/chart.dart';
import 'package:bytebank/pages/weather_screen.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:bytebank/utils/constants_keys.dart';
import 'package:bytebank/widgets/balance_card.dart';
import 'package:bytebank/widgets/button.dart';
import 'package:bytebank/widgets/card.dart';
import 'package:bytebank/widgets/menu/drawer.dart';
import 'package:bytebank/widgets/statement.dart';
import 'package:bytebank/widgets/transaction_card.dart';
import 'package:bytebank/widgets/weather-widget.dart';
import 'package:flutter/material.dart';

class MainDashboard extends StatelessWidget {
  MainDashboard({super.key});
  AuthService authService = AuthService();
  String? token;
  String? userId;
  @override
  Widget build(BuildContext context) {
    _initializeAsyncDependencies();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "",
                  textAlign: TextAlign.center,
                ),
                const Icon(
                  Icons.account_circle_outlined,
                  size: 35,
                ),
              ],
            ),
          ),
        ),
        toolbarHeight: 60,
      ),
      drawer: DrawerComponent(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                BalanceCard(),

                /**
                   * ---------------------------
                   * The Transaction Widget
                   * ---------------------------
                   */
                Container(
                  height: 400,
                  width: double.infinity,
                  child: TransactionCard(
                    title: 'Nova Transação',
                    child: TransactionForm(
                      isPage1: true,
                      userId: userId ?? '',
                      pageName: 'DashboardPage',
                      formMode: 'add',
                      doExtraAction: () => print('Extra Action'),
                    ),
                  ),
                ),

                /**
                   * ---------------------------
                   * The Statement Widget
                   * ---------------------------
                   */
                Container(
                  height: 600,
                  width: double.infinity,
                  child: Statement(),
                ),

                /**
                   * ---------------------------
                   * The Weather Widget
                   * ---------------------------
                   */
                Container(
                  height: 350,
                  width: double.infinity,
                  child: WeatherWidget(
                    apiKey: ConstantsKeys.MY_APY_KEY,
                  ),
                ),
                /**
                   * ---------------------------
                   * The Credit Card Widget
                   * ---------------------------
                   */
                Card(
                  color: AppConstants.cardLightBackground,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      width: double.infinity,
                      child: CreditCardWidget()),
                ),
                Card(
                  color: AppConstants.cardLightBackground,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Visualizar Gráficos',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResumoTransacoesPage()),
                      ),
                      type: ButtonType.outlined,
                      color: AppConstants.baseBlackBytebank,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _initializeAsyncDependencies() async {
    token = await authService.getToken();
    userId = await authService.getUserId();
  }
}
