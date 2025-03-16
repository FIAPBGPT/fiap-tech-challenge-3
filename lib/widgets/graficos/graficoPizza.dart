import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:bytebank/utils/constants.dart';

class GraficoPizza extends StatelessWidget {
  final Map<String, double> valores;

  const GraficoPizza({Key? key, required this.valores}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double total = valores.values.reduce((a, b) => a + b);
    List<Color> cores = [
      AppConstants.baseOrangeBytebank,
      AppConstants.baseGreenBytebank,
      AppConstants.additionalInfoColor,
      AppConstants.accentColor
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text("Distribuição por Tipo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sections: valores.entries.map((entry) {
                  int index = valores.keys.toList().indexOf(entry.key);
                  return PieChartSectionData(
                    value: entry.value,
                    title: '${((entry.value / total) * 100).toStringAsFixed(1)}%',
                    color: cores[index % cores.length],
                    radius: 70,
                    titleStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.baseBackgroundBytebank,
                    ),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 60,
              ),
            ),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: valores.keys.map((tipo) {
              int index = valores.keys.toList().indexOf(tipo);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 10, height: 10, color: cores[index % cores.length]),
                  SizedBox(width: 5),
                  Text('$tipo - ${valores[tipo]!.toInt()}'),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
