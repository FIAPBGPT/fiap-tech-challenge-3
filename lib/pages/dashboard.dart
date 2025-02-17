import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../providers/transaction.provider.dart';

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
