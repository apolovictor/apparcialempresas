import 'package:cached_firestorage/lib.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/products_model.dart';

class ProductCardImg extends HookConsumerWidget {
  const ProductCardImg({
    super.key,
    required this.product,
    required this.remotePicture,
  });
  final Product product;
  final RemotePicture remotePicture;

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
          child: remotePicture

          //  FutureBuilder<String>(
          //     future: CachedFirestorage.instance.getDownloadURL(
          //       mapKey: product.logo!,
          //       filePath:
          //           'gs://appparcial-123.appspot.com/products/${product.logo!}',
          //     ),
          //     builder: (_, snapshot) =>
          //         snapshot.connectionState == ConnectionState.waiting
          //             ? const SizedBox()
          //             : snapshot.hasError
          //                 ? const Text('An error occurred')
          //                 : Image.network(
          //                     snapshot.data!,
          //                     height: 100,
          //                   )),
          ),
    );
  }
}
