import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StockSakes extends ChangeNotifier {
  static String idDocument = "bandiis";
  final _businessCollection = _firestore.collection('business');

  Future<List<double>> getstockSales() async {
    cmv() async {
      double total = 0;

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
      return 3.0;
    }

    try {
      List<double> responses =
          await Future.wait([cmv(), currentStock(), sales()]);
      print('responses === $responses');
      return responses;
    } catch (e) {
      return Future.error(e);
    }
  }
}

final stockSalesReportProvider = Provider((ref) => StockSakes());
