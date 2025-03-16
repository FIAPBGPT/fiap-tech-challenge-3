import 'package:bytebank/forms/transaction-form.dart';
import 'package:bytebank/widgets/balance_card.dart';
import 'package:bytebank/widgets/card.dart';
import 'package:bytebank/widgets/paginated-grid.dart';
import 'package:bytebank/widgets/statement.dart';
import 'package:bytebank/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
// Import Lottie package
import '../widgets/button.dart';
import '../utils/constants.dart';

class DashboardPage extends StatelessWidget {
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

  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.background,
      body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Welcome to My App!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  Wrap(
                    spacing: 5, // Space between buttons
                    runSpacing: 5, // Space between lines
                    children: [
                      CustomButton(
                        text: '',
                        onPressed: () => print('BTN EDIT'),
                        type: ButtonType.icon,
                        icon: Icons.edit,
                        color: AppConstants.baseBlueBytebank,
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        text: '',
                        onPressed: () => print('BTN DELETE'),
                        type: ButtonType.icon,
                        icon: Icons.delete,
                        color: AppConstants.baseBlueBytebank,
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        text: 'Concluir transação',
                        onPressed: () => print('Elevated Button Pressed'),
                        type: ButtonType.elevated,
                        color: AppConstants.baseBlueBytebank,
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        text: 'Botão laranja',
                        onPressed: () => print('Elevated Button Pressed'),
                        type: ButtonType.elevated,
                        color: AppConstants.baseOrangeBytebank,
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        text: 'Botão outlined laranja',
                        onPressed: () => print('Elevated Button Pressed'),
                        type: ButtonType.outlined,
                        color: AppConstants.baseOrangeBytebank,
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        text: 'Botão verde',
                        onPressed: () => print('Elevated Button Pressed'),
                        type: ButtonType.elevated,
                        color: AppConstants.baseGreenBytebank,
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        text: 'Botão verde outlined',
                        onPressed: () => print('Outlined Button Pressed'),
                        type: ButtonType.outlined,
                        color: AppConstants.baseGreenBytebank,
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        text: 'Botão preto',
                        onPressed: () => print('Elevated Button Pressed'),
                        type: ButtonType.elevated,
                        color: AppConstants.baseBlackBytebank,
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        text: 'Botão preto outlined',
                        onPressed: () => print('Outlined Button Pressed'),
                        type: ButtonType.outlined,
                        color: AppConstants.baseBlackBytebank,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),

                  // Wrap(
                  //   children: [GridScreen(data: userData)],
                  // ),

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
                  SizedBox(
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

                  // // Add Lottie Animation
                  // Lottie.asset(
                  //   'lib/assets/animations/financial_animation.json', // Path to your JSON file
                  //   width: 200,
                  //   height: 200,
                  //   fit: BoxFit.fill, // Adjust the fit of the animation
                  // ),

                  // SizedBox(height: 20), // Add spacing between the animation and chart

                  // // Financial Chart
                  // Expanded(
                  //   child: Consumer<TransactionProvider>(
                  //     builder: (context, provider, child) {
                  //       if (provider.transactions.isEmpty) {
                  //         return Center(child: CircularProgressIndicator());
                  //       }

                  //       // Create chart data from transaction data
                  //       List<ChartData> chartData = provider.transactions
                  //           .map((tx) => ChartData(tx.date, tx.amount))
                  //           .toList();

                  //       return SfCartesianChart(
                  //         primaryXAxis: DateTimeAxis(),
                  //         primaryYAxis: NumericAxis(),
                  //         series: <CartesianSeries>[
                  //           LineSeries<ChartData, DateTime>(
                  //             dataSource: chartData,
                  //             xValueMapper: (ChartData data, _) => data.date,
                  //             yValueMapper: (ChartData data, _) => data.amount,
                  //           ),
                  //         ],
                  //       );
                  //     },
                  //   ),
                  // ),

                  /**
                   * ---------------------------
                   * The Statement Widget
                   * ---------------------------
                   */
                  Statement(),
                  BalanceCard(),
                  CreditCardWidget()
                ],
              ),
            ),
          )),
    );
  }
}

class ChartData {
  final DateTime date;
  final double amount;

  ChartData(this.date, this.amount);
}
