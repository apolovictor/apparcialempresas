import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
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

@Riverpod()
class GetSalesReport<bool> extends _$GetSalesReport {
  @override
  build() async {
    final date = DateTime.now();

    final daysToGenerate =
        date.difference(date.subtract(Duration(days: 32))).inDays;
    var days = List.generate(
        daysToGenerate, (i) => getDate(date.subtract(Duration(days: i))));
    days = days.reversed.toList();
    final timeStamp = dateTimetoTimeStamp(date.subtract(Duration(days: 32)));
    try {
      var response = await _businessCollection
          .doc(idDocument)
          .collection('orders')
          .where('finishedAt', isGreaterThanOrEqualTo: timeStamp)
          .get()
          .then((e) async {
        var result = e.docs.map((e) => SalesReport.fromDoc(e)).toList();
        var groupByDate = groupBy(result,
            (obj) => timeStampToDate(obj.date).toString().substring(0, 10));
        Map groupedAndSum = {};

        groupByDate.forEach((k, v) {
          groupedAndSum[k] = {
            'list': v,
            'totalSum': v.fold(0.00, (prev, element) {
              return prev + element.total;
            }),
          };
        });

        var max = 0.0;
        var theKey;
        groupedAndSum.entries.forEach((element) {
          if (element.value['totalSum'] > max) {
            max = element.value['totalSum'];
            theKey = element.key;
          }
        });

        for (var i = 0; i < days.length; i++) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // print(
            //     "item === ${getDate(days[i])} == ${groupedAndSum.containsKey(getDate(days[i]).toString().substring(0, 10)) ? groupedAndSum.entries.firstWhere((element) => element.key == getDate(days[i]).toString().substring(0, 10)).value['totalSum'] : 0}");

            ref.read(salesListProvider.notifier).add(SalesModel(
                dateTime: getDate(days[i]),
                total: groupedAndSum.containsKey(
                        getDate(days[i]).toString().substring(0, 10))
                    ? groupedAndSum.entries
                        .firstWhere((element) =>
                            element.key ==
                            getDate(days[i]).toString().substring(0, 10))
                        .value['totalSum']
                    : 0));
          });
        }

        return e.docs.map((e) => SalesReport.fromDoc(e)).toList();
      });
      // response.forEach((element) => print(element.total));

      print("response.length =========== ${response.length}");
      state = response.isNotEmpty ? true : false;
      // return response.isNotEmpty ? true : false;
    } catch (e) {
      print("e ======= $e");
      return Future.error(e);
    }
  }

  updateSalesList() async {
    final date = DateTime.now();

    final daysToGenerate =
        date.difference(date.subtract(Duration(days: 32))).inDays;
    var days = List.generate(
        daysToGenerate, (i) => getDate(date.subtract(Duration(days: i))));
    days = days.reversed.toList();
    final timeStamp = dateTimetoTimeStamp(date.subtract(Duration(days: 32)));
    try {
      var response = await _businessCollection
          .doc(idDocument)
          .collection('orders')
          .where('finishedAt', isGreaterThanOrEqualTo: timeStamp)
          .get()
          .then((e) async {
        var result = e.docs.map((e) => SalesReport.fromDoc(e)).toList();
        var groupByDate = groupBy(result,
            (obj) => timeStampToDate(obj.date).toString().substring(0, 10));
        Map groupedAndSum = {};

        groupByDate.forEach((k, v) {
          groupedAndSum[k] = {
            'list': v,
            'totalSum': v.fold(0.00, (prev, element) {
              return prev + element.total;
            }),
          };
        });

        var max = 0.0;
        var theKey;
        groupedAndSum.entries.forEach((element) {
          if (element.value['totalSum'] > max) {
            max = element.value['totalSum'];
            theKey = element.key;
          }
        });

        for (var i = 0; i < days.length; i++) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // print(
            //     "item === ${getDate(days[i])} == ${groupedAndSum.containsKey(getDate(days[i]).toString().substring(0, 10)) ? groupedAndSum.entries.firstWhere((element) => element.key == getDate(days[i]).toString().substring(0, 10)).value['totalSum'] : 0}");

            ref.read(salesListProvider.notifier).add(SalesModel(
                dateTime: getDate(days[i]),
                total: groupedAndSum.containsKey(
                        getDate(days[i]).toString().substring(0, 10))
                    ? groupedAndSum.entries
                        .firstWhere((element) =>
                            element.key ==
                            getDate(days[i]).toString().substring(0, 10))
                        .value['totalSum']
                    : 0));
          });
        }

        return e.docs.map((e) => SalesReport.fromDoc(e)).toList();
      });
      // response.forEach((element) => print(element.total));

      print("response.length =========== ${response.length}");
      state = response.isNotEmpty ? true : false;
      // return response.isNotEmpty ? true : false;
    } catch (e) {
      print("e ======= $e");
      return Future.error(e);
    }
  }

  // updateSalesList() async {
  //   final date = DateTime.now();

  //   final daysToGenerate =
  //       date.difference(date.subtract(Duration(days: 32))).inDays;
  //   var days = List.generate(
  //       daysToGenerate, (i) => getDate(date.subtract(Duration(days: i))));
  //   days = days.reversed.toList();
  //   final timeStamp = dateTimetoTimeStamp(date.subtract(Duration(days: 32)));
  //   ref.read(salesListProvider.notifier).clear();

  //   try {
  //     var response = await _businessCollection
  //         .doc(idDocument)
  //         .collection('orders')
  //         .where('finishedAt', isGreaterThanOrEqualTo: timeStamp)
  //         .get()
  //         .then((e) {
  //       var result = e.docs.map((e) => SalesReport.fromDoc(e)).toList();
  //       var groupByDate = groupBy(result,
  //           (obj) => timeStampToDate(obj.date).toString().substring(0, 10));
  //       Map groupedAndSum = {};

  //       groupByDate.forEach((k, v) {
  //         groupedAndSum[k] = {
  //           'list': v,
  //           'totalSum': v.fold(0.00, (prev, element) {
  //             return prev + element.total;
  //           }),
  //         };
  //       });

  //       var max = 0.0;
  //       var theKey;
  //       groupedAndSum.entries.forEach((element) {
  //         if (element.value['totalSum'] > max) {
  //           max = element.value['totalSum'];
  //           theKey = element.key;
  //         }
  //       });

  //       for (var i = 0; i < days.length; i++) {
  //         WidgetsBinding.instance.addPostFrameCallback((_) {
  //           print(
  //               "item === ${getDate(days[i])} == ${groupedAndSum.containsKey(getDate(days[i]).toString().substring(0, 10)) ? groupedAndSum.entries.firstWhere((element) => element.key == getDate(days[i]).toString().substring(0, 10)).value['totalSum'] : 0}");

  //           ref.refresh(salesListProvider.notifier).add(SalesModel(
  //               dateTime: getDate(days[i]),
  //               total: groupedAndSum.containsKey(
  //                       getDate(days[i]).toString().substring(0, 10))
  //                   ? groupedAndSum.entries
  //                       .firstWhere((element) =>
  //                           element.key ==
  //                           getDate(days[i]).toString().substring(0, 10))
  //                       .value['totalSum']
  //                   : 0));
  //         });
  //       }

  //       return e.docs.map((e) => SalesReport.fromDoc(e)).toList();
  //     });
  //     return response;
  //   } catch (e) {
  //     print("e ======= $e");
  //     return Future.error(e);
  //   }
  // }
}

@Riverpod()
class SalesList extends _$SalesList {
  @override
  List<SalesModel> build() => state = [];

  add(SalesModel item) async {
    // if (state.length < length) {
    state = [...state, item];
    // }
    return state;
  }

  void clear() => state.clear();
}

final salesReportNotifier = Provider((ref) => StockSales());

// class SalesListProvider extends StateNotifier<List<SalesModel>> {
//   SalesListProvider() : super([]);

//   addItem(SalesModel item) => state = [...state, item];
//   removeItem(SalesModel item) => state = state..remove(item);
//   clear() => state.clear();
// }

// final salesListNotifier =
//     StateNotifierProvider<SalesListProvider, List<SalesModel>>(
//         (ref) => SalesListProvider());
