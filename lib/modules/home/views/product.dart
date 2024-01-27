import 'dart:html';

import 'package:apparcialempresas/modules/home/views/categories_list.dart';
import 'package:cached_firestorage/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../orders/controller/orders_notifier.dart';
import '../../orders/model/order_model.dart';
import '../../products/model/products_model.dart';
import '../controller/product_notifier.dart';

GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

class DashboardProduct extends HookConsumerWidget {
  DashboardProduct({super.key, required this.products});

  final List<Product> products;

  final double _imageHeight = 40.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(filteredProductDashboardProvider);

    CategoriesScroller categoriesScroller = CategoriesScroller(
      products: products,
    );
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      double height = constraints.maxHeight;
      return SizedBox(
          height: double.infinity,
          child: Column(children: <Widget>[
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Produtos",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 0),
              opacity: 1,
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  width: double.infinity,
                  height: height * 0.15,
                  child: categoriesScroller),
            ),
            const SizedBox(height: 20),

            Expanded(child: BusinessListView()),
            // Stack(
            //   children: [
            //     Positioned(
            //       top: 0.0,
            //       bottom: 0.0,
            //       left: 32.0,
            //       child: Container(
            //         width: 1.0,
            //         color: Colors.grey[300],
            //       ),
            //     ),
            //     Padding(
            //       padding: EdgeInsets.only(top: _imageHeight),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: <Widget>[
            //           Padding(
            //             padding: const EdgeInsets.only(left: 64.0),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: <Widget>[
            //                 const Text(
            //                   'Empresas',
            //                   style: TextStyle(fontSize: 34.0),
            //                 ),
            //                 Text(
            //                   'Total ${todoList.length}',
            //                   style: const TextStyle(
            //                       color: Colors.grey, fontSize: 14.0),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           Expanded(child: BusinessListView()),
            //         ],
            //       ),
            //     ),
            //     Positioned(
            //         top: _imageHeight - 50.0,
            //         right: -60.0,
            //         child: AnimatedFab(
            //           onClick: () {},
            //           products: products,
            //         )),
            //   ],
            // )
          ]));
    }));
  }
}

class BusinessListView extends HookConsumerWidget {
  BusinessListView({super.key});

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isAddingItem = ref.watch(isAddingItemProvider);
    final itemList = ref.watch(itemListProvider);

    final scrollController = ScrollController();
    final _controller =
        useAnimationController(duration: const Duration(milliseconds: 500));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });

    var _refresh = ref.watch(filteredProductDashboardProvider);
    useValueChanged(_refresh, (_, __) async {
      _controller.forward();
    });

    _setColor(int status) {
      switch (status) {
        case 1:
          return Colors.green;

        case 2:
          return Colors.yellow[800];

        case 3:
          return Colors.red;
      }
    }

    _buildItem(Product product, Animation<double> animation, int index,
        BuildContext context, bool isAddingItem, List<OrderItem> itemList) {
      return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 675),
          child: SlideAnimation(
              verticalOffset: MediaQuery.of(context).size.height,
              child: FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  child: InkWell(
                    hoverColor: Colors.green[50],
                    onHover: (hover) {
                      // ref
                      //     .read(stateHoverRow.notifier)
                      //     .fetchHoverRow(stateHover != hover ? true : false);
                    },
                    onTap: () {},
                    onLongPress: () {
                      Fluttertoast.showToast(
                        msg: "${product.name} Long Press!",
                        webPosition: "center",
                        webBgColor: "#bbdefb",
                        timeInSecForIosWeb: 5,
                        textColor: _setColor(product.status),
                        gravity: ToastGravity.SNACKBAR,
                      );
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Container(
                              height: 175,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withAlpha(100),
                                        blurRadius: 10.0),
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            product.name,
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "R\$ ${product.price.price.toString()}",
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Quantidade ${product.quantity}",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                    ref.watch(pictureProductListProvider).any(
                                            (element) =>
                                                element.mapKey == product.logo)
                                        ? Expanded(
                                            flex: 1,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              child: Container(
                                                  color: Colors.transparent,
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  width: 100,
                                                  height: 100,
                                                  child: ref
                                                      .watch(
                                                          pictureProductListProvider)
                                                      .firstWhere((element) =>
                                                          element.mapKey ==
                                                          product.logo)),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              )),
                        ),
                        isAddingItem
                            ? Positioned(
                                right: 0,
                                top: 37.5,
                                child: Container(
                                  height: 75.0,
                                  width: 75.0,
                                  decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  child: InkWell(
                                    onTap: () {
                                      if (itemList.isNotEmpty) {
                                        itemList.any((e) =>
                                                e.productIdDocument ==
                                                product.documentId)
                                            ? itemList.firstWhere((e) => e.productIdDocument == product.documentId).quantity <
                                                    product.quantity
                                                ? ref.read(itemListProvider.notifier).updateItem(
                                                    itemList.indexOf(itemList.firstWhere((e) =>
                                                        e.productIdDocument ==
                                                        product.documentId)),
                                                    itemList.firstWhere((e) =>
                                                        e.productIdDocument ==
                                                        product.documentId))
                                                : Fluttertoast.showToast(
                                                    msg:
                                                        "Estoque do produto ${product.name} indisponível! Adicione mais no módulo de produtos!",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity: ToastGravity.TOP,
                                                    timeInSecForIosWeb: 4,
                                                    webBgColor: '#151515',
                                                    textColor: Colors.white,
                                                    fontSize: 18.0)
                                            : ref
                                                .read(itemListProvider.notifier)
                                                .setItem(OrderItem(
                                                    productIdDocument: product.documentId!,
                                                    productCategory: product.categories,
                                                    productName: product.name,
                                                    photo_url: product.logo,
                                                    price: product.price.price,
                                                    avgUnitPrice: product.avgUnitPrice!,
                                                    quantity: 1,
                                                    isUnavailble: false));
                                      } else {
                                        ref
                                            .read(itemListProvider.notifier)
                                            .setItem(OrderItem(
                                                productIdDocument:
                                                    product.documentId!,
                                                productCategory:
                                                    product.categories,
                                                productName: product.name,
                                                photo_url: product.logo!,
                                                price: product.price.price,
                                                avgUnitPrice:
                                                    product.avgUnitPrice!,
                                                quantity: 1,
                                                isUnavailble: false));
                                      }
                                    },
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              )));
    }

    double topContainer = ref.watch(topContainerProvider);

    scrollController.addListener(() {
      ref
          .read(topContainerProvider.notifier)
          .fetchValue(scrollController.offset / 119);
      ref
          .read(isShowContainerNotifier.notifier)
          .isShowContainer(scrollController.offset > 50);
    });

    return AnimatedBuilder(
      key: _listKey,
      animation: _controller,
      builder: (context, child) => AnimationLimiter(
        child: AnimatedList(
            controller: scrollController,
            // key: _listKey,
            initialItemCount: _refresh.length,
            itemBuilder: (context, index, _controller) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(pictureProductListProvider.notifier).fetchPictureList(
                      RemotePicture(
                        mapKey: _refresh[index].logo!,
                        imagePath:
                            'gs://appparcial-123.appspot.com/products/${_refresh[index].logo!}',
                      ),
                      _refresh.length,
                    );
              });
              double scale = 1.0;
              if (topContainer > 0.5) {
                scale = index + 0.5 - topContainer;
                if (scale < 0) {
                  scale = 0;
                } else if (scale > 1) {
                  scale = 1;
                }
              }

              return Opacity(
                  opacity: scale,
                  child: Transform(
                      transform: Matrix4.identity()..scale(scale, scale),
                      alignment: Alignment.bottomCenter,
                      child: Align(
                          heightFactor: 0.7,
                          alignment: Alignment.topCenter,
                          child: _buildItem(_refresh[index], _controller, index,
                              context, isAddingItem, itemList))));
            }),
      ),
    );
  }
}
