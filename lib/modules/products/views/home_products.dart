import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';
import '../controller/products_notifier.dart';
import '../model/products_model.dart';
import 'categories_list.dart';
import 'product_list.dart';

class ProductScreen extends HookConsumerWidget {
  ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool displayMobileLayout = MediaQuery.of(context).size.width < 600;

    bool isActiveEdit = ref.watch(isActiveEditNotifier);
    bool isActiveProductRegister = ref.watch(isProductsOpenedProvider);

    final Animation<double> containerScaleTweenAnimation =
        Tween(begin: .0, end: MediaQuery.of(context).size.width * 0.3).animate(
            CurvedAnimation(
                parent: getCategoriesController(ref), curve: Curves.ease));

    final Animation<double> containerAlignTweenAnimation =
        Tween(begin: 0.0, end: -1.0).animate(CurvedAnimation(
            parent: getCategoriesController(ref), curve: Curves.ease));

    final Animation<double> containerBorderRadiusAnimation =
        Tween(begin: 100.0, end: 15.0).animate(CurvedAnimation(
            parent: getCategoriesController(ref), curve: Curves.ease));
    List<Product>? products = ref.watch(exampleProvider).value;

    AsyncValue<List<Product>> filteredProducts =
        ref.watch(filteredProductsProvider(products!));

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        return Stack(
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 375),
                  width: isActiveEdit || isActiveProductRegister
                      ? width * 0.7
                      : width,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // width > 1000
                        //     ? Expanded(
                        //         flex: height < 806 ? 1 : 2,
                        //         child: const TopBar(),
                        //       )
                        //     : const SizedBox(),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
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
                                            filteredProducts.when(
                                              data: (List<Product> data) {
                                                return Text(
                                                    data.length.toString());
                                                //  filter['category'].isNotEmpty
                                              },
                                              error: (err, stack) =>
                                                  Text('Error: $err'),
                                              loading: () =>
                                                  CircularProgressIndicator(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            FilterChip(
                                              onSelected: (value) {
                                                if (isActiveEdit == true) {
                                                  ref
                                                      .read(isActiveEditNotifier
                                                          .notifier)
                                                      .setIsActiveEdit(false);
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 400),
                                                      () {
                                                    ref
                                                        .read(
                                                            isProductsOpenedProvider
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
                                                  color: Colors.transparent),
                                              backgroundColor: Colors.grey[200],
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              label: SizedBox(
                                                  child: Text(
                                                      "Adicionar Produto",
                                                      style: Theme.of(context)
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
              ],
            ),

            /// Add Category Widget
            Positioned(
              right: 0,
              bottom: 0,
              child: AnimatedBuilder(
                animation: containerScaleTweenAnimation,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment(containerAlignTweenAnimation.value,
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
      }),
    );
  }
}
