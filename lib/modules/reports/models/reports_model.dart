import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalesModel {
  final DateTime dateTime;
  final double total;

  SalesModel({required this.dateTime, required this.total});
}

class SalesReport {
  final double total;
  final Timestamp date;

  SalesReport({required this.total, required this.date});

  static SalesReport fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return SalesReport(
      total: doc.data()!['total'].toDouble(),
      date: doc.data()!['finishedAt'],
    );
  }
}
