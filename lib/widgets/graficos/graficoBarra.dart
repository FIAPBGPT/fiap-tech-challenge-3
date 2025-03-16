import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ColumnChart extends StatelessWidget {
  final Map<DateTime, Map<String, double>> dadosAgrupados;

  ColumnChart({required this.dadosAgrupados});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Adicionando um padding ao redor
      child: Column(
        children: [
          // Texto acima do gráfico
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0), // Espaçamento entre o texto e o gráfico
            child: Text(
              "Distribuição por Mês",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          
          // O gráfico de colunas
          AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                barGroups: _buildBarGroups(),
                titlesData: _buildTitles(),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói os grupos de barras do gráfico
  List<BarChartGroupData> _buildBarGroups() {
    List<BarChartGroupData> barGroups = [];
    int index = 0;

    dadosAgrupados.forEach((mes, transacoes) {
      List<BarChartRodData> bars = transacoes.entries.map((entry) {
        return BarChartRodData(
          toY: entry.value, // Valor da transação
          color: _getColorForType(entry.key), // Cor baseada no tipo
          width: 12,
          borderRadius: BorderRadius.circular(4),
        );
      }).toList();

      barGroups.add(BarChartGroupData(x: index, barRods: bars));
      index++;
    });

    return barGroups;
  }

  /// Configuração dos rótulos do eixo X
  FlTitlesData _buildTitles() {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: true, reservedSize: 40),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            int index = value.toInt();
            if (index >= dadosAgrupados.keys.length) return Container();

            DateTime mes = dadosAgrupados.keys.elementAt(index);
            return Text(DateFormat('MMM').format(mes), style: TextStyle(fontSize: 12));
          },
          reservedSize: 28,
        ),
      ),
    );
  }

  /// Define cores para cada tipo de transação
  Color _getColorForType(String tipo) {
    switch (tipo) {
      case "Crédito":
        return Colors.green;
      case "Débito":
        return Colors.red;
      case "Pix":
        return Colors.blue;
      case "Transferência":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
