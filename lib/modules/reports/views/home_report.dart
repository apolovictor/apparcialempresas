import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../products/controller/products_notifier.dart';
import '../controllers/reports_controller.dart';
import '../models/reports_model.dart';
import 'nightingale_chart.dart';
import 'products_reports.dart';
import 'sales_impl.dart';
import 'stock_sales.dart';

// var timeToFilterNotifier = StateProvider((_) => 7);

class ReportScreen extends HookConsumerWidget {
  const ReportScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      double height = constraints.maxHeight;
      double width = constraints.maxWidth;
      final listStockSales = ref.watch(salesReportNotifier).getStockSales();
      final firestoreProductsSold =
          ref.watch(salesReportNotifier).getProductsSold();
      final List<ProductsSold> stateProductsSold =
          ref.watch(productSalesReportProvider);
      final firestoreProductList = ref.watch(salesReportNotifier).getProducts();
      final List<Product> stateProductsList =
          ref.watch(productListReportsProvider);
      final firestoreCogsList = ref.watch(salesReportNotifier).getCogs();
      final List<Cogs> stateCogsList = ref.watch(cogsReportProvider);
      List<CategoriesReportModel> categoriesReport = [];

      categoriesReport.clear();

      Future.wait([
        firestoreProductsSold.then((value) {
          if (stateProductsSold.length != value.length) {
            ref.read(productSalesReportProvider.notifier).clear();
            value.forEach((e) {
              ref
                  .read(productSalesReportProvider.notifier)
                  .add(e, value.length);
            });
          } else {
            return;
          }
        }),
        firestoreProductList.then((value) {
          if (stateProductsList.length != value.length) {
            ref.read(productListReportsProvider.notifier).clear();
            value.forEach((e) {
              ref
                  .read(productListReportsProvider.notifier)
                  .add(e, value.length);
            });
          } else {
            return;
          }
        }),
        firestoreCogsList.then((value) {
          if (stateCogsList.length != value.length) {
            ref.read(cogsReportProvider.notifier).clear();
            value.forEach((e) {
              ref.read(cogsReportProvider.notifier).add(e, value.length);
            });
          } else {
            return;
          }
        }),
        listStockSales.then(
            (value) => ref.read(totalSalesReportProvider.notifier).add(value))
      ]);

      // listStockSales.then((value, {onError}) {
      //   List<Cogs> cogsList = value[0];
      //   List<Product> productList = value[1];
      //   double totalSales = value[2];

      //   if (cogsList.isNotEmpty && ref.watch(cogsReportProvider).isEmpty) {
      //     cogsList.forEach((e) {
      //       ref.read(cogsReportProvider.notifier).add(e);
      //     });
      //   }
      //   if (productList.isNotEmpty &&
      //       ref.watch(productListReportsProvider).isEmpty) {
      //     productList.forEach((e) {
      //       ref.read(productListReportsProvider.notifier).add(e);
      //     });
      //   }
      //   if (ref.watch(totalSalesReportProvider) == 0.0) {
      //     ref.read(totalSalesReportProvider.notifier).add(totalSales);
      //   }
      // });

      final categories = ref.watch(categoriesNotifier).value;
      if (categories != null && stateProductsSold.isNotEmpty) {
        for (var category in categories) {
          var result = stateProductsSold
              .where(
                  (element) => element.productCategory == category.documentId)
              .map((e) => e.price)
              .reduce((value, e) => e + value);
          categoriesReport.add(CategoriesReportModel(
              total: result,
              productCategory: category.name,
              color: Color(pal[categories.indexOf(category)])));
        }
      }

      return Stack(
        children: [
          Align(
            alignment: const Alignment(-1, -1),
            child: Container(
                height: height * 0.47,
                width: width * 0.564,
                decoration:
                    const BoxDecoration(color: Colors.white, border: Border()),
                child: const SalesImpl()),
          ),
          Align(
            alignment: const Alignment(1, -1),
            child: SizedBox(
              height: height * 0.37,
              width: width * 0.42,
              child: LayoutBuilder(builder: (context, constraints) {
                return categoriesReport.isNotEmpty
                    ? NightingaleChart(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        radius: 200,
                        strokeWidth: 2,
                        categoriesReport: categoriesReport)
                    : const SizedBox();
              }),
              // child: CategoriesReport(),
            ),
          ),
          Align(
            alignment: const Alignment(-1, 1),
            child: Container(
              color: Colors.white,
              height: height * 0.50,
              width: width * 0.564,
              child: stateProductsSold.isNotEmpty &&
                      stateProductsList.isNotEmpty &&
                      stateCogsList.isNotEmpty
                  ? const ProductsReport()
                  : const SizedBox(),
            ),
          ),
          Align(
            alignment: const Alignment(1, 1),
            child: Container(
              height: height * 0.60,
              width: width * 0.42,
              child: LayoutBuilder(builder: (context, constraints) {
                return
                    // const  SizedBox();

                    StockSalesReport(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight);
              }),
            ),
          ),
        ],
      );
    });
  }
}
