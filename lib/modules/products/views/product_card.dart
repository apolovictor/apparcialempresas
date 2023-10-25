import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:ui';

import '../controller/product_list.notifier.dart';
import '../controller/products_notifier.dart';
import '../model/products_model.dart';

class ProductCard extends HookConsumerWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.categories,
    required this.index,
  });

  final Product product;
  final List<Categories> categories;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selected = ref.watch(selectedProductNotifier);

    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60, right: 25.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 375),
              height: selected == index ? 350.0 : 300.0,
              width: selected == index ? 450.0 : 400.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  color: product.categories.isNotEmpty
                      ? Color(int.parse(
                          '${categories.firstWhere((element) => element.documentId == product.categories).color}'))
                      : Colors.grey[300],
                  child: Column(
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.labelLarge,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-0.155, 0.25),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 375),
                  curve: Curves.easeOut,
                  height: 220.0,
                  width: selected == index ? 200.0 : 0.0,
                  padding: const EdgeInsets.all(14.0),
                  decoration:
                      BoxDecoration(color: Colors.redAccent.withOpacity(0.7)),
                  child: AnimatedOpacity(
                    opacity: selected == index ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text("Bloquear"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: AnimatedAlign(
              alignment: selected == index
                  ? Alignment(0.65, 0.50)
                  : Alignment(0.0, 0.12),
              duration: const Duration(milliseconds: 375),
              child: Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(30.0)),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // AnimatedPositioned(
          //   duration: const Duration(milliseconds: 375),
          //   bottom: 0,
          //   left: selected == true ? 135 : 0,
          //   // alignment: const Alignment(0.25, 0.47),
          //   // curve: Curves.easeOut,
          //   child: Container(
          //     height: 50.0,
          //     width: 50.0,
          //     decoration: BoxDecoration(
          //         color: Colors.purple,
          //         borderRadius: BorderRadius.circular(30.0)),
          //     child: const Icon(
          //       Icons.arrow_forward,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      );
    });
  }
}
