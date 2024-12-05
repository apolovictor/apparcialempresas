import 'package:cached_firestorage/lib.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'dart:ui_web' as ui;

import '../controller/product_register.dart';
import '../controller/products_notifier.dart';
import '../model/products_model.dart';

class ProductCardImage extends HookConsumerWidget {
  const ProductCardImage({
    super.key,
    required this.product,
    required this.productLength,
  });
  final Product product;
  final int productLength;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    // useValueChanged(ref.watch(isReloagingImgNotifier), (_, __) async {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     // if (filter['category'].isEmpty) {
    //     List<Product>? products = ref.watch(productProvider).value;
    //     if (products != null) {
    //       print("products.length useValueChanged ==== ${products.length}");
    //       // ref.read(pictureProductListProvider.notifier).clear();
    //       for (var i = 0; i < products.length; i++) {
    //         WidgetsBinding.instance.addPostFrameCallback((_) {
    //           ref.read(pictureProductListProvider.notifier).add(
    //               RemotePicture(
    //                 mapKey: product.logo!,
    //                 imagePath:
    //                     'gs://appparcial-123.appspot.com/products/${product.logo!}',
    //               ),
    //               products.length);
    //         });
    //       }
    //     }
    //     ref.read(isReloagingImgNotifier.notifier).isReloadingImg(false);
    //     // ref.read(lastProductNotifier.notifier).clearLastProduct();
    //   });
    // });

    List<dynamic> cachePictures = kIsWeb
        ? ref.watch(pictureProductListProvider)
        : ref.watch(pictureProductListAndroidProvider);

    return kIsWeb
        ? cachePictures.any(<RemotePicture>(e) => e.mapKey == product.logo)
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    height: height < 750 ? 100 : 150,
                    child: cachePictures.firstWhere(
                        <RemotePicture>(e) => e.mapKey == product.logo)
                    //  HtmlElementView(
                    //   viewType: 'example',
                    // )
                    //
                    ),
              )
            : const SizedBox()
        : cachePictures.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    height: height < 750 ? 100 : 150,
                    child: StreamBuilder<FileResponse>(
                      stream: ref
                          .watch(pictureProductListAndroidProvider.notifier)
                          .downLoadFile(product.logo!),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          FileInfo fileInfo = snapshot.data as FileInfo;
                          return Image.file(
                            fileInfo.file,
                            fit: BoxFit.scaleDown,
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )),
              )
            : const SizedBox();
  }
}
