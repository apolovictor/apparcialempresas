import 'package:cached_firestorage/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';
import '../controller/product_register.dart';
import '../controller/products_notifier.dart';
import '../model/products_model.dart';
import 'product_card.dart';

class ProductsList extends HookConsumerWidget {
  const ProductsList({
    super.key,
  });

  final double itemWidth = 300.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selected = ref.watch(selectedProductNotifier);

    final filter = ref.watch(filterNotifier);

    List<Product> filteredProducts = ref.watch(filteredProductListProvider);
    List<Product>? products = ref.watch(exampleProvider).value;

    useValueChanged(filter, (_, __) async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(filteredProductListProvider.notifier).fetchFilteredList(
            products!
                .where((product) => product.categories == filter['category'])
                .toList());
      });
    });
    useValueChanged(products, (_, __) async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (filter['category'].isNotEmpty) {
          ref.read(filteredProductListProvider.notifier).fetchFilteredList(
              products!
                  .where((product) => product.categories == filter['category'])
                  .toList());
        }
      });
    });

    FixedExtentScrollController scrollController =
        ref.watch(scrollListNotifier(selected));

    return products != null || filteredProducts.length > 0
        ? LayoutBuilder(builder: (context, constraints) {
            print("Hereee");
            for (var i = 0; i < products!.length; i++) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(pictureProductListProvider.notifier).fetchPictureList(
                    RemotePicture(
                      mapKey: products[i].logo!,
                      imagePath:
                          'gs://appparcial-123.appspot.com/products/${products[i].logo!}',
                    ),
                    products.length);
              });
            }
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
                                ? filteredProducts.length
                                : products.length, (index) {
                      return RotatedBox(
                          quarterTurns: 1,
                          child: filter['category'].isNotEmpty
                              ? ProductCard(
                                  index: index,
                                  product: filteredProducts[index],
                                )
                              : ProductCard(
                                  index: index,
                                  product: products[index],
                                ));
                    })),
                    itemExtent: itemWidth,
                  ),
                ),
              ),
            );
          })
        : const SizedBox();
  }
}
