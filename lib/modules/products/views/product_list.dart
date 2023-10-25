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

  double itemWidth = 300.0;

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsNotifier).value;
    final categories = ref.watch(categoriesNotifier).value;
    int itemCount = products!.length;

    int selected = ref.watch(selectedProductNotifier);

    FixedExtentScrollController scrollController =
        ref.watch(scrollListNotifier(selected));

    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: (9 / 17) * MediaQuery.of(context).size.height,
          width: constraints.maxWidth,
          child: RotatedBox(
              quarterTurns: -1,
              child: ListWheelScrollView.useDelegate(
                perspective: 0.0001,
                squeeze: 1,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (x) {
                  ref.read(selectedProductNotifier.notifier).setSelected(x);
                },
                controller: scrollController,
                childDelegate: ListWheelChildLoopingListDelegate(
                    children: List.generate(itemCount, (index) {
                  return RotatedBox(
                    quarterTurns: 1,
                    child: ProductCard(
                      product: products[index],
                      categories: categories!,
                      index: index,
                    ),
                  );
                })),
                itemExtent: itemWidth,
              )),
        ),
      );
    });
  }
}
