import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction.dart' as bytebank;

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<bytebank.Transaction>> getTransactions() async {
    QuerySnapshot snapshot = await _db.collection('transactions')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => bytebank.Transaction.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addTransaction(bytebank.Transaction transaction) async {
    await _db.collection('transactions').add(transaction.toMap());
  }

  Future<void> updateTransaction(bytebank.Transaction transaction) async {
    await _db.collection('transactions').doc(transaction.id).update(transaction.toMap());
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _db.collection('transactions').doc(transactionId).delete();
  }
}
