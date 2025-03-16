import 'package:bytebank/forms/transaction-form.dart';
import 'package:bytebank/pages/weather_screen.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:bytebank/widgets/balance_card.dart';
import 'package:bytebank/widgets/card.dart';
import 'package:bytebank/widgets/menu/drawer.dart';
import 'package:bytebank/widgets/paginated-grid.dart';
import 'package:bytebank/widgets/statement.dart';
import 'package:bytebank/widgets/transaction_card.dart';
import 'package:flutter/material.dart';

class MainDashboard extends StatelessWidget {
  final List<Map<String, dynamic>> userData = [
    {"id": 1, "name": "John Doe", "email": "john@example.com"},
    {"id": 2, "name": "Jane Smith", "email": "jane@example.com"},
    {"id": 3, "name": "Bob Johnson", "email": "bob@example.com"},
  ];
  final List<Map<String, dynamic>> users = [
    {"ID": 1, "Name": "Alice Brown", "Email": "alice@example.com"},
    {"ID": 2, "Name": "Bob Smith", "Email": "bob@example.com"},
    {"ID": 3, "Name": "Charlie Johnson", "Email": "charlie@example.com"},
    {"ID": 4, "Name": "David Lee", "Email": "david@example.com"},
  ];

  void _edit(Map<String, dynamic> user) {
    print("Edit user: ${user["Name"]}");
  }

  void _view(Map<String, dynamic> user) {
    print("View user: ${user["Name"]}");
  }

  void _delete(Map<String, dynamic> user) {
    print("Delete user: ${user["Name"]}");
  }

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
                SizedBox(
                  height: 500,
                  child: DynamicDataTable(
                    data: users,
                    columnNames: ["ID", "Name", "Email"], // Dynamic Columns
                    onEdit: _edit,
                    onView: _view,
                    onDelete: _delete,
                  ),
                ),
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
                  child: Container(
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
