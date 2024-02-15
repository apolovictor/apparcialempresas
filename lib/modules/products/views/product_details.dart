import 'package:botecaria/modules/products/controller/product_list.notifier.dart';
import 'package:botecaria/modules/products/model/products_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/products_notifier.dart';

class ProductDetailScreen extends HookConsumerWidget {
  ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // executes after build
      ref.read(isActiveEditNotifier.notifier).setIsActiveEdit(false);
    });
    final double width = MediaQuery.of(context).size.width;
    // final double height = MediaQuery.of(context).size.height;
    final controller =
        useAnimationController(duration: const Duration(milliseconds: 750));
    int selected = ref.watch(selectedProductNotifier);

    final Animation<double> containerScaleTweenAnimation =
        Tween(begin: .0, end: width)
            .animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
    final Animation<double> containerAlignTweenAnimation =
        Tween(begin: 0.0, end: -1.0)
            .animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    final Animation<double> containerBorderRadiusAnimation =
        Tween(begin: 100.0, end: 15.0)
            .animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    controller.forward();

    List<Product>? products = ref.watch(productProvider).value;

    AsyncValue<List<Product>> filteredProducts =
        ref.watch(filteredProductsProvider(products!));

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: AnimatedBuilder(
                    animation: containerScaleTweenAnimation,
                    builder: (context, child) {
                      return Align(
                          alignment: Alignment(
                              containerAlignTweenAnimation.value,
                              containerAlignTweenAnimation.value),
                          child: Hero(
                            tag: 'detailProduct$selected',
                            child: Container(
                              height: containerScaleTweenAnimation.value,
                              width: containerScaleTweenAnimation.value,
                              padding: const EdgeInsets.all(8.0),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  color: filteredProducts.when(
                                    data: (List<Product> data) {
                                      return Color(int.parse(
                                          data[selected].primaryColor));
                                    },
                                    error: (err, stack) => Colors.transparent,
                                    loading: () => Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      containerBorderRadiusAnimation.value)),
                              child: Center(
                                child: filteredProducts.when(
                                  data: (List<Product> data) {
                                    return Text(
                                      data[selected].name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 125,
                                          color: Colors.black54),
                                    );
                                  },
                                  error: (err, stack) => Text(''),
                                  loading: () => Text(''),
                                ),
                              ),
                            ),
                          ));
                    },
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
