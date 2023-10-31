import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';
import '../controller/products_notifier.dart';
import '../model/products_model.dart';

class ProductCardImg extends HookConsumerWidget {
  const ProductCardImg({
    super.key,
    required this.product,
    this.productPhoto,
  });

  final Product product;
  final String? productPhoto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;

    // Future<String> downloadUrl(icon) async {
    //   var downloadUrl = storage.ref("products").child(icon).getDownloadURL();

    //   print(storage.ref("products").child(icon));

    //   return downloadUrl;
    // }

    List<UrlProduct> productstListPhoto = ref.watch(imageProductsNotifier);
    print(true);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(12),
        width: double.infinity,
        height: height < 750 ? 100 : 150,
        child: product.logo != null
            ? productstListPhoto
                    .where((element) => element.title == product.logo)
                    .isNotEmpty
                ? Card(
                    color: Colors.transparent,
                    elevation: 5,
                    child: SvgPicture.network(
                      productstListPhoto
                          .firstWhere(
                              (element) => element.title == product.logo)
                          .url,
                      height: height < 750 ? 100 : 200,
                      // fit: BoxFit.cover,
                    )

                    //  FutureBuilder<String>(
                    //     future: downloadUrl(product.logo),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.connectionState == ConnectionState.waiting) {
                    //         return Center(
                    //           child: Container(
                    //             color: Colors.grey[200],
                    //           ),
                    //         );
                    //       } else {
                    //         if (snapshot.data != null) {
                    //           return Image.network(
                    //             ref.read(imageProductNotifier.notifier).downloadUrl(product.logo),
                    //             cacheWidth: 380,
                    //             cacheHeight: height < 750 ? 100 : 150,
                    //             height: height < 750 ? 100 : 200,
                    //             // fit: BoxFit.cover,
                    //           );
                    //         } else {
                    //           return const SizedBox();
                    //         }
                    //       }
                    //     }),
                    )
                : SizedBox()
            : SizedBox(),
      ),
    );
  }
}
