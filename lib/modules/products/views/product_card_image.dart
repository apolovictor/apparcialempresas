import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/products_notifier.dart';
import '../model/products_model.dart';

class ProductCardImg extends HookConsumerWidget {
  const ProductCardImg({
    super.key,
    required this.product,
  });
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;

    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          height: height < 750 ? 100 : 150,
          child: ref
              .watch(pictureProductListProvider)
              .firstWhere((element) => element.mapKey == product.logo)),
    );
  }
}
