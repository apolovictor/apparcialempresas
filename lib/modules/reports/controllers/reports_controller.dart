import 'dart:math';

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

  Future<List<ProductsSold>> getProductsSold() async {
    var now = DateTime.now();

    final timeStamp = dateTimetoTimeStamp(now.subtract(Duration(days: 32)));
    double total = 0;

    List<ProductsSold> response = [];
    await _businessCollection
        .doc(idDocument)
        .collection('detailOrders')
        .where('finishedAt', isGreaterThanOrEqualTo: timeStamp)
        .get()
        .then((value) {
      var result = value.docs.map((e) => ProductsSold.fromDoc(e)).toList();
      result.forEach((e) => response.add(e));
    });
    return response;
  }

  Future<List<Product>> getProducts() async {
    List<Product> response = [];
    await _businessCollection
        .doc(idDocument)
        .collection('products')
        .get()
        .then((value) {
      var result = value.docs.map((e) => Product.fromDoc(e)).toList();
      result.forEach((e) => response.add(e));
    });

    return response;
  }

  Future<List<Cogs>> getCogs() async {
    var now = DateTime.now();

    final timeStamp = dateTimetoTimeStamp(now.subtract(Duration(days: 32)));
    double total = 0;

    List<Cogs> response = [];
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
            .where('date', isGreaterThanOrEqualTo: timeStamp)
            .get()
            .then((value) async {
          var result = value.docs.map((e) => Cogs.fromDoc(e)).toList();

          result.forEach((e) => response.add(e));
        });
      }
    });
    return response;
  }

//

  Future<double> getStockSales() async {
    var now = DateTime.now();

    final timeStamp = dateTimetoTimeStamp(now.subtract(Duration(days: 32)));
    double total = 0;

    await _businessCollection
        .doc(idDocument)
        .collection('orders')
        .where('finishedAt', isGreaterThanOrEqualTo: timeStamp)
        .get()
        .then((value) {
      value.docs.forEach((e) {
        // print(e.data());
        total += e.data()['total'];
      });
    });
    return total;
  }
//   Future<List<dynamic>> getStockSales() async {
//     sales() async {
//       var now = DateTime.now();

//       final timeStamp = dateTimetoTimeStamp(now.subtract(Duration(days: 32)));
//       double total = 0;

//       await _businessCollection
//           .doc(idDocument)
//           .collection('orders')
//           .where('finishedAt', isGreaterThanOrEqualTo: timeStamp)
//           .get()
//           .then((value) {
//         value.docs.forEach((e) {
//           // print(e.data());
//           total += e.data()['total'];
//         });
//       });
//       return total;
//     }

//     try {
//       List<dynamic> response = await Future.wait([sales()]);
//       return response;
//     } catch (e) {
//       return Future.error(e);
//     }
//   }
}

@Riverpod()
class GetSalesReport<bool> extends _$GetSalesReport {
  @override
  build() async {
    final now = DateTime.now();

    final daysToGenerate =
        now.difference(now.subtract(Duration(days: 32))).inDays;
    var days = List.generate(
        daysToGenerate, (i) => getDate(now.subtract(Duration(days: i))));
    days = days.reversed.toList();
    final timeStamp = dateTimetoTimeStamp(now.subtract(Duration(days: 32)));
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

      // print("response.length =========== ${response.length}");
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

      // print("response.length =========== ${response.length}");
      state = response.isNotEmpty ? true : false;
      // return response.isNotEmpty ? true : false;
    } catch (e) {
      print("e ======= $e");
      return Future.error(e);
    }
  }
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

@Riverpod()
class ProductListReports extends _$ProductListReports {
  @override
  List<Product> build() => state = [];

  add(Product item, int length) async {
    if (state.length < length) {
      state = [...state, item];
    }
    return state;
  }

  void clear() => state = [];
}

@Riverpod()
class CogsReport extends _$CogsReport {
  @override
  List<Cogs> build() => state = [];

  add(Cogs item, int length) async {
    if (state.length < length) {
      state = [...state, item];
    }
    return state;
  }

  void clear() => state = [];
}

@Riverpod()
class TotalSalesReport extends _$TotalSalesReport {
  @override
  double build() => state = 0.0;

  add(double total) async {
    // if (state.length < length) {
    state = total;
    // }
    return state;
  }

  void clear() => state = 0.0;
}

@Riverpod()
class ProductSalesReport extends _$ProductSalesReport {
  @override
  List<ProductsSold> build() => state = [];

  add(ProductsSold item, int length) async {
    if (state.length < length) {
      state = [...state, item];
    }
    return state;
  }

  void clear() => state.clear();
}

// @Riverpod()
// class ProductsReports extends _$ProductsReports {
//   @override
//   List<Product> build() => state = [];

// add(Product item) async {
//   // if (state.length < length) {
//   state = [...state, item];
//   // }
//   return state;
// }

// void clear() => state.clear();
// }

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
