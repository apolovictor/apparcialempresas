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
    required this.labelKey,
    required this.index,
    required this.screenSize,
    // required this.isActive,
    // required this.productItem,
  });

  final Product product;
  final List<Categories> categories;
  final GlobalKey labelKey;
  final int index;
  final double screenSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<ProductItem> item = ref.watch(productItemNotifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var currentBox = labelKey.currentContext?.findRenderObject() as RenderBox;
      ref.read(productItemNotifier.notifier).updateOffset(
          index,
          ProductItem(
              index: index,
              product: product,
              offset: currentBox.localToGlobal(Offset.zero).dx,
              isActive: (item[index].offset > screenSize / 2 + 160 &&
                      item[index].offset < screenSize / 2 + 300)
                  ? true
                  : false));
    });

    return LayoutBuilder(builder: (context, constraints) {
      print(constraints.maxHeight);
      return Container(
        width: 260,
        child: Stack(
          children: [
            Center(
              child: AnimatedContainer(
                key: labelKey,
                duration: const Duration(milliseconds: 375),
                height: item[index].isActive == true ? 280.0 : 260.0,
                width: item[index].isActive == true ? 200.0 : 180.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    color: product.categories.isNotEmpty
                        ? Color(int.parse(
                            '${categories.firstWhere((element) => element.documentId == product.categories).color}'))
                        : Colors.grey[300],
                    child: Column(
                      children: [Text(product.name)],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.155, 0.75),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 375),
                    curve: Curves.easeOut,
                    height: 180.0,
                    width: item[index].isActive == true ? 160.0 : 0.0,
                    padding: const EdgeInsets.all(14.0),
                    decoration:
                        BoxDecoration(color: Colors.redAccent.withOpacity(0.7)),
                    child: AnimatedOpacity(
                      opacity: item[index].isActive == true ? 1.0 : 0.0,
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
                alignment: item[index].isActive == true
                    ? Alignment(0.55, 0.95)
                    : Alignment(0.0, 0.60),
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
            //   left: item[index].isActive == true ? 135 : 0,
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
        ),
      );
    });
  }
}
