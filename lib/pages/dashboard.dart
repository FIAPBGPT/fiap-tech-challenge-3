import 'package:bytebank/dialogs/login.dialog.dart';
import 'package:bytebank/dialogs/register.dialog.dart';
import 'package:bytebank/forms/transaction-form.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/pages/chart.dart';
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
                      SizedBox(height: 10),
                      CustomButton(
                        text: 'Gráficos',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResumoTransacoesPage()),
                        ),
                        type: ButtonType.outlined,
                        color: AppConstants.baseBlackBytebank,
                      ),
                    ],
                  ),
                  Container(
                    height: 500,
                    child: DynamicDataTable(
                      onEdit: _edit,
                      onView: _view,
                      onDelete: _delete,
                    ),
                  ),
                  Container(
                    height: 400,
                    width: double.infinity,
                    child: TransactionCard(
                      title: 'Nova Transação',
                      child: TransactionForm(
                        isPage1: true,
                        userId: '67d20e3fea00f3c7cbf560af',
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
                  )
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
