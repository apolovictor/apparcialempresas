import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';
import '../controller/products_notifier.dart';

class ProductsList extends HookConsumerWidget {
  const ProductsList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsNotifier).value;
    double width = ref.watch(widthProductCardNotifier);
    double opacity = 0.0;
    return Stack(
      children: [
        MouseRegion(
          onEnter: (value) {
            ref.read(widthProductCardNotifier.notifier).fetchWidth(160.0);
            Future.delayed(Duration(milliseconds: 175), () {
              ref.read(opacityProductCardNotifier.notifier).fetchOpacity(1.0);
            });
          },
          onExit: (value) {
            ref.read(widthProductCardNotifier.notifier).fetchWidth(0.0);
            Future.delayed(Duration(milliseconds: 175), () {
              ref.read(opacityProductCardNotifier.notifier).fetchOpacity(0.0);
            });
          },
          child: Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 375),
              height: width == 0.0 ? 260.0 : 280.0,
              width: width == 0.0 ? 180.0 : 200.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  color: Colors.grey[300],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(-0.115, 0.55),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 375),
                curve: Curves.easeOut,
                height: 150.0,
                width: width,
                padding: EdgeInsets.all(14.0),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
                child: AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(milliseconds: 500),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
