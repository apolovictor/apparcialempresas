import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';
import '../controller/products_notifier.dart';
import '../model/products_model.dart';
import '../widgets/submit_button.dart';
import 'categories_list.dart';
import 'product_details_impl.dart';
import 'product_list.dart';
import 'product_quick_edit.dart';

class ProductScreen extends HookConsumerWidget {
  ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool displayMobileLayout = MediaQuery.of(context).size.width < 600;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int productSelected = ref.watch(selectedProductNotifier);
    final filter = ref.watch(filterNotifier);

    List<Product> filteredProducts = ref.watch(filteredProductListProvider);
    List<Product>? products = ref.watch(exampleProvider).value;

    bool isActiveEdit = ref.watch(isActiveEditNotifier);
    bool isActiveProductRegister = ref.watch(isProductsOpenedProvider);

    // if (filter['category'].isNotEmpty) {
    //   print(filteredProducts.length);
    // } else {
    //   if (products != null) {
    //     print("products ========== ${products.length}");
    //   }
    // }

    final Animation<double> containerScaleTweenAnimation =
        Tween(begin: .0, end: MediaQuery.of(context).size.width * 0.3).animate(
            CurvedAnimation(
                parent: getCategoriesController(ref), curve: Curves.ease));

    final Animation<double> animation = Tween(begin: .0, end: 1.0).animate(
        CurvedAnimation(
            parent: getQuickFieldsController(ref), curve: Curves.ease));

    final Animation<double> containerAlignTweenAnimation =
        Tween(begin: 0.0, end: -1.0).animate(CurvedAnimation(
            parent: getCategoriesController(ref), curve: Curves.ease));

    final Animation<double> containerBorderRadiusAnimation =
        Tween(begin: 100.0, end: 15.0).animate(CurvedAnimation(
            parent: getCategoriesController(ref), curve: Curves.ease));

    get_chip(Product tagTable, int index) {
      return Container(
        // width: 200,
        // height: 200,
        child: productSelected > -1
            ? ref.watch(pictureProductListProvider).firstWhere(
                (element) => element.mapKey == products![productSelected].logo)
            : SizedBox(),
      );
    }

    generate_tags() {
      return products!
          .asMap()
          .entries
          .map((tag) => get_chip(tag.value, tag.key))
          .toList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: products != null || filteredProducts.isNotEmpty
          ? LayoutBuilder(builder: (context, constraints) {
              return Stack(
                children: [
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 375),
                        width: isActiveEdit || isActiveProductRegister
                            ? width * 0.7
                            : width,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 0,
                              left: !displayMobileLayout
                                  ? MediaQuery.of(context).size.width * 0.05
                                  : 15,
                              right: !displayMobileLayout
                                  ? MediaQuery.of(context).size.width * 0.05
                                  : 15,
                              bottom: 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: height < 806 ? 2 : 3,
                                  child: Container(
                                    color: Colors.black54,
                                    child: Center(
                                      child: Text(
                                        "TOP",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .apply(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: !displayMobileLayout && height > 805
                                      ? 5
                                      : height < 806 && !displayMobileLayout
                                          ? 6
                                          : 2,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Row(children: [
                                          Text(
                                            ' Categorias ',
                                            style: height < 806
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium
                                                : Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge,
                                          ),
                                        ]),
                                        const SizedBox(height: 20),
                                        const Expanded(child: CategoriesList()),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: !displayMobileLayout ? 12 : 4,
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  ' Meus Produtos',
                                                  style: height < 800
                                                      ? Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .headlineLarge,
                                                ),
                                                Row(
                                                  children: [
                                                    FilterChip(
                                                      onSelected: (value) {
                                                        if (isActiveEdit ==
                                                            true) {
                                                          ref
                                                              .read(
                                                                  isActiveEditNotifier
                                                                      .notifier)
                                                              .setIsActiveEdit(
                                                                  false);
                                                          Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      400), () {
                                                            ref
                                                                .read(isProductsOpenedProvider
                                                                    .notifier)
                                                                .fetch(true);
                                                          });
                                                        } else {
                                                          ref
                                                              .read(
                                                                  isProductsOpenedProvider
                                                                      .notifier)
                                                              .fetch(true);
                                                        }
                                                      },
                                                      side: const BorderSide(
                                                          color: Colors
                                                              .transparent),
                                                      backgroundColor:
                                                          Colors.grey[200],
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      label: SizedBox(
                                                          child: Text(
                                                              "Adicionar Produto",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .apply(
                                                                      color: Colors
                                                                          .black87))),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            ProductsList(),
                                          ])),
                                )
                              ]),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 375),
                        width: isActiveProductRegister ? width * 0.3 : 0,
                        height:
                            isActiveProductRegister ? constraints.maxHeight : 0,
                        color: Colors.black12,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(isProductsOpenedProvider.notifier)
                                        .fetch(false);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 375),
                        width: (isActiveEdit && productSelected > -1)
                            ? width * 0.3
                            : 0,
                        height: MediaQuery.of(context).size.height,
                        color: productSelected > -1
                            ? filter['category'].isNotEmpty &&
                                    filteredProducts.isNotEmpty
                                ? Color(int.parse(
                                    filteredProducts[productSelected]
                                        .primaryColor))
                                : products!.isNotEmpty
                                    ? Color(int.parse(
                                        products[productSelected].primaryColor))
                                    : Colors.transparent
                            : Colors.transparent,
                        child: LayoutBuilder(builder: (context, constraints) {
                          return ProducQuickEdit(
                              key: key,
                              height: height,
                              width: width,
                              animation: animation,
                              constraints: constraints);
                        }),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: AnimatedBuilder(
                      animation: containerScaleTweenAnimation,
                      builder: (context, child) {
                        return Align(
                          alignment: Alignment(
                              containerAlignTweenAnimation.value,
                              containerAlignTweenAnimation.value),
                          child: Container(
                            height: containerScaleTweenAnimation.value,
                            width: containerScaleTweenAnimation.value,
                            padding: const EdgeInsets.all(8.0),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(
                                    containerBorderRadiusAnimation.value)),
                            child: child,
                          ),
                        );
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                ),
                                onPressed: () {
                                  ref
                                      .read(isCategoriesOpenedProvider.notifier)
                                      .fetch(false);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            })
          : SizedBox(),
    );
  }
}
