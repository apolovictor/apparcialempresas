import 'package:apparcialempresas/modules/products/widgets/quick_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math' as math;

import '../controller/product_list.notifier.dart';
import '../controller/products_notifier.dart';
import '../model/products_model.dart';
import 'categories_list.dart';
import 'product_details_impl.dart';
import 'product_list.dart';

class ProductScreen extends HookConsumerWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int productSelected = ref.watch(selectedProductNotifier);
    final filter = ref.watch(filterNotifier);
    // final TextEditingController productNameController = TextEditingController();
    final double radius = MediaQuery.of(context).size.width * 0.2;
    List<Product> filteredProducts = ref.watch(filteredProductListProvider);
    List<Product>? products = ref.watch(exampleProvider).value;

    bool isActiveEdit = ref.watch(isActiveEditNotifier);
    bool isActiveProductRegister = ref.watch(isProductsOpenedProvider);

    List<OffsetProduct> offSetProduct = ref.watch(offsetListProvider);

    List<LabeledGlobalKey> globalKeys = ref.watch(globalKeyListProvider);

    useValueChanged(offSetProduct, (_, __) async {
      print("here");
    });

    get_chip(Product tagTable, int index) {
      // print("index ===== $index");
      // print(globalKeys[index]);
      // print(offSetProduct.length);
      if (offSetProduct.length == globalKeys.length) {
        print(
            " offSetProduct[index].offSet.dy ====== ${offSetProduct[index].offSet.dy}");
        print(products![index].name);
      }
      return Container(
        key: globalKeys[index],
        width: offSetProduct.length == globalKeys.length &&
                offSetProduct[index].offSet.dy > radius
            ? 200
            : 150,
        height: offSetProduct.length == globalKeys.length &&
                offSetProduct[index].offSet.dy > radius
            ? 200
            : 150,

        //  productSelected > -1
        //     ? ref.watch(pictureProductListProvider).firstWhere(
        //         (element) => element.mapKey == products![productSelected].logo)
        //     : SizedBox(),
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: Center(child: Text(tagTable.name)),
      );
    }

    generate_tags() {
      return products!
          .asMap()
          .entries
          .map((tag) => get_chip(tag.value, tag.key))
          .toList();
    }

    print("radius $radius");

    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: globalKeys.length == products!.length
            ? CircularScrollView(
                //wrap this with align if you want it to be aligned to the right of the screen
                [
                  ...generate_tags(),
                ],
                radius: radius,
                padding:
                    0, //add double the radius entered to clip out the right side
                itemMaxHeight: 60, //effects clipping border height
                itemMaxWidth: 60, //effects clipping border width
                globalKeys: globalKeys,
              )
            : SizedBox(),
      ),
    );
  }
}

class CircularScrollView extends StatefulHookConsumerWidget {
  final List<Widget> items;
  final double radius;
  final double itemMaxHeight;
  final double itemMaxWidth;
  final double padding;
  final bool reverse;
  final List<LabeledGlobalKey> globalKeys;

  CircularScrollView(this.items,
      {super.key,
      this.radius = 10,
      this.itemMaxHeight = 0,
      this.itemMaxWidth = 0,
      this.padding = 0,
      this.reverse = false,
      required this.globalKeys});
  @override
  _CircularScrollViewState createState() => _CircularScrollViewState();
}

class _CircularScrollViewState extends ConsumerState<CircularScrollView> {
  double? lastPosition;
  List<Widget> transformItems = [];
  double degreesRotated = 0;

  @override
  void initState() {
    setState(() {
      _calculateTransformItems();
    });
    super.initState();
  }

  void _calculateTransformItems() {
    transformItems = [];
    for (int i = 0; i < widget.items.length; i++) {
      double startAngle = (i / widget.items.length) * 2 * math.pi;
      // print("startAngle ==== $startAngle");
      // print("startAngle ==== ${(widget.items.length) * 2 * math.pi}");

      double currentAngle = degreesRotated + startAngle;

      // print(widget.items[i].key);
      transformItems.add(
        Transform(
          transform: Matrix4.identity()
            ..translate(
              (widget.radius) * math.cos(currentAngle),
              (widget.radius) * math.sin(currentAngle),
            ),
          child: widget.items[i],
        ),
      );
    }
  }

  void _calculateScroll(DragUpdateDetails details) {
    if (lastPosition == null) {
      lastPosition = details.localPosition.dy;
      return;
    }
    double distance = details.localPosition.dy - lastPosition!;
    double distanceWithReversal = widget.reverse ? distance : -distance;
    lastPosition = details.localPosition.dy;
    degreesRotated += distanceWithReversal / (widget.radius);

    // print(degreesRotated);
    _calculateTransformItems();
  }

  @override
  Widget build(BuildContext context) {
    // print("widget.radius ===== ${widget.radius}");
    // print("widget.itemMaxHeight ===== ${widget.itemMaxHeight}");
    // print(widget.radius * 2 + widget.itemMaxHeight);
    // print(widget.radius * 2 + widget.itemMaxWidth);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < widget.items.length; i++) {
        // print(
        //     "ref.watch(offsetListProvider) ========= ${ref.watch(offsetListProvider).length}");
        // print(
        //     " widget.globalKeys.length ======== ${widget.globalKeys.length}");
        // print(
        // "globalKeysLabeled ==========  ${widget.globalKeys[i].currentContext?.toString()}");
        var currentBox = widget.globalKeys[i].currentContext!.findRenderObject()
            as RenderBox;
        if (ref.watch(offsetListProvider).length != widget.globalKeys.length) {
          ref.read(offsetListProvider.notifier).fetchOffsetList(OffsetProduct(
              documentId: widget.globalKeys[i].toString(),
              offSet: currentBox.localToGlobal(Offset.zero)));

          print(currentBox.localToGlobal(Offset.zero));

          // ref
          //     .read(offsetAvatarControllerProvider.notifier)
          //     .setOffset(currentBox.localToGlobal(Offset.zero));
        } else {
          ref.read(offsetListProvider.notifier).updateOffSetList(
              OffsetProduct(
                  documentId: widget.globalKeys[i].toString(),
                  offSet: currentBox.localToGlobal(Offset.zero)),
              i);
          // print("heree");
        }
      }
    });

    return Align(
      alignment: Alignment.topRight,
      child: Container(
        height: widget.radius * 2 + widget.itemMaxHeight,
        width: widget.radius * 2 + widget.itemMaxWidth,
        child: GestureDetector(
          onVerticalDragUpdate: (details) => setState(() {
            _calculateScroll(details);
          }),
          onVerticalDragEnd: (details) {
            lastPosition = null;
          },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.transparent,
            child: ClipRect(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: widget.padding),
                  child: Stack(
                    children: transformItems,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class ProductScreen extends HookConsumerWidget {
//   ProductScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final bool displayMobileLayout = MediaQuery.of(context).size.width < 600;
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     int productSelected = ref.watch(selectedProductNotifier);
//     final filter = ref.watch(filterNotifier);
//     final TextEditingController productNameController = TextEditingController();

//     List<Product> filteredProducts = ref.watch(filteredProductListProvider);
//     List<Product>? products = ref.watch(exampleProvider).value;

//     bool isActiveEdit = ref.watch(isActiveEditNotifier);
//     bool isActiveProductRegister = ref.watch(isProductsOpenedProvider);

//     // if (filter['category'].isNotEmpty) {
//     //   print(filteredProducts.length);
//     // } else {
//     //   if (products != null) {
//     //     print("products ========== ${products.length}");
//     //   }
//     // }

//     final Animation<double> containerScaleTweenAnimation =
//         Tween(begin: .0, end: MediaQuery.of(context).size.width * 0.3).animate(
//             CurvedAnimation(
//                 parent: getCategoriesController(ref), curve: Curves.ease));

//     final Animation<double> animation = Tween(begin: .0, end: 1.0).animate(
//         CurvedAnimation(
//             parent: getQuickFieldsController(ref), curve: Curves.ease));

//     final Animation<double> containerAlignTweenAnimation =
//         Tween(begin: 0.0, end: -1.0).animate(CurvedAnimation(
//             parent: getCategoriesController(ref), curve: Curves.ease));

//     final Animation<double> containerBorderRadiusAnimation =
//         Tween(begin: 100.0, end: 15.0).animate(CurvedAnimation(
//             parent: getCategoriesController(ref), curve: Curves.ease));

//     Route createRoute() {
//       return PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) =>
//             ProductDetails(),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           const begin = Offset(1.0, 0.0);
//           const end = Offset.zero;
//           const curve = Curves.ease;

//           var tween =
//               Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//           return SlideTransition(
//             position: animation.drive(tween),
//             child: child,
//           );
//         },
//       );
//     }

//     get_chip(Product tagTable, int index) {
//       return Container(
//         // width: 200,
//         // height: 200,
//         child: productSelected > -1
//             ? ref.watch(pictureProductListProvider).firstWhere(
//                 (element) => element.mapKey == products![productSelected].logo)
//             : SizedBox(),
//       );
//     }

//     generate_tags() {
//       return products!
//           .asMap()
//           .entries
//           .map((tag) => get_chip(tag.value, tag.key))
//           .toList();
//     }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: products != null || filteredProducts.isNotEmpty
//           ? LayoutBuilder(builder: (context, constraints) {
//               return Stack(
//                 children: [
//                   Row(
//                     children: [
//                       AnimatedContainer(
//                         duration: const Duration(milliseconds: 375),
//                         width: isActiveEdit || isActiveProductRegister
//                             ? width * 0.7
//                             : width,
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                               top: 0,
//                               left: !displayMobileLayout
//                                   ? MediaQuery.of(context).size.width * 0.05
//                                   : 15,
//                               right: !displayMobileLayout
//                                   ? MediaQuery.of(context).size.width * 0.05
//                                   : 15,
//                               bottom: 0),
//                           child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: [
//                                 Expanded(
//                                   flex: height < 806 ? 2 : 3,
//                                   child: Container(
//                                     color: Colors.black54,
//                                     child: Center(
//                                       child: Text(
//                                         "TOP",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .headlineLarge!
//                                             .apply(color: Colors.white),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: !displayMobileLayout && height > 805
//                                       ? 5
//                                       : height < 806 && !displayMobileLayout
//                                           ? 6
//                                           : 2,
//                                   child: SizedBox(
//                                     width: double.infinity,
//                                     child: Column(
//                                       children: [
//                                         Row(children: [
//                                           Text(
//                                             ' Categorias ',
//                                             style: height < 806
//                                                 ? Theme.of(context)
//                                                     .textTheme
//                                                     .headlineMedium
//                                                 : Theme.of(context)
//                                                     .textTheme
//                                                     .headlineLarge,
//                                           ),
//                                         ]),
//                                         const SizedBox(height: 20),
//                                         const Expanded(child: CategoriesList()),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: !displayMobileLayout ? 12 : 4,
//                                   child: SizedBox(
//                                       width: double.infinity,
//                                       child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Text(
//                                                   ' Meus Produtos',
//                                                   style: height < 800
//                                                       ? Theme.of(context)
//                                                           .textTheme
//                                                           .headlineMedium
//                                                       : Theme.of(context)
//                                                           .textTheme
//                                                           .headlineLarge,
//                                                 ),
//                                                 Row(
//                                                   children: [
//                                                     FilterChip(
//                                                       onSelected: (value) {
//                                                         if (isActiveEdit ==
//                                                             true) {
//                                                           ref
//                                                               .read(
//                                                                   isActiveEditNotifier
//                                                                       .notifier)
//                                                               .setIsActiveEdit(
//                                                                   false);
//                                                           Future.delayed(
//                                                               const Duration(
//                                                                   milliseconds:
//                                                                       400), () {
//                                                             ref
//                                                                 .read(isProductsOpenedProvider
//                                                                     .notifier)
//                                                                 .fetch(true);
//                                                           });
//                                                         } else {
//                                                           ref
//                                                               .read(
//                                                                   isProductsOpenedProvider
//                                                                       .notifier)
//                                                               .fetch(true);
//                                                         }
//                                                       },
//                                                       side: const BorderSide(
//                                                           color: Colors
//                                                               .transparent),
//                                                       backgroundColor:
//                                                           Colors.grey[200],
//                                                       shape:
//                                                           RoundedRectangleBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10),
//                                                       ),
//                                                       label: SizedBox(
//                                                           child: Text(
//                                                               "Adicionar Produto",
//                                                               style: Theme.of(
//                                                                       context)
//                                                                   .textTheme
//                                                                   .bodyLarge!
//                                                                   .apply(
//                                                                       color: Colors
//                                                                           .black87))),
//                                                     )
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                             ProductsList(),
//                                           ])),
//                                 )
//                               ]),
//                         ),
//                       ),
//                       AnimatedContainer(
//                         duration: const Duration(milliseconds: 375),
//                         width: isActiveProductRegister ? width * 0.3 : 0,
//                         height:
//                             isActiveProductRegister ? constraints.maxHeight : 0,
//                         color: Colors.black12,
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.vertical,
//                           child: Column(
//                             children: [
//                               Align(
//                                 alignment: Alignment.topLeft,
//                                 child: IconButton(
//                                   icon: const Icon(
//                                     Icons.close,
//                                   ),
//                                   onPressed: () {
//                                     ref
//                                         .read(isProductsOpenedProvider.notifier)
//                                         .fetch(false);
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       AnimatedContainer(
//                         duration: const Duration(milliseconds: 375),
//                         width: (isActiveEdit && productSelected > -1)
//                             ? width * 0.3
//                             : 0,
//                         height: constraints.maxHeight,
//                         color: productSelected > -1
//                             ? filter['category'].isNotEmpty &&
//                                     filteredProducts.isNotEmpty
//                                 ? Color(int.parse(
//                                     filteredProducts[productSelected].color))
//                                 : products!.isNotEmpty
//                                     ? Color(int.parse(
//                                         products[productSelected].color))
//                                     : Colors.transparent
//                             : Colors.transparent,
//                         child: LayoutBuilder(builder: (context, constraints) {
//                           return Column(
//                             children: [
//                               Stack(
//                                 children: [
//                                   Positioned(
//                                     top: 0,
//                                     right: 0,
//                                     child: AnimatedContainer(
//                                         duration:
//                                             const Duration(milliseconds: 700),
//                                         height: 400,
//                                         width: (isActiveEdit &&
//                                                 productSelected > -1)
//                                             ? width * 0.3
//                                             : 0,
//                                         child: productSelected > -1
//                                             ? filter['category'].isNotEmpty &&
//                                                     filteredProducts.isNotEmpty
//                                                 ? ref
//                                                     .watch(
//                                                         pictureProductListProvider)
//                                                     .firstWhere((element) =>
//                                                         element.mapKey ==
//                                                         filteredProducts[
//                                                                 productSelected]
//                                                             .logo)
//                                                 : ref
//                                                     .watch(
//                                                         pictureProductListProvider)
//                                                     .firstWhere((element) =>
//                                                         element.mapKey ==
//                                                         products![
//                                                                 productSelected]
//                                                             .logo)
//                                             : SizedBox()
//                                         // Stack(
//                                         //   children: [
//                                         //     ListView(
//                                         //         scrollDirection: Axis.horizontal,
//                                         //         itemExtent: 300,
//                                         //         children: <Widget>[
//                                         //           ...generate_tags()
//                                         //         ])
//                                         //   ],
//                                         // ),
//                                         ),
//                                   ),
//                                   Hero(
//                                     tag: 'detailProduct',
//                                     flightShuttleBuilder: (_,
//                                         Animation<double> animation,
//                                         __,
//                                         ___,
//                                         ____) {
//                                       final customAnimation = Tween<double>(
//                                               begin: 0,
//                                               end: constraints.maxWidth * 0.3)
//                                           .animate(animation);

//                                       return AnimatedBuilder(
//                                           animation: customAnimation,
//                                           builder: (context, child) {
//                                             return const SizedBox();
//                                             // ProductDetails();
//                                           });
//                                     },
//                                     child: Stack(
//                                       children: [
//                                         SingleChildScrollView(
//                                           child: Stack(
//                                             children: [
//                                               Align(
//                                                 alignment:
//                                                     const Alignment(-1.1, -1),
//                                                 child: InkWell(
//                                                   onTap: () {
//                                                     ref
//                                                         .read(
//                                                             isActiveEditNotifier
//                                                                 .notifier)
//                                                         .setIsActiveEdit(false);
//                                                   },
//                                                   child: Container(
//                                                     height: 50.0,
//                                                     width: 50.0,
//                                                     decoration: BoxDecoration(
//                                                         color: Colors.black87,
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(
//                                                                     30.0)),
//                                                     child: const Icon(
//                                                       Icons.close,
//                                                       color: Colors.white,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 height: constraints.maxHeight,
//                                                 child: AnimatedAlign(
//                                                   duration: const Duration(
//                                                       milliseconds: 375),
//                                                   alignment: Alignment(
//                                                       -1.2,
//                                                       constraints.maxWidth ==
//                                                               width * 0.3
//                                                           ? 0
//                                                           : -1),
//                                                   child: Container(
//                                                     height: 75.0,
//                                                     width: 75.0,
//                                                     decoration: BoxDecoration(
//                                                         color: Colors.black87,
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(
//                                                                     50.0)),
//                                                     child: InkWell(
//                                                       onTap: () {
//                                                         Navigator.of(context)
//                                                             .push(
//                                                                 createRoute());
//                                                       },
//                                                       child: const Icon(
//                                                         Icons.arrow_back,
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SingleChildScrollView(
//                                 child: Column(
//                                   children: [
//                                     ScaleTransition(
//                                       scale: animation,
//                                       child: fieldWidget(productNameController,
//                                           "Nome", context),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           );
//                         }),
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     right: 0,
//                     bottom: 0,
//                     child: AnimatedBuilder(
//                       animation: containerScaleTweenAnimation,
//                       builder: (context, child) {
//                         return Align(
//                           alignment: Alignment(
//                               containerAlignTweenAnimation.value,
//                               containerAlignTweenAnimation.value),
//                           child: Container(
//                             height: containerScaleTweenAnimation.value,
//                             width: containerScaleTweenAnimation.value,
//                             padding: const EdgeInsets.all(8.0),
//                             clipBehavior: Clip.antiAlias,
//                             decoration: BoxDecoration(
//                                 color: Colors.grey[300],
//                                 borderRadius: BorderRadius.circular(
//                                     containerBorderRadiusAnimation.value)),
//                             child: child,
//                           ),
//                         );
//                       },
//                       child: SingleChildScrollView(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Align(
//                               alignment: Alignment.topLeft,
//                               child: IconButton(
//                                 icon: const Icon(
//                                   Icons.close,
//                                 ),
//                                 onPressed: () {
//                                   ref
//                                       .read(isCategoriesOpenedProvider.notifier)
//                                       .fetch(false);
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             })
//           : SizedBox(),
//     );
//   }
// }
