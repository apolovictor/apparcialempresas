import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalesModel {
  final Offset offset;
  final String weekDays;
  final double? total;

  SalesModel({required this.offset, required this.weekDays, this.total});
}

class SalesReport {
  final double total;
  final Timestamp date;

  SalesReport({required this.total, required this.date});

  static SalesReport fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return SalesReport(
      total: doc.data()!['total'],
      date: doc.data()!['finishedAt'],
    );
  }
}
