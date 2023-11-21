import 'package:cached_firestorage/lib.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';
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

    // final filter = ref.watch(filterNotifier);

    // List<Product> filteredProducts = ref.watch(filteredProductListProvider);
    List<Product>? products = ref.watch(productProvider).value;
    AsyncValue<List<Product>> filteredProducts =
        ref.watch(filteredProductsProvider(products ?? []));

    // useValueChanged(filter, (_, __) async {
    //   // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(filteredProductListProvider.notifier).fetchFilteredList(products!
    //       .where((product) => product.categories == filter['category'])
    //       .toList());
    //   // });
    // });
    // useValueChanged(products, (_, __) async {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     if (filter['category'].isNotEmpty) {
    //       ref.read(filteredProductListProvider.notifier).fetchFilteredList(
    //           products!
    //               .where((product) => product.categories == filter['category'])
    //               .toList());
    //     }
    //   });
    // });

    //!! TRY TO FIX THE FILTER CATEGORY PROBLEM WHEN SCROLL MUCH FAST THE PRODUCT LIST WITH NeverScrollableScrollPhysics() FUNCTION ON SCROLLCONTROLLER ACTIVATED HERE AND CHECK
    //!! THE STATUS ON CATEGORY FILTER WIDGET
    FixedExtentScrollController scrollController =
        ref.watch(scrollListNotifier(selected));

    return LayoutBuilder(builder: (context, constraints) {
      if (products != null) {
        for (var i = 0; i < products.length; i++) {
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
                children: filteredProducts.when(
                  data: (List<Product> data) {
                    return
                        //  filter['category'].isNotEmpty
                        //     ?
                        selected < data.length
                            ? List.generate(data.length, (index) {
                                return RotatedBox(
                                    quarterTurns: 1,
                                    child: ProductCard(
                                      index: index,
                                      product: data[index],
                                    ));
                              })
                            : [SizedBox()];
                  },
                  error: (err, stack) => [Text('Error: $err')],
                  loading: () => [CircularProgressIndicator()],
                ),
              ),
              itemExtent: itemWidth,
            ),
          ),
        ),
      );
    });
  }
}
