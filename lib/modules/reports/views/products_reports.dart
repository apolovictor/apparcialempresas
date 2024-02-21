import 'package:botecaria/modules/reports/models/reports_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../services/date_services.dart';
import '../controllers/reports_controller.dart';
import '../widgets/overlay_mixin.dart';
import 'bar_graph.dart';

class ProductsReport extends StatefulHookConsumerWidget {
  const ProductsReport({super.key});

  @override
  ConsumerState<ProductsReport> createState() => ProductsReportState();
}

class ProductsReportState extends ConsumerState<ProductsReport>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // return Container();
    var now = DateTime.now();
    final controller = ScrollController();

    List<Product> productList = ref.watch(productListReportsProvider);
    List<GlobalKey> stickKey = [
      for (var i = 0; i < productList.length; i++) GlobalKey()
    ];

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: LayoutBuilder(builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        return Container(
          width: width,
          height: height,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: controller,
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return Container(
                  width: width / 5,
                  height: height,
                  color: Colors.amberAccent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 9,
                        child: Bars(
                          controller: controller,
                          stickKey: stickKey
                              .firstWhere((e) => stickKey.indexOf(e) == index),
                          product: productList[index],
                          index: index,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          productList[index].name,
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 22),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        );
      }),
      // child: BarGraph(dataset: dataset),
    );
  }
}

class Bars extends StatefulHookConsumerWidget {
  Bars(
      {super.key,
      required this.controller,
      required this.stickKey,
      required this.product,
      required this.index});

  ScrollController controller;
  GlobalKey stickKey;
  Product product;
  int index;

  @override
  ConsumerState<Bars> createState() => _BarsState();
}

class _BarsState extends ConsumerState<Bars> with OverLayStateMixin {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      double height = constraints.maxHeight;

      Offset offset = Offset.zero;

      return Container(
        height: height,
        width: width,
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: AnimatedBuilder(
              animation: widget.controller,
              builder: (context, child) {
                return Container(
                  key: widget.stickKey,
                  color: Colors.white,
                  child: TapRegion(
                    onTapOutside: (_) => removeOverlay(),
                    // onTapInside: (_) {},
                    child: GestureDetector(
                      onTapDown: (details) {
                        final keyContext = widget.stickKey.currentContext;
                        if (keyContext != null) {
                          // widget is visible
                          final box =
                              keyContext.findRenderObject() as RenderBox;
                          offset = box.localToGlobal(Offset.zero);
                        }
                        setState(() {
                          removeOverlay();
                          if (offset != Offset.zero) {
                            toggleOverlay(
                              OverlayUI(
                                info: widget.product.name,
                                borderColor: Color(
                                    int.parse(widget.product.primaryColor)),
                              ),
                              offset,
                            );
                          }
                        });
                      },
                    ),
                  ),
                );
              }),
        ),
      );
    });
  }

  // Widget stickyBuilder(BuildContext context, GlobalKey key, double height) {
  //   return AnimatedBuilder(
  //     animation: widget.controller,
  //     builder: (context, child) {
  //       final keyContext = key.currentContext;
  //       if (keyContext != null) {
  //         // widget is visible
  //         final box = keyContext.findRenderObject() as RenderBox;
  //         final pos = box.localToGlobal(Offset.zero);
  //         print("pos === ${pos.dx}");
  //         return Positioned(
  //           top: box.size.height / 0.6,
  //           bottom: box.size.height / 2,
  //           left: pos.dx,
  //           // right: 50.0,
  //           width: box.size.width / 1.1,
  //           child: Material(
  //             child: Container(
  //               height: height / 4,
  //               alignment: Alignment.center,
  //               color: Colors.blueAccent,
  //               child: const Text(
  //                 "^ Nah I think you're okay",
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ),
  //           ),
  //         );
  //       }
  //       return Container();
  //     },
  //   );
  // }
}

class OverlayUI extends StatefulWidget {
  const OverlayUI({
    super.key,
    required this.info,
    required this.borderColor,
  });

  final String info;
  final Color borderColor;
  @override
  State<OverlayUI> createState() => _OverlayUIState();
}

class _OverlayUIState extends State<OverlayUI> {
  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: widget.borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Text(widget.info,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.black)),
    );
  }
}
