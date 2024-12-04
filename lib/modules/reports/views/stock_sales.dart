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
    double mainWidth = MediaQuery.of(context).size.width;
    AnimationController stockSalesController = useAnimationController();
    SequenceAnimation sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable:
                Tween<double>(begin: 0.0, end: mainWidth > 1366 ? 120 : 90),
            curve: Curves.bounceOut,
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 350),
            tag: 'cogs')
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: 24.0),
            curve: Curves.bounceOut,
            from: const Duration(milliseconds: 450),
            to: const Duration(milliseconds: 650),
            tag: 'cogsFontSizeTitle')
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: 20.0),
            curve: Curves.bounceOut,
            from: const Duration(milliseconds: 450),
            to: const Duration(milliseconds: 750),
            tag: 'cogsFontSize')
        .addAnimatable(
            animatable:
                Tween<double>(begin: 0.0, end: mainWidth > 1366 ? 150.0 : 130),
            curve: Curves.bounceOut,
            from: const Duration(milliseconds: 300),
            to: const Duration(milliseconds: 450),
            tag: 'stock')
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: 24.0),
            curve: Curves.bounceOut,
            from: const Duration(milliseconds: 550),
            to: const Duration(milliseconds: 750),
            tag: 'stockFontSizeTitle')
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: 20.0),
            curve: Curves.bounceOut,
            from: const Duration(milliseconds: 550),
            to: const Duration(milliseconds: 850),
            tag: 'stockFontSize')
        .addAnimatable(
            animatable:
                Tween<double>(begin: 0.0, end: mainWidth > 1366 ? 220 : 200),
            curve: Curves.bounceOut,
            from: const Duration(milliseconds: 400),
            to: const Duration(milliseconds: 650),
            tag: 'sales')
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: 24.0),
            curve: Curves.bounceOut,
            from: const Duration(milliseconds: 750),
            to: const Duration(milliseconds: 900),
            tag: 'salesFontSizeTitle')
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: 20.0),
            curve: Curves.bounceOut,
            from: const Duration(milliseconds: 750),
            to: const Duration(milliseconds: 1000),
            tag: 'salesFontSize')
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: height * 0.2),
            curve: Curves.bounceOut,
            from: const Duration(milliseconds: 750),
            to: const Duration(milliseconds: 1000),
            tag: 'salesTopPadding')
        //
        .animate(stockSalesController);

    List<Cogs> cogsList = ref.watch(cogsReportProvider);
    List<Product> productList = ref.watch(productListReportsProvider);
    double totalSales = ref.watch(totalSalesReportProvider);

    if (productList.isNotEmpty && cogsList.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        stockSalesController.forward();
      });

      double stockTotal = 0.0;
      double cogsTotal = 0.0;

      cogsList.forEach((e) {
        cogsTotal += e.quantity ?? 0 * e.unitPrice! ?? 0;
      });
      productList.forEach((e) {
        // print("element from stockSales ====  ${e.name}");
        stockTotal += e.quantity * e.price.price;
      });

      print(MediaQuery.of(context).size.width);
      // print(MediaQuery.of(context).size.height);
      return AnimatedBuilder(
          animation: stockSalesController,
          builder: (context, child) {
            return SizedBox(
              height: height,
              width: width,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(0.5, mainWidth > 1366 ? 0 : 0.2),
                    child: CircleAvatar(
                      radius: sequenceAnimation['sales'].value + 2,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: sequenceAnimation['sales'].value,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: sequenceAnimation['salesTopPadding']
                                      .value),
                              child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                      'R\$ ${totalSales.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          fontSize: sequenceAnimation[
                                                  'salesFontSizeTitle']
                                              .value,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600))),
                            ),
                            Material(
                                color: Colors.transparent,
                                child: Text('Receita Vendas',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            sequenceAnimation['salesFontSize']
                                                .value,
                                        fontWeight: FontWeight.w600))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(mainWidth > 1366 ? -0.5 : -1.0,
                        mainWidth > 1366 ? 0.5 : 0.75),
                    child: CircleAvatar(
                      radius: sequenceAnimation['stock'].value + 2,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: sequenceAnimation['stock'].value,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                                color: Colors.transparent,
                                child: Text(
                                    'R\$ ${stockTotal.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: sequenceAnimation[
                                                'stockFontSizeTitle']
                                            .value,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600))),
                            Material(
                                color: Colors.transparent,
                                child: Text('Estoque atual',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            sequenceAnimation['stockFontSize']
                                                .value,
                                        fontWeight: FontWeight.w600))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.3, 1),
                    child: CircleAvatar(
                      radius: sequenceAnimation['cogs'].value + 2,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: sequenceAnimation['cogs'].value,
                        backgroundColor: Colors.grey[200],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                                color: Colors.transparent,
                                child: Text(
                                    'R\$ ${cogsTotal.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: sequenceAnimation[
                                                'cogsFontSizeTitle']
                                            .value,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600))),
                            Material(
                                color: Colors.transparent,
                                child: Text('CMV',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            sequenceAnimation['cogsFontSize']
                                                .value,
                                        fontWeight: FontWeight.w600))),
                          ],
                        ),
                      ),
                    ),
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
