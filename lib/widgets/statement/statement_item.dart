import 'package:bytebank/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatementItem extends StatelessWidget {
  final Map<String, dynamic> transaction;

  static const Map<String, String> transactionTypes = {
    'credito': 'Crédito',
    'deposito': 'Depósito',
    'debito': 'Débito',
    'pix': 'PIX',
    'ted': 'TED',
    'tef': 'TEF'
  };

  static const Map<String, String> months = {
    '1': 'Janeiro',
    '2': 'Fevereiro',
    '3': 'Março',
    '4': 'Abril',
    '5': 'Maio',
    '6': 'Junho',
    '7': 'Julho',
    '8': 'Agosto',
    '9': 'Setembro',
    '10': 'Outubro',
    '11': 'Novembro',
    '12': 'Dezembro'
  };

  const StatementItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    DateTime transactionDate = DateTime.parse(transaction['date']);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month
              Text(
                months[DateFormat('M').format(transactionDate)]!,
                style: TextStyle(
                    color: AppConstants.baseGreenBytebank,
                    fontSize: 13,
                    height: 2),
              ),

              // Transaction Type
              Text(
                (transactionTypes[transaction['transactionType']])!,
                style: TextStyle(fontSize: 16, height: 2),
              ),

              // Amount
              Text(
                NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                    .format(transaction['amount']),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              // Space
              SizedBox(height: 6),

              // Line
              Divider(
                height: 1,
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: AppConstants.baseGreenBytebank,
              ),
            ],
          ),
        ),
        Text(
          DateFormat('dd/MM/yyyy').format(transactionDate),
          style: TextStyle(
            color: AppConstants.additionalInfoColor,
            fontSize: 13,
          ),
        )
      ],
    );
  }
}
