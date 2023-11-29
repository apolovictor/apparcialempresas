import 'package:apparcialempresas/modules/home/views/categories_list.dart';
import 'package:cached_firestorage/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
        BuildContext context) {
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
                        textColor: _setColor(product.status!),
                        gravity: ToastGravity.SNACKBAR,
                      );
                    },
                    child: Container(
                        height: 150,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "R\$ ${product.price['price']}",
                                    style: const TextStyle(
                                        fontSize: 17, color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Quantidade ${product.quantity}",
                                    style: const TextStyle(
                                        fontSize: 25,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              ref.watch(pictureProductListProvider).any(
                                      (element) =>
                                          element.mapKey == product.logo)
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Container(
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.all(12),
                                          width: 100,
                                          height: 100,
                                          child: ref
                                              .watch(pictureProductListProvider)
                                              .firstWhere((element) =>
                                                  element.mapKey ==
                                                  product.logo)),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        )),
                    //  Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 32.0 - dotSize / 2),
                    //         child: Container(
                    //           height: dotSize,
                    //           width: dotSize,
                    //           decoration: BoxDecoration(
                    //               shape: BoxShape.circle,
                    //               color: _setColor(todo.status)),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: <Widget>[
                    //             Text(
                    //               todo.name!,
                    //               style: const TextStyle(fontSize: 18.0),
                    //             ),
                    //             Text(
                    //               todo.categories!,
                    //               style: const TextStyle(
                    //                   fontSize: 12.0, color: Colors.grey),
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
                          child: _buildItem(
                              _refresh[index], _controller, index, context))));
            }),
      ),
    );
  }
}
