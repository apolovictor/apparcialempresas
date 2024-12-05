import 'package:botecaria/modules/home/views/categories_list.dart';
import 'package:cached_firestorage/lib.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../orders/controller/orders_notifier.dart';
import '../../orders/model/order_model.dart';
import '../../products/controller/products_notifier.dart';
import '../../products/model/products_model.dart';
import '../controller/product_notifier.dart';

GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

class DashboardProduct extends HookConsumerWidget {
  DashboardProduct({super.key, required this.products});

  final List<Product> products;

  final double _imageHeight = 40.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CategoriesScroller categoriesScroller = CategoriesScroller(
      products: products,
    );

    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      double height = constraints.maxHeight;
      double width = constraints.maxWidth;
      return Column(children: <Widget>[
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "Produtos",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
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
        const SizedBox(height: 25),
        Expanded(child: ProductList(width: width)),
      ]);
    }));
  }
}

class ProductList extends StatefulHookConsumerWidget {
  const ProductList({super.key, required this.width});

  final double width;

  @override
  ConsumerState<ProductList> createState() => _ProductListState();
}

class _ProductListState extends ConsumerState<ProductList> {
  final scrollController = ScrollController();
  final double itemSize = 100.0;
  bool startAnimation = false;

  void onListenerController() {
    setState(() {});
  }

  @override
  void initState() {
    scrollController.addListener(onListenerController);

    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(onListenerController);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isAddingItem = ref.watch(isAddingItemProvider);
    final itemList = ref.watch(itemListProvider);

    final _controller =
        useAnimationController(duration: const Duration(milliseconds: 300));

    final Animation<double> productListAnimation = Tween(
      begin: widget.width,
      end: .0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
    var _productDashboard = ref.watch(filteredProductDashboardProvider);
    useValueChanged(_productDashboard, (_, __) async {
      if (!_controller.isDismissed) {
        _controller.reset();
        _controller.forward();
      }
    });
    List<dynamic> cachePictures = kIsWeb
        ? ref.watch(pictureProductListProvider)
        : ref.watch(pictureProductListAndroidProvider);

    // print("cachePictures.length === ${cachePictures.length}");

    return Stack(
      children: [
        SizedBox(
            height: double.infinity,
            child: ListView.builder(
                // primary: true,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemCount: _productDashboard.length,
                controller: scrollController,
                itemBuilder: (context, index) {
                  final itemOffset = index * itemSize;
                  final difference = scrollController.offset - itemOffset;
                  final percent =
                      1 - ((difference - 8 * index) / (itemSize / 2));
                  double scale = percent;
                  if (percent > 1.0) {
                    scale = 1.0;
                  }
                  double opacity = percent;
                  if (opacity > 1) {
                    opacity = 1.0;
                  }
                  if (opacity < 0) {
                    opacity = 0.0;
                  }

                  return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return AnimatedContainer(
                          duration: Duration(
                              milliseconds: ref
                                      .watch(categoryProductDashboardNotifier)
                                      .isNotEmpty
                                  ? 50 + (index * 200)
                                  : 200 + (index * 200)),
                          transform: Matrix4.translationValues(
                              productListAnimation.value, 0, 0),
                          child: Opacity(
                            opacity: opacity,
                            child: Transform(
                              transform: Matrix4.identity()..scale(scale, 1.0),
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Container(
                                        height: itemSize,
                                        margin: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black87,
                                                  blurRadius: 1,
                                                  spreadRadius: 2)
                                            ]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 4,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      _productDashboard[index]
                                                          .name,
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "R\$ ${_productDashboard[index].price.price.toString()}",
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      "Quantidade ${_productDashboard[index].quantity}",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              kIsWeb
                                                  ? cachePictures.any(
                                                          <RemotePicture>(element) =>
                                                              element.mapKey ==
                                                              _productDashboard[
                                                                      index]
                                                                  .logo)
                                                      ? Expanded(
                                                          flex: 1,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                            child: Container(
                                                                color: Colors
                                                                    .transparent,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        12),
                                                                width: 100,
                                                                height: 100,
                                                                child: cachePictures.firstWhere(<
                                                                        RemotePicture>(element) =>
                                                                    element
                                                                        .mapKey ==
                                                                    _productDashboard[
                                                                            index]
                                                                        .logo)),
                                                          ),
                                                        )
                                                      : const SizedBox()
                                                  : cachePictures.isNotEmpty
                                                      ? Expanded(
                                                          flex: 1,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                            child: Container(
                                                                color: Colors
                                                                    .transparent,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        12),
                                                                width: 100,
                                                                height: 100,
                                                                child: StreamBuilder<
                                                                    FileResponse>(
                                                                  stream: ref
                                                                      .watch(pictureProductListAndroidProvider
                                                                          .notifier)
                                                                      .downLoadFile(
                                                                          _productDashboard[index]
                                                                              .logo!),
                                                                  builder: (_,
                                                                      snapshot) {
                                                                    if (snapshot
                                                                        .hasData) {
                                                                      FileInfo
                                                                          fileInfo =
                                                                          snapshot.data
                                                                              as FileInfo;
                                                                      // print(
                                                                      //     "fileInfo ===== ${fileInfo.source}");
                                                                      return Image
                                                                          .file(
                                                                        fileInfo
                                                                            .file,
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                      );
                                                                      // SingleChildScrollView(
                                                                      //   child:
                                                                      //       Column(
                                                                      //     mainAxisAlignment:
                                                                      //         MainAxisAlignment.spaceEvenly,
                                                                      //     children: [
                                                                      //       Image.file(
                                                                      //         fileInfo.file,
                                                                      //         fit: BoxFit.fill,
                                                                      //       ),
                                                                      //       Text("Original Url:${fileInfo.originalUrl}"),
                                                                      //       Text("Valid Till:${fileInfo.validTill}"),
                                                                      //       Text("File address:${fileInfo.file}"),
                                                                      //       Text("File source:${fileInfo.source}"),
                                                                      //       Text("Hash code:${fileInfo.hashCode}"),
                                                                      //       Text("Type:${fileInfo.runtimeType}"),
                                                                      //     ],
                                                                      //   ),
                                                                      // );
                                                                    } else {
                                                                      return Center(
                                                                        child: Text(
                                                                            "Uploading..."),
                                                                      );
                                                                    }
                                                                  },
                                                                )),
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
                                                    BorderRadius.circular(
                                                        50.0)),
                                            child: InkWell(
                                              onTap: () {
                                                if (itemList.isNotEmpty) {
                                                  itemList.any((e) =>
                                                          e.productIdDocument ==
                                                          _productDashboard[index]
                                                              .documentId)
                                                      ? itemList.firstWhere((e) => e.productIdDocument == _productDashboard[index].documentId).quantity <
                                                              _productDashboard[index]
                                                                  .quantity
                                                          ? ref.read(itemListProvider.notifier).updateItem(
                                                              itemList.indexOf(itemList
                                                                  .firstWhere((e) =>
                                                                      e.productIdDocument ==
                                                                      _productDashboard[index]
                                                                          .documentId)),
                                                              itemList.firstWhere((e) =>
                                                                  e.productIdDocument ==
                                                                  _productDashboard[index]
                                                                      .documentId))
                                                          : Fluttertoast.showToast(
                                                              msg: "Estoque do produto ${_productDashboard[index].name} indisponível! Adicione mais no módulo de produtos!",
                                                              toastLength: Toast.LENGTH_LONG,
                                                              gravity: ToastGravity.TOP,
                                                              timeInSecForIosWeb: 4,
                                                              webBgColor: '#151515',
                                                              textColor: Colors.white,
                                                              fontSize: 18.0)
                                                      : ref.read(itemListProvider.notifier).setItem(OrderItem(productIdDocument: _productDashboard[index].documentId!, productCategory: _productDashboard[index].categories, productName: _productDashboard[index].name, photo_url: _productDashboard[index].logo, price: _productDashboard[index].price.price, avgUnitPrice: _productDashboard[index].avgUnitPrice!, quantity: 1, isUnavailble: false));
                                                } else {
                                                  ref.read(itemListProvider.notifier).setItem(OrderItem(
                                                      productIdDocument:
                                                          _productDashboard[index]
                                                              .documentId!,
                                                      productCategory:
                                                          _productDashboard[index]
                                                              .categories,
                                                      productName:
                                                          _productDashboard[
                                                                  index]
                                                              .name,
                                                      photo_url:
                                                          _productDashboard[
                                                                  index]
                                                              .logo!,
                                                      price: _productDashboard[
                                                              index]
                                                          .price
                                                          .price,
                                                      avgServiceTime:
                                                          _productDashboard[
                                                                  index]
                                                              .avgServiceTime,
                                                      avgUnitPrice:
                                                          _productDashboard[
                                                                  index]
                                                              .avgUnitPrice!,
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
                        );
                      });
                })),
      ],
    );
  }
}

// class BusinessListView extends HookConsumerWidget {
//   BusinessListView({super.key});

//   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     bool isAddingItem = ref.watch(isAddingItemProvider);
//     final itemList = ref.watch(itemListProvider);

//     final scrollController = ScrollController();
//     final _controller =
//         useAnimationController(duration: const Duration(milliseconds: 500));
//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _controller.reverse();
//       }
//     });

//     var _refresh = ref.watch(filteredProductDashboardProvider);
//     print(_refresh.length);
//     useValueChanged(_refresh, (_, __) async {
//       _controller.forward();
//     });

//     _setColor(int status) {
//       switch (status) {
//         case 1:
//           return Colors.green;

//         case 2:
//           return Colors.yellow[800];

//         case 3:
//           return Colors.red;
//       }
//     }

//     _buildItem(Product product, Animation<double> animation, int index,
//         BuildContext context, bool isAddingItem, List<OrderItem> itemList) {
//       return AnimationConfiguration.staggeredList(
//           position: index,
//           duration: const Duration(milliseconds: 675),
//           child: SlideAnimation(
//               verticalOffset: MediaQuery.of(context).size.height,
//               child: FadeTransition(
//                 opacity: animation,
//                 child: SizeTransition(
//                   sizeFactor: animation,
//                   child: InkWell(
//                     hoverColor: Colors.green[50],
//                     onHover: (hover) {
//                       // ref
//                       //     .read(stateHoverRow.notifier)
//                       //     .fetchHoverRow(stateHover != hover ? true : false);
//                     },
//                     onTap: () {},
//                     onLongPress: () {
//                       // Fluttertoast.showToast(
//                       //   msg: "${_productDashboard[index].name} Long Press!",
//                       //   webPosition: "center",
//                       //   webBgColor: "#bbdefb",
//                       //   timeInSecForIosWeb: 5,
//                       //   textColor: _setColor(product.status),
//                       //   gravity: ToastGravity.SNACKBAR,
//                       // );
//                     },
//                   ),
//                 ),
//               )));
//     }

//     double topContainer = ref.watch(topContainerProvider);

//     scrollController.addListener(() {
//       print("scrollController.offset ==== ${scrollController.offset}");
//       print("topContainer ========= $topContainer");
//       ref
//           .read(topContainerProvider.notifier)
//           .fetchValue(scrollController.offset / 119);
//       ref
//           .read(isShowContainerNotifier.notifier)
//           .isShowContainer(scrollController.offset > 50);
//     });

//     return AnimatedBuilder(
//       key: _listKey,
//       animation: _controller,
//       builder: (context, child) => AnimationLimiter(
//         child: AnimatedList(
//             controller: scrollController,
//             // key: _listKey,
//             initialItemCount: _refresh.length,
//             itemBuilder: (context, index, _controller) {
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 ref.read(pictureProductListProvider.notifier).fetchPictureList(
//                       RemotePicture(
//                         mapKey: _refresh[index].logo!,
//                         imagePath:
//                             'gs://appparcial-123.appspot.com/products/${_refresh[index].logo!}',
//                       ),
//                       _refresh.length,
//                     );
//               });
//               double scale = 1.0;
//               if (topContainer > 0.4) {
//                 scale = index + 0.5 - topContainer;
//                 print("scale === $scale");
//                 print("index === $index");
//                 if (scale < 0) {
//                   scale = 0;
//                 } else if (scale > 1) {
//                   scale = 1;
//                 }
//               }

//               return Opacity(
//                   opacity: scale,
//                   child: Transform(
//                       transform: Matrix4.identity()..scale(scale, scale),
//                       alignment: Alignment.bottomCenter,
//                       child: Align(
//                           heightFactor: 0.7,
//                           alignment: Alignment.topCenter,
//                           child: _buildItem(_refresh[index], _controller, index,
//                               context, isAddingItem, itemList))));
//             }),
//       ),
//     );
//   }
// }
