import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  String id;
  double amount;
  DateTime date;
  String category;
  String description;
  String receiptUrl;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.category,
    required this.description,
    required this.receiptUrl,
  });

  // Convert Firestore document to a Transaction object
  factory Transaction.fromFirestore(Map<String, dynamic> data) {
    return Transaction(
      id: data['id'],
      amount: data['amount'],
      date: (data['date'] as Timestamp).toDate(),
      category: data['category'],
      description: data['description'],
      receiptUrl: data['receiptUrl'],
    );
  }

  // Convert Transaction object to Firestore-compatible Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date,
      'category': category,
      'description': description,
      'receiptUrl': receiptUrl,
    };
  }
}
