import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/reports_controller.dart';
import '../models/reports_model.dart';

class StockSalesReport extends HookConsumerWidget {
  const StockSalesReport(
      {super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AnimationController stockSalesController = useAnimationController();
    SequenceAnimation sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: width * 0.85),
            curve: Curves.bounceOut,
            from: const Duration(milliseconds: 450),
            to: const Duration(milliseconds: 650),
            tag: 'widthSales')
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: height * 0.85),
            curve: Curves.bounceOut,
            from: const Duration(milliseconds: 450),
            to: const Duration(milliseconds: 650),
            tag: 'heightSales')
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: width * 0.57),
            curve: Curves.bounceOut,
            from: const Duration(milliseconds: 200),
            to: const Duration(milliseconds: 450),
            tag: 'widthCurrentStock')
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: height * 0.57),
            curve: Curves.bounceOut,
            from: const Duration(milliseconds: 200),
            to: const Duration(milliseconds: 450),
            tag: 'heightCurrentStock')
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: width * 0.45),
            curve: Curves.bounceOut,
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 250),
            tag: 'widthCmv')
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: height * 0.45),
            curve: Curves.bounceOut,
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 250),
            tag: 'heightCmv')
        .animate(stockSalesController);

    List<Cogs> cogsList = ref.watch(cogsReportProvider);
    List<Product> productList = ref.watch(productListReportsProvider);
    double totalSales = ref.watch(totalSalesReportProvider);

    if (productList.isNotEmpty && cogsList.isNotEmpty) {
      // print("productList ==== ${productList.length}");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        stockSalesController.forward();
      });

      double stockTotal = 0.0;
      double cogsTotal = 0.0;

      cogsList.forEach((e) {
        cogsTotal += e.quantity * e.unitPrice;
      });
      productList.forEach((e) {
        // print("element from stockSales ====  ${e.name}");
        stockTotal += e.quantity * e.price.price;
      });
      return AnimatedBuilder(
          animation: stockSalesController,
          builder: (context, child) {
            return Container(
              height: height,
              width: width,
              child: Stack(
                children: [
                  Align(
                    alignment: const Alignment(0, -1),
                    child: Container(
                      width: sequenceAnimation['widthSales'].value,
                      height: sequenceAnimation['heightSales'].value,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, -0.6),
                    child: Material(
                        color: Colors.transparent,
                        child: Text('R\$ ${totalSales.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 26,
                                color: Colors.white,
                                fontWeight: FontWeight.w600))),
                  ),
                  const Align(
                    alignment: Alignment(0, -0.5),
                    child: Material(
                        color: Colors.transparent,
                        child: Text('Receita Vendas',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600))),
                  ),
                  Align(
                    alignment: const Alignment(-1, 0.3),
                    child: Container(
                      width: sequenceAnimation['widthCurrentStock'].value,
                      height: sequenceAnimation['heightCurrentStock'].value,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black87,
                          border: Border.all(width: 2, color: Colors.white)),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(-0.5, 0),
                    child: Material(
                        color: Colors.transparent,
                        child: Text('R\$ ${stockTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 26,
                                color: Colors.white,
                                fontWeight: FontWeight.w600))),
                  ),
                  const Align(
                    alignment: Alignment(-0.5, 0.1),
                    child: Material(
                        color: Colors.transparent,
                        child: Text('Estoque atual',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600))),
                  ),
                  Align(
                    alignment: const Alignment(0, 1),
                    child: Container(
                      width: sequenceAnimation['widthCmv'].value,
                      height: sequenceAnimation['heightCmv'].value,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          border: Border.all(width: 2, color: Colors.white)),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, 0.5),
                    child: Material(
                        color: Colors.transparent,
                        child: Text('R\$ ${cogsTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 26,
                                color: Colors.black,
                                fontWeight: FontWeight.w600))),
                  ),
                  const Align(
                    alignment: Alignment(0, 0.6),
                    child: Material(
                        color: Colors.transparent,
                        child: Text('CMV',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w600))),
                  ),
                ],
              ),
            );
          });
    } else {
      return const SizedBox();
    }
  }
}
