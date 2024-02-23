import 'package:botecaria/modules/reports/models/reports_model.dart';
import 'package:botecaria/modules/reports/views/animated_bars.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/reports_controller.dart';
import '../widgets/overlay_mixin.dart';

class ProductsReport extends HookConsumerWidget {
  const ProductsReport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ScrollController();

    List<Product> productList = ref.watch(productListReportsProvider);
    List<Cogs> cogsList = ref.watch(cogsReportProvider);
    List<ProductsSold> productSalesList = ref.watch(productSalesReportProvider);

    var newMapCogs = groupBy(cogsList, (Cogs obj) => obj.idDocument);
    var newMapProductSales =
        groupBy(productSalesList, (ProductsSold obj) => obj.productDocument);

    List<GlobalKey> stickKey = [
      for (var i = 0; i < productList.length; i++) GlobalKey()
    ];

    print("productList.length === ${productList.length}");
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: LayoutBuilder(builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        return SizedBox(
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
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 9,
                        child: Bar(
                            controller: controller,
                            stickKey: stickKey.firstWhere(
                                (e) => stickKey.indexOf(e) == index),
                            product: productList[index],
                            index: index,
                            newMapCogs: newMapCogs,
                            newMapProductSales: newMapProductSales),
                      ),
                      Expanded(
                          flex: 3,
                          child: AnimatedBars(
                              product: productList[index],
                              width: width,
                              height: height)),
                    ],
                  ),
                );
              }),
        );
      }),
    );
  }
}

// class ProductsReport2 extends StatefulHookConsumerWidget {
//   const ProductsReport2({super.key});

//   @override
//   ConsumerState<ProductsReport> createState() => ProductsReportState();
// }

// class ProductsReportState extends ConsumerState<ProductsReport>
//     with SingleTickerProviderStateMixin {
//   late AnimationController productController;
//   late Animation<double> productanimation;

//   @override
//   void initState() {
//     super.initState();
//     productController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 5000));
//     // productanimation = Tween(begin: .0, end: 1.0).animate(
//     //     CurvedAnimation(parent: productController, curve: Curves.ease));
//     productanimation =
//         Tween<double>(begin: .0, end: 1.0).animate(CurvedAnimation(
//       parent: productController,
//       curve: Curves.ease,
//     ));
//     productController.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = ScrollController();

//     // List<Product> productList = ref.watch(productListReportsProvider);
//     // List<Cogs> cogsList = ref.watch(cogsReportProvider);
//     // List<ProductsSold> productSalesList = ref.watch(productSalesReportProvider);

//     var newMapCogs = groupBy(cogsList, (Cogs obj) => obj.idDocument);
//     var newMapProductSales =
//         groupBy(productSalesList, (ProductsSold obj) => obj.productDocument);

//     List<GlobalKey> stickKey = [
//       for (var i = 0; i < productList.length; i++) GlobalKey()
//     ];
//     List<dynamic> cachePictures = kIsWeb
//         ? ref.watch(pictureProductListProvider)
//         : ref.watch(pictureProductListAndroidProvider);

//     print("productList.length === ${productList.length}");
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: LayoutBuilder(builder: (context, constraints) {
//         double width = constraints.maxWidth;
//         double height = constraints.maxHeight;

//         return SizedBox(
//           width: width,
//           height: height,
//           child: ListView.builder(
//               physics: const BouncingScrollPhysics(),
//               scrollDirection: Axis.horizontal,
//               controller: controller,
//               itemCount: productList.length,
//               itemBuilder: (context, index) {
//                 return Container(
//                   width: width / 5,
//                   height: height,
//                   color: Colors.white,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Expanded(
//                         flex: 9,
//                         child: Bar(
//                             controller: controller,
//                             stickKey: stickKey.firstWhere(
//                                 (e) => stickKey.indexOf(e) == index),
//                             product: productList[index],
//                             index: index,
//                             newMapCogs: newMapCogs,
//                             newMapProductSales: newMapProductSales),
//                       ),
//                       Expanded(
//                         flex: 3,
//                         child: ScaleTransition(
//                           scale: productanimation,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               productList[index].logo != null
//                                   ? kIsWeb
//                                       ? Container(
//                                           width: width / 6,
//                                           height: height * 0.15,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(15.0),
//                                             color: Colors.transparent,
//                                           ),
//                                           padding:
//                                               const EdgeInsets.only(bottom: 10),
//                                           child: RemotePicture(
//                                             mapKey: productList[index].logo!,
//                                             imagePath:
//                                                 'gs://appparcial-123.appspot.com/products/${productList[index].logo}',
//                                           ),
//                                         )
//                                       : cachePictures.isNotEmpty
//                                           ? ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(15.0),
//                                               child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             15.0),
//                                                     color: Colors.transparent,
//                                                   ),
//                                                   padding:
//                                                       const EdgeInsets.all(12),
//                                                   width: double.infinity,
//                                                   height: 100,
//                                                   child: StreamBuilder<
//                                                       FileResponse>(
//                                                     stream: ref
//                                                         .watch(
//                                                             pictureProductListAndroidProvider
//                                                                 .notifier)
//                                                         .downLoadFile(
//                                                             productList[index]
//                                                                 .logo!),
//                                                     builder: (_, snapshot) {
//                                                       if (snapshot.hasData) {
//                                                         FileInfo fileInfo =
//                                                             snapshot.data
//                                                                 as FileInfo;
//                                                         return ClipOval(
//                                                           child:
//                                                               SizedBox.fromSize(
//                                                             size: const Size
//                                                                 .fromRadius(60),
//                                                             child: Image.file(
//                                                               fileInfo.file,
//                                                               fit: BoxFit
//                                                                   .scaleDown,
//                                                             ),
//                                                           ),
//                                                         );
//                                                       } else {
//                                                         return const Center(
//                                                           child:
//                                                               CircularProgressIndicator(),
//                                                         );
//                                                       }
//                                                     },
//                                                   )),
//                                             )
//                                           : const SizedBox()
//                                   : const SizedBox(),
//                               Expanded(
//                                 child: Material(
//                                   child: Text(
//                                     productList[index].name,
//                                     style: const TextStyle(
//                                         color: Colors.black87, fontSize: 16),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//         );
//       }),
//     );
//   }
// }

class Bar extends StatefulHookConsumerWidget {
  const Bar({
    super.key,
    required this.controller,
    required this.stickKey,
    required this.product,
    required this.index,
    required this.newMapCogs,
    required this.newMapProductSales,
  });

  final ScrollController controller;
  final GlobalKey stickKey;
  final Product product;
  final int index;
  final Map<String, List<Cogs>> newMapCogs;
  final Map<String, List<ProductsSold>> newMapProductSales;

  @override
  ConsumerState<Bar> createState() => _BarsState();
}

class _BarsState extends ConsumerState<Bar> with OverLayStateMixin {
  double get cogsAmount =>
      widget.newMapCogs.entries.any((e) => e.key == widget.product.documentId)
          ? widget.newMapCogs.entries
              .firstWhere((e) => e.key == widget.product.documentId)
              .value
              .fold(0.0, (prev, element) {
              // print(element.idDocument);
              return prev + (element.unitPrice * element.quantity);
            })
          : 0.0;
  double get productSalesAmount => widget.newMapProductSales.entries
          .any((e) => e.key == widget.product.documentId)
      ? widget.newMapProductSales.entries
          .firstWhere((e) => e.key == widget.product.documentId)
          .value
          .map((e) => e.price)
          .reduce((a, b) => a + b)
      : 0.0;
  double get stockCostAmount =>
      widget.product.quantity * widget.product.avgUnitPrice!;
  double get stockForSaleAmount =>
      widget.product.quantity * widget.product.price.price;

  double get profitProjection => stockForSaleAmount + productSalesAmount;

  double get totalAmounts =>
      cogsAmount + productSalesAmount + stockForSaleAmount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      double height = constraints.maxHeight;

      Offset offset = Offset.zero;

      final cmvHeight =
          (cogsAmount / totalAmounts) * (constraints.maxHeight * 0.95);
      final stockAmountHeight =
          (stockForSaleAmount / totalAmounts) * (constraints.maxHeight * 0.95);
      final salesHeight =
          (productSalesAmount / totalAmounts) * (constraints.maxHeight * 0.95);

      // print(
      //     "maxHeight: ${constraints.maxHeight} == cmvHeight: $cmvHeight == stockAmountHeight: $stockAmountHeight == salesHeight: $salesHeight");

      if (widget.newMapCogs.entries
          .any((e) => e.key == widget.product.documentId)) {
        widget.newMapCogs.entries
            .firstWhere((e) => e.key == widget.product.documentId)
            .value
            .forEach((element) {
          // print(
          //     "${widget.product.documentId} === ${element.unitPrice} === ${element.quantity}");
        });
      }

      double masterWidth = MediaQuery.of(context).size.width;

      // print(
      //     "item == ${widget.product.documentId} == $cogsAmount == $stockCostAmount == $stockForSaleAmount == $productSalesAmount == $totalAmounts == $profitProjection");
      // print(MediaQuery.of(context).size.width);
      return Container(
        height: height,
        width: width,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: masterWidth > 2000.0
                  ? 75
                  : masterWidth > 1500.0
                      ? 60
                      : 45),
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
                            // print(widget.product.quantity);
                            removeOverlay();
                            if (offset != Offset.zero) {
                              // print(offset);
                              offset = Offset(
                                offset.dx,
                                offset.dy - 50,
                              );
                              toggleOverlay(
                                OverlayUI(
                                  info: widget.product.name,
                                  borderColor: Color(
                                    int.parse(widget.product.primaryColor),
                                  ),
                                  cogs: cogsAmount,
                                  sales: productSalesAmount,
                                  stockForSales: stockForSaleAmount,
                                  price: widget.product.price.price,
                                  quantity: widget.product.quantity,
                                  avgUnitPrice: widget.product.avgUnitPrice,
                                  profitProjection: profitProjection,
                                  stockCostAmount: stockCostAmount,
                                ),
                                offset,
                              );
                            }
                          });
                        },
                        child: AnimationBar(
                          cmvHeight: cmvHeight,
                          stockAmountHeight: stockAmountHeight,
                          salesHeight: salesHeight,
                        )),
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

class AnimationBar extends StatefulHookConsumerWidget {
  const AnimationBar(
      {super.key,
      required this.cmvHeight,
      required this.salesHeight,
      required this.stockAmountHeight});

  final double cmvHeight;
  final double salesHeight;
  final double stockAmountHeight;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnimationBarState();
}

class _AnimationBarState extends ConsumerState<AnimationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> cogsAnimation;
  late Animation<double> salesAnimation;
  late Animation<double> stockAmountAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    cogsAnimation =
        Tween<double>(begin: 0, end: widget.cmvHeight).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0, 0.33),
    ));

    salesAnimation = Tween<double>(begin: 0, end: widget.salesHeight).animate(
        CurvedAnimation(parent: controller, curve: const Interval(0.34, 0.66)));
    stockAmountAnimation =
        Tween<double>(begin: 0, end: widget.stockAmountHeight).animate(
            CurvedAnimation(
                parent: controller, curve: const Interval(0.67, 1.0)));

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Column(verticalDirection: VerticalDirection.up, children: [
            Container(
              height: cogsAnimation.value,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Container(
              height: salesAnimation.value,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Container(
              height: stockAmountAnimation.value,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ]);
        });
  }
}

class OverlayUI extends StatefulWidget {
  const OverlayUI({
    super.key,
    required this.info,
    required this.borderColor,
    required this.cogs,
    required this.sales,
    required this.stockForSales,
    required this.price,
    required this.quantity,
    this.avgUnitPrice,
    required this.stockCostAmount,
    required this.profitProjection,
  });

  final String info;
  final Color borderColor;
  final double cogs;
  final double sales;
  final double stockForSales;
  final double price;
  final int quantity;
  final double? avgUnitPrice;
  final double stockCostAmount;
  final double profitProjection;
  @override
  State<OverlayUI> createState() => _OverlayUIState();
}

class _OverlayUIState extends State<OverlayUI> {
  double get projectionCogs => widget.stockForSales - widget.stockCostAmount;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: widget.borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Text(widget.info,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black, fontSize: 22)),
          Text('Preço Venda: ${widget.price.toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black, fontSize: 22)),
          Text('Preço Estoque: ${widget.avgUnitPrice!.toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black, fontSize: 22)),
          Text('Quantidade: ${widget.quantity}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black, fontSize: 22)),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('CMV: ',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black, fontSize: 22)),
              Text(widget.cogs.toStringAsFixed(2),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black, fontSize: 22)),
            ],
          ),
          Text('Vendas: ${widget.sales.toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black, fontSize: 22)),
          Text(
              'Lucro Bruto: ${(widget.sales - widget.cogs).toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black, fontSize: 22)),
          Text('Estoque Atual: ${widget.stockForSales.toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black, fontSize: 22)),
          Text('Projeção Vendas: ${widget.profitProjection.toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black, fontSize: 22)),
          Text(
              'Projeção Lucro: ${(widget.profitProjection - widget.stockCostAmount - widget.cogs).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          // MaterialButton(
          //   onPressed: () {
          //     print("tapped");
          //     Fluttertoast.showToast(
          //       msg: "Relatório Analítico Vertical do produto em breve",
          //       webPosition: "center",
          //       gravity: ToastGravity.TOP,
          //       timeInSecForIosWeb: 3,
          //       webBgColor: '#151515',
          //       textColor: Colors.white,
          //     );
          //   },
          //   color: Colors.black87,
          //   textColor: Colors.white,
          //   child: const Text('Ver mais'),
          // )
        ],
      ),
    );
  }
}
