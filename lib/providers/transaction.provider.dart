// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction.dart' as bytebank;
import '../services/firestore.service.dart';

class TransactionProvider with ChangeNotifier {
  List<bytebank.Transaction> _transactions = [];
  final FirestoreService _firestoreService = FirestoreService();

  List<bytebank.Transaction> get transactions => _transactions;

  // Fetch transactions from Firestore
  Future<void> fetchTransactions() async {
    _transactions = await _firestoreService.getTransactions();
    notifyListeners();
  }

  // Add a new transaction
  Future<void> addTransaction(bytebank.Transaction transaction) async {
    await _firestoreService.addTransaction(transaction);
    _transactions.add(transaction);
    notifyListeners();
  }

  // Remove a transaction
  Future<void> removeTransaction(String transactionId) async {
    await _firestoreService.deleteTransaction(transactionId);
    _transactions.removeWhere((tx) => tx.id == transactionId);
    notifyListeners();
  }

  // Update an existing transaction
  Future<void> updateTransaction(bytebank.Transaction updatedTransaction) async {
    await _firestoreService.updateTransaction(updatedTransaction);
    int index = _transactions.indexWhere((tx) => tx.id == updatedTransaction.id);
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      notifyListeners();
    }
  }
}
