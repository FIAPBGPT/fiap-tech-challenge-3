import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ResumoTransacoesPage extends StatelessWidget {
  final List<double> valores = [1200, 800, 1500, 500, 1800, 700, 1300];
  final List<Color> cores = [
    Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.yellow, Colors.teal
  ];

  @override
  Widget build(BuildContext context) {
    double total = valores.reduce((a, b) => a + b);

    return Scaffold(
      appBar: AppBar(title: Text('Resumo das Transações')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 300, // Ajuste do tamanho do gráfico
                child: PieChart(
                  PieChartData(
                    sections: valores.asMap().entries.map((entry) {
                      int index = entry.key;
                      double valor = entry.value;
                      return PieChartSectionData(
                        value: valor,
                        title: '${((valor / total) * 100).toStringAsFixed(1)}%',
                        color: cores[index],
                        radius: 60,
                        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      );
                    }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40, 
                  ),
                ),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children: List.generate(valores.length, (index) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 10, height: 10, color: cores[index]),
                      SizedBox(width: 5),
                      Text('D${index + 1} - ${valores[index].toInt()}'),
                    ],
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
