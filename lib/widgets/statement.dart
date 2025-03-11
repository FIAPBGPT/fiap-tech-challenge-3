import 'dart:ffi';

import 'package:bytebank/config/dio_client.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:bytebank/widgets/button.dart';
import 'package:bytebank/widgets/statement/statement_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Statement extends StatefulWidget {
  const Statement({super.key});

  @override
  State<Statement> createState() => _StatementState();
}

class _StatementState extends State<Statement> {
  final DioClient _dioClient = DioClient();
  List<dynamic> _transactions = [];
  List<dynamic> _filteredTransactions = [];
  int _sortDirection = 1;
  int _filterMode = 0;
  IconData _sortingIcon = Icons.arrow_downward;
  IconData _filteringIcon = Icons.sync_alt;

  Future<List<dynamic>> _loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('user_id');

    Response response = await _dioClient.dio.get(
      '/$user_id/transactions',
    );

    return response.data['result'];
  }

  void _sortTransactions() {
    setState(() {
      if (_sortDirection == 1) {
        _sortDirection = -1;
        _sortingIcon = Icons.arrow_downward;
      } else {
        _sortDirection = 1;
        _sortingIcon = Icons.arrow_upward;
      }

      _filteredTransactions.sort((a, b) {
        return b['date'].compareTo(a['date']) * _sortDirection;
      });
    });
  }

  // Icons.sync_alt, Icons.west, Icons.east
  void _filterTransactions() {
    setState(() {
      if (_filterMode == 0) {
        _filterMode = 1;
        _filteringIcon = Icons.east;

        _filteredTransactions = _transactions
            .where((transaction) => transaction['amount'] > 0)
            .toList();
      } else if (_filterMode == 1) {
        _filterMode = -1;
        _filteringIcon = Icons.west;

        _filteredTransactions = _transactions
            .where((transaction) => transaction['amount'] < 0)
            .toList();
      } else {
        _filterMode = 0;
        _filteringIcon = Icons.sync_alt;
        _filteredTransactions = _transactions.toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _loadTransactions().then((response) {
      setState(() {
        _transactions = response;
        _filteredTransactions = _transactions.toList();
      });

      _sortTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: AppConstants.cardLightBackground,
      child: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Extrato',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Sort Button
                CustomButton(
                  onPressed: _sortTransactions,
                  type: ButtonType.icon,
                  icon: _sortingIcon,
                  color: AppConstants.baseBlueBytebank,
                ),

                // Filter Button
                CustomButton(
                  onPressed: _filterTransactions,
                  type: ButtonType.icon,
                  icon: _filteringIcon,
                  color: AppConstants.baseBlueBytebank,
                ),
              ],
            ),

            // Items
            ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: _filteredTransactions.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(height: 12),
                    StatementItem(
                      transaction: _filteredTransactions[index],
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
