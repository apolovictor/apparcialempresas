import 'package:cached_firestorage/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:html';
import 'dart:ui_web' as ui;

import '../controller/product_register.dart';
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
    useValueChanged(ref.watch(isReloagingImgNotifier), (_, __) async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // if (filter['category'].isEmpty) {
        ref.read(exampleProvider.notifier);
        List<Product>? products = ref.watch(exampleProvider).value;
        if (products != null) {
          ref.read(pictureProductListProvider.notifier).clear();
          for (var i = 0; i < products.length; i++) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(pictureProductListProvider.notifier).fetchPictureList(
                  RemotePicture(
                    mapKey: product.logo!,
                    imagePath:
                        'gs://appparcial-123.appspot.com/products/${product.logo!}',
                  ),
                  products.length);
            });
          }
        }
        ref.read(isReloagingImgNotifier.notifier).isReloadingImg(false);
        ref.read(lastProductNotifier.notifier).clearLastProduct();
      });
    });

    return ref
            .watch(pictureProductListProvider)
            .any((element) => element.mapKey == product.logo)
        ? ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                height: height < 750 ? 100 : 150,
                child: ref
                    .watch(pictureProductListProvider)
                    .firstWhere((element) => element.mapKey == product.logo)
                //  HtmlElementView(
                //   viewType: 'example',
                // )
                //
                ),
          )
        : const SizedBox();
  }
}
