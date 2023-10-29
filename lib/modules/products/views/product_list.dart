import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';
import '../controller/products_notifier.dart';
import '../model/products_model.dart';
import 'product_card.dart';

GlobalKey<AnimatedListState> _listKey2 = GlobalKey<AnimatedListState>();

class ProductsList extends HookConsumerWidget {
  ProductsList({super.key, required this.products});
  List<Product> products;

  // ScrollController controller = ScrollController();
  bool lloseLeftContainer = false;
  double leftContainer = 0;
  double middleList = 0;

  List<Product> itemsData = [];
  bool isTransform = false;

  double itemWidth = 300.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesNotifier).value;

    int selected = ref.watch(selectedProductNotifier);

    FixedExtentScrollController scrollController =
        ref.watch(scrollListNotifier(selected));
    // final categories = ref.watch(categoriesNotifier).value;

    final filter = ref.watch(filterNotifier);
    List<Product> listProducts = filter['category'].isNotEmpty
        ? ref.watch(filteredProductListProvider)
        : products;

    useValueChanged(filter, (_, __) async {
      print("here");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(filteredProductListProvider.notifier).fetchFilteredList(
            products
                .where((product) => product.categories == filter['category'])
                .toList());
      });
    });

    return LayoutBuilder(builder: (context, constraints) {
      print("rebeuild");
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
                    children: List.generate(
                        filter['category'].isNotEmpty
                            ? listProducts.length
                            : products.length, (index) {
                  return RotatedBox(
                    quarterTurns: 1,
                    child: ProductCard(
                      product: filter['category'].isNotEmpty
                          ? listProducts[index]
                          : products[index],
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
