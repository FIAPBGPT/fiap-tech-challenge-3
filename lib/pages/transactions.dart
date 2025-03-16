// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction.provider.dart';
import '../models/transaction.dart';
import '../widgets/transaction_card.dart';
import '../services/file_upload.service.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transactions")),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Add Filter options
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () => _addTransaction(context),
                        child: Text("Add Transaction")),
                    ElevatedButton(
                        onPressed: () => _filterTransactions(context),
                        child: Text("Filter")),
                  ],
                ),
              ),

              // Transaction List
              Expanded(
                child: ListView.builder(
                  itemCount: provider.transactions.length,
                  itemBuilder: (context, index) {
                    Transaction tx = provider.transactions[index];
                    return null;
                    // return TransactionCard(
                    //   transaction: tx,
                    //   onDelete: () => provider.removeTransaction(tx.id),
                    // );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _addTransaction(BuildContext context) async {
    // Example to add a transaction
    Transaction newTx = Transaction(
      id: "unique_id_123",
      amount: 100.0,
      category: 'Food',
      description: 'Grocery Shopping',
      date: DateTime.now(),
      receiptUrl: "",
    );
    await Provider.of<TransactionProvider>(context, listen: false)
        .addTransaction(newTx);
  }

  _filterTransactions(BuildContext context) {
    // Implement filter logic here
  }
}
