import 'package:bytebank/forms/transaction-form.dart';
import 'package:bytebank/pages/weather_screen.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:bytebank/widgets/balance_card.dart';
import 'package:bytebank/widgets/card.dart';
import 'package:bytebank/widgets/menu/drawer.dart';
import 'package:bytebank/widgets/statement.dart';
import 'package:bytebank/widgets/transaction_card.dart';
import 'package:flutter/material.dart';

class MainDashboard extends StatelessWidget {
  MainDashboard({super.key});
  @override
  Widget build(BuildContext context) {
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
      body: Container(
        color: AppConstants.baseBackgroundBytebank,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BalanceCard(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: SizedBox(
                    height: 520,
                    width: double.infinity,
                    child: TransactionCard(
                      title: 'Nova Transação',
                      child: TransactionForm(onSubmit:
                          (String name, double amount, DateTime date) {
                        print('Transaction Form: $name, $amount, $date');
                      }),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Statement(),
                  ),
                ),
                Card(
                  color: AppConstants.cardLightBackground,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      width: double.infinity,
                      child: CreditCardWidget()),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: WeatherScreen(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final DateTime date;
  final double amount;

  ChartData(this.date, this.amount);
}
