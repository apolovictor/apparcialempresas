import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';
import '../controller/products_notifier.dart';
import '../model/products_model.dart';
import 'constants.dart';
import 'product_card.dart';

GlobalKey<AnimatedListState> _listKey2 = GlobalKey<AnimatedListState>();

class ProductsList extends ConsumerStatefulWidget {
  ProductsList({super.key, required this.products});
  List<Product> products;
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends ConsumerState<ProductsList> {
  // ScrollController controller = ScrollController();
  bool lloseLeftContainer = false;
  double leftContainer = 0;
  double middleList = 0;

  List<Product> itemsData = [];
  bool isTransform = false;

  @override
  void initState() {
    super.initState();
    // getPostsData();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ref.watch(scrollControllerNotifier);
    // print(MediaQuery.of(context).size.width * 0.12);
    // print(currentOffset.dx);
    // print(currentOffset);
    List<ProductItem> listItems = [];
    controller.addListener(() {
      double value = controller.offset / 280;
      double value2 =
          (controller.offset) + (ref.watch(productListSizeNotifier) / 2);
      // print("controller.offset -============== ${controller.offset}");

      setState(() {
        leftContainer = value;
        middleList = value2;
      });
    });
    final products = ref.watch(productsNotifier).value;
    final categories = ref.watch(categoriesNotifier).value;

    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Container(
          color: Colors.grey,
          height: 500,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: products != null
                      ? ListView.builder(
                          controller: controller,
                          itemCount: products.length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            LabeledGlobalKey key =
                                LabeledGlobalKey(index.toString());
                            ref.read(productItemNotifier.notifier).setProduct(
                                ProductItem(
                                    index: index,
                                    product: products[index],
                                    offset: 0.0,
                                    isActive: false));
                            double scale = 1.0;
                            if (leftContainer > 0.5) {
                              scale = index + 0.5 - leftContainer;
                              if (scale < 0) {
                                scale = 0;
                              } else if (scale > 1) {
                                scale = 1;
                              }
                            }

                            return Opacity(
                              opacity: scale,
                              child: Transform(
                                  transform: Matrix4.identity()
                                    ..scale(scale, scale),
                                  alignment: Alignment.centerLeft,
                                  child: ProductCard(
                                    product: products[index],
                                    labelKey: key,
                                    categories: categories!,
                                    index: index,
                                    screenSize: constraints.maxWidth,
                                  )),
                            );
                          })
                      : const SizedBox()),
            ],
          ),
        ),
      );
    });
  }
}
