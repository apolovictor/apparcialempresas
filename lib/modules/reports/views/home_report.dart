import 'package:botecaria/modules/home/views/overview.dart';
import 'package:botecaria/modules/home/views/tables.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/reports_controller.dart';
import '../models/reports_model.dart';
import 'products_reports.dart';
import 'sales.dart';
import 'sales_impl.dart';
import 'stock_sales.dart';

var timeToFilterNotifier = StateProvider((_) => 7);

class ReportScreen extends HookConsumerWidget {
  const ReportScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      double height = constraints.maxHeight;
      double width = constraints.maxWidth;
      final listStockSales = ref.watch(salesReportNotifier).getStockSales();

      listStockSales.then((value, {onError}) {
        List<Cogs> cogsList = value[0];
        List<Product> productList = value[1];
        double totalSales = value[2];
        List<ProductsSold> productSalesList = value[3];

        if (cogsList.isNotEmpty && ref.watch(cogsReportProvider).isEmpty) {
          cogsList.forEach((e) {
            ref.read(cogsReportProvider.notifier).add(e);
          });
        }
        if (productList.isNotEmpty &&
            ref.watch(productListReportsProvider).isEmpty) {
          productList.forEach((e) {
            ref.read(productListReportsProvider.notifier).add(e);
          });
        }
        if (ref.watch(totalSalesReportProvider) == 0.0) {
          ref.read(totalSalesReportProvider.notifier).add(totalSales);
        }
        if (ref.watch(productSalesReportProvider).isEmpty) {
          productSalesList.forEach((e) {
            ref.read(productSalesReportProvider.notifier).add(e);
          });
        }
      });

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
            child: Container(
              color: Colors.grey[50],
              height: height * 0.37,
              width: width * 0.42,
            ),
          ),
          Align(
            alignment: const Alignment(-1, 1),
            child: Container(
              color: Colors.white,
              height: height * 0.50,
              width: width * 0.564,
              child: ProductsReport(),
            ),
          ),
          Align(
            alignment: const Alignment(1, 1),
            child: Container(
              height: height * 0.60,
              width: width * 0.42,
              child: LayoutBuilder(builder: (context, constraints) {
                return StockSalesReport(
                    width: constraints.maxWidth, height: constraints.maxHeight);
              }),
            ),
          ),
        ],
      );
    });
  }
}
