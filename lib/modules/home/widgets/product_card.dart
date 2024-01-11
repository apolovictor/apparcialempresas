import 'package:apparcialempresas/modules/products/model/products_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_notifier.dart';

class ProductCardDashboard extends HookConsumerWidget {
  const ProductCardDashboard({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "R\$ ${product.price.price}",
                    style: const TextStyle(fontSize: 17, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Quantidade ${product.quantity}",
                    style: const TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              ref
                      .watch(pictureProductListProvider)
                      .any((element) => element.mapKey == product.logo)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.all(12),
                          width: 100,
                          height: 100,
                          child: ref
                              .watch(pictureProductListProvider)
                              .firstWhere(
                                  (element) => element.mapKey == product.logo)),
                    )
                  : const SizedBox()
            ],
          ),
        ));
  }
}
