import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../providers/transaction.provider.dart';
import '../widgets/button.dart';
import '../utils/constants.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Welcome to My App!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            //  CustomButton(
            //   text: 'Elevated Button',
            //   onPressed: () => print('Elevated Button Pressed'),
            //   type: ButtonType.elevated,
            // ),
            // SizedBox(height: 10),

            // CustomButton(
            //   text: 'Outlined Button',
            //   onPressed: () => print('Outlined Button Pressed'),
            //   type: ButtonType.outlined,
            //   color: Colors.red,
            // ),
            // SizedBox(height: 10),

            // CustomButton(
            //   text: 'Text Button',
            //   onPressed: () => print('Text Button Pressed'),
            //   type: ButtonType.text,
            //   color: Colors.green,
            // ),

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

            // Add Lottie Animation
            Lottie.asset(
              'lib/assets/animations/financial_animation.json', // Path to your JSON file
              width: 200,
              height: 200,
              fit: BoxFit.fill, // Adjust the fit of the animation
            ),

            SizedBox(height: 20), // Add spacing between the animation and chart

            // Financial Chart
            Expanded(
              child: Consumer<TransactionProvider>(
                builder: (context, provider, child) {
                  if (provider.transactions.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // Create chart data from transaction data
                  List<ChartData> chartData = provider.transactions
                      .map((tx) => ChartData(tx.date, tx.amount))
                      .toList();

                  return SfCartesianChart(
                    primaryXAxis: DateTimeAxis(),
                    primaryYAxis: NumericAxis(),
                    series: <CartesianSeries>[
                      LineSeries<ChartData, DateTime>(
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.date,
                        yValueMapper: (ChartData data, _) => data.amount,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
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
