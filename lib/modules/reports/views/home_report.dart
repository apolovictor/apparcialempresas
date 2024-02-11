import 'package:apparcialempresas/modules/home/views/overview.dart';
import 'package:apparcialempresas/modules/home/views/tables.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'sales.dart';
import 'stock_sales.dart';

class ReportScreen extends HookConsumerWidget {
  const ReportScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      double height = constraints.maxHeight;
      double width = constraints.maxWidth;

      return Stack(
        children: [
          Align(
            alignment: const Alignment(-1, -1),
            child: Container(
              color: Color(0xFF1c1727),
              height: height * 0.47,
              width: width * 0.564,
              child: const Sales()
            ),
          ),
          Align(
            alignment: const Alignment(1, -1),
            child: Container(
              color: Colors.grey[100],
              height: height * 0.37,
              width: width * 0.42,
            ),
          ),
          Align(
            alignment: const Alignment(-1, 1),
            child: Container(
              color: Colors.grey[100],
              height: height * 0.50,
              width: width * 0.564,
            ),
          ),
          Align(
            alignment: const Alignment(1, 1),
            child: Container(
              height: height * 0.60,
              width: width * 0.42,
              child: LayoutBuilder(builder: (context, constraints) {
                return StockSales(
                    width: constraints.maxWidth, height: constraints.maxHeight);
              }),
            ),
          ),
        ],
      );
    });
  }
}
