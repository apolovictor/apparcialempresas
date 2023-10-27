import 'dart:async';

import 'package:apparcialempresas/modules/products/controller/product_list.notifier.dart';
import 'package:apparcialempresas/modules/products/model/products_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/products_notifier.dart';

class ProductDetailScreen extends HookConsumerWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isLoadingWidget = ref.watch(isLoadingWidgetProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // executes after build
      ref.read(isActiveEditNotifier.notifier).setIsActiveEdit(false);
    });
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final controller =
        useAnimationController(duration: const Duration(milliseconds: 375));

    final Animation<double> containerScaleTweenAnimation =
        Tween(begin: .0, end: width).animate(CurvedAnimation(
            parent: getProductController(ref), curve: Curves.ease));
    final Animation<double> containerAlignTweenAnimation =
        Tween(begin: 0.0, end: -1.0).animate(CurvedAnimation(
            parent: getProductController(ref), curve: Curves.ease));

    final Animation<double> containerBorderRadiusAnimation =
        Tween(begin: 100.0, end: 15.0).animate(CurvedAnimation(
            parent: getProductController(ref), curve: Curves.ease));

    var timer = Timer(
      const Duration(milliseconds: 300),
      () {
        if (isLoadingWidget == false) {
          ref.read(isLoadingWidgetProvider.notifier).fetch(true);
        }
      },
    );

    controller.addStatusListener((status) {
      if (AnimationStatus.completed == controller.status) {
        timer.cancel();
      }
    });

    return isLoadingWidget
        ? Scaffold(
            backgroundColor: Colors.amber,
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
                                tag: 'detailProduct',
                                child: Container(
                                  height: containerScaleTweenAnimation.value,
                                  width: containerScaleTweenAnimation.value,
                                  padding: const EdgeInsets.all(8.0),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      color: Color(int.parse(product.color)),
                                      borderRadius: BorderRadius.circular(
                                          containerBorderRadiusAnimation
                                              .value)),
                                  child: child,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            height: containerScaleTweenAnimation.value,
                            width: containerScaleTweenAnimation.value,
                            padding: const EdgeInsets.all(8.0),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: Color(int.parse(product.color)),
                                borderRadius: BorderRadius.circular(
                                    containerBorderRadiusAnimation.value)),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
