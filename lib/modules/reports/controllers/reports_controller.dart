import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/reports_model.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StockSales extends ChangeNotifier {
  static String idDocument = "bandiis";
  final _businessCollection = _firestore.collection('business');

  Future<List<double>> getStockSales() async {
    cmv() async {
      double total = 0;
      var now = DateTime.now();

      var firstDayOfMonth = DateTime(now.year, now.month, 1);

      await _businessCollection
          .doc(idDocument)
          .collection('products')
          .get()
          .then((e) async {
        for (var i = 0; i < e.docs.length; i++) {
          await _businessCollection
              .doc(idDocument)
              .collection('products')
              .doc(e.docs[i].id)
              .collection('stockTransactions')
              .where('type', isEqualTo: 'out')
              .where('date', isGreaterThanOrEqualTo: firstDayOfMonth)
              .get()
              .then((value) {
            value.docs.forEach((element) {
              // print('element.data() ==== ${element.data()}');
              total += element.data()['unitPrice'] * element.data()['quantity'];
            });
            return total;
          });
        }
        return total;
      });
      return total;
    }

    currentStock() async {
      double total = 0;
      await _businessCollection
          .doc(idDocument)
          .collection('products')
          .where('quantity', isGreaterThan: 0)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          total +=
              element.data()['quantity'] * element.data()['price']['price'];
        });
      });
      return total;
    }

    sales() async {
      var now = DateTime.now();
      double total = 0;

      var firstDayOfMonth = DateTime(now.year, now.month, 1);
      await _businessCollection
          .doc(idDocument)
          .collection('orders')
          .where('finishedAt', isGreaterThanOrEqualTo: firstDayOfMonth)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          total += element.data()['total'];
        });
      });
      return total;
    }

    try {
      List<double> response =
          await Future.wait([cmv(), currentStock(), sales()]);
      print('response === $response');
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<SalesReport>> getSalesReport(Timestamp filter) async {
    try {
      return await _businessCollection
          .doc(idDocument)
          .collection('orders')
          .where('finishedAt', isGreaterThanOrEqualTo: filter)
          .get()
          .then((e) => e.docs.map((e) => SalesReport.fromDoc(e)).toList());
    } catch (e) {
      return Future.error(e);
    }
  }
}

final salesReportProvider = Provider((ref) => StockSales());
