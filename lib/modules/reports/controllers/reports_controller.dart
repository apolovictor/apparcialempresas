import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../services/date_services.dart';
import '../models/reports_model.dart';
import '../views/sales_impl.dart';

part 'reports_controller.g.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
String idDocument = "bandiis";
final _businessCollection = _firestore.collection('business');

class StockSales extends ChangeNotifier {
  // static String idDocument = "bandiis";
  // final _businessCollection = _firestore.collection('business');

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
}

@riverpod
Future<List<SalesReport>> getSalesReport(GetSalesReportRef ref) async {
  int timeToFilter = ref.watch(timeToFilterNotifier);
  final date = DateTime.now();
  final timeStamp =
      dateTimetoTimeStamp(date.subtract(Duration(days: timeToFilter)));
  final daysToGenerate =
      date.difference(date.subtract(Duration(days: timeToFilter))).inDays;
  var days = List.generate(
      daysToGenerate, (i) => getDate(date.subtract(Duration(days: i))));
  days = days.reversed.toList();

  try {
    print("idDocument ========= $idDocument");
    List<SalesReport> response = await _businessCollection
        .doc(idDocument)
        .collection('orders')
        .where('finishedAt', isGreaterThanOrEqualTo: timeStamp)
        .get()
        .then((e) {
      print("e ========== ${e.docs}");
      print("eeeee ========== ${e.docs.map((e) => SalesReport.fromDoc(e))}}");

      return e.docs.map((e) => SalesReport.fromDoc(e)).toList();
    });

    return response;
  } catch (e) {
    print("e ======= $e");
    return Future.error(e);
  }
}

final salesReportNotifier = Provider((ref) => StockSales());

class SalesListProvider extends StateNotifier<List<SalesModel>> {
  SalesListProvider() : super([]);

  addItem(SalesModel item) => state = [...state, item];
  removeItem(SalesModel item) => state = state..remove(item);
  clear() => state.clear();
}

final salesListNotifier =
    StateNotifierProvider<SalesListProvider, List<SalesModel>>(
        (ref) => SalesListProvider());
