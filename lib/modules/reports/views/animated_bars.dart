import 'package:cached_firestorage/remote_picture.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../products/controller/products_notifier.dart';
import '../models/reports_model.dart';

class AnimatedBars extends HookConsumerWidget {
  const AnimatedBars(
      {super.key,
      required this.product,
      required this.width,
      required this.height});
  final Product product;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AnimationController productController =
        useAnimationController(duration: const Duration(milliseconds: 1000));

    Animation<double> productanimation =
        Tween<double>(begin: .0, end: 1.0).animate(CurvedAnimation(
      parent: productController,
      curve: Curves.ease,
    ));
    productController.forward();
    List<dynamic> cachePictures = kIsWeb
        ? ref.watch(pictureProductListProvider)
        : ref.watch(pictureProductListAndroidProvider);
    return ScaleTransition(
      scale: productanimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          product.logo != null
              ? kIsWeb
                  ? Container(
                      width: width / 6,
                      height: height * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.transparent,
                      ),
                      padding: const EdgeInsets.only(bottom: 10),
                      child: RemotePicture(
                        mapKey: product.logo!,
                        imagePath:
                            'gs://appparcial-123.appspot.com/products/${product.logo}',
                      ),
                    )
                  : cachePictures.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.transparent,
                              ),
                              padding: const EdgeInsets.all(12),
                              width: double.infinity,
                              height: 100,
                              child: StreamBuilder<FileResponse>(
                                stream: ref
                                    .watch(pictureProductListAndroidProvider
                                        .notifier)
                                    .downLoadFile(product.logo!),
                                builder: (_, snapshot) {
                                  if (snapshot.hasData) {
                                    FileInfo fileInfo =
                                        snapshot.data as FileInfo;
                                    return ClipOval(
                                      child: SizedBox.fromSize(
                                        size: const Size.fromRadius(60),
                                        child: Image.file(
                                          fileInfo.file,
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              )),
                        )
                      : const SizedBox()
              : const SizedBox(),
          Expanded(
            child: Material(
              child: Text(
                product.name,
                style: const TextStyle(color: Colors.black87, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
