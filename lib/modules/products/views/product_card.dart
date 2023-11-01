import 'dart:ui';

import 'package:cached_firestorage/lib.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';
import '../controller/products_notifier.dart';
import '../model/products_model.dart';
import 'product_card_image.dart';

class ProductCard extends HookConsumerWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.index,
    required this.remotePicture,
  });

  final Product product;

  final RemotePicture remotePicture;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selected = ref.watch(selectedProductNotifier);

    bool isActiveProductRegister = ref.watch(isProductsOpenedProvider);
    final categories = ref.watch(categoriesNotifier).value;

    double height = MediaQuery.of(context).size.height;

    return LayoutBuilder(builder: (context, constraints) {
      return InkWell(
        onLongPress: () {
          print(true);
        },
        child: Stack(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: height > 900 ? 60 : 10, right: 25.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 375),
                height: selected == index && height > 800
                    ? 350.0
                    : selected == index && height < 800
                        ? 280
                        : height < 800
                            ? 240
                            : 300.0,
                width: selected == index ? 450.0 : 400.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: categories != null
                      ? Container(
                          color: product.categories.isNotEmpty
                              ? Color(int.parse(
                                  '${categories.firstWhere((element) => element.documentId == product.categories).color}'))
                              : Colors.grey[300],
                          child: Column(
                            children: [
                              ProductCardImg(
                                product: product,
                                remotePicture: remotePicture,
                              ),
                              Text(
                                product.name,
                                style: Theme.of(context).textTheme.labelLarge,
                              )
                            ],
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            ),
            Positioned(
              // alignment: const Alignment(-0.155, 0.55),
              left: 35,
              bottom: height > 1400
                  ? 200
                  : height > 1250
                      ? 150
                      : height > 1100
                          ? 100
                          : height > 1000
                              ? 50
                              : height > 900
                                  ? 25
                                  : 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 375),
                    curve: Curves.easeOut,
                    height: height > 900
                        ? 200.0
                        : height > 750
                            ? 150
                            : 100,
                    width: selected == index ? 200.0 : 0.0,
                    padding: const EdgeInsets.all(14.0),
                    decoration:
                        BoxDecoration(color: Colors.black12.withOpacity(0.3)),
                    child: AnimatedOpacity(
                      opacity: selected == index ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: const SingleChildScrollView(
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
                    ? Alignment(
                        0.65,
                        height > 1400
                            ? 0.5
                            : height > 1250
                                ? 0.6
                                : height > 1100
                                    ? 0.75
                                    : height > 1000
                                        ? 0.9
                                        : height > 900
                                            ? 1.0
                                            : 0.9,
                      )
                    : Alignment(
                        0.0,
                        height > 1300
                            ? 0
                            : height > 1200
                                ? 0.1
                                : height > 1100
                                    ? 0.2
                                    : height > 1000
                                        ? 0.3
                                        : height > 900
                                            ? 0.5
                                            : 0.35),
                duration: const Duration(milliseconds: 375),
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(30.0)),
                  child: InkWell(
                    onTap: () {
                      ref
                          .read(selectedProductNotifier.notifier)
                          .setSelected(index);
                      if (isActiveProductRegister == true) {
                        ref
                            .read(isProductsOpenedProvider.notifier)
                            .fetch(false);
                        Future.delayed(const Duration(milliseconds: 400), () {
                          ref
                              .read(isActiveEditNotifier.notifier)
                              .setIsActiveEdit(true);
                        });
                      } else {
                        ref
                            .read(isActiveEditNotifier.notifier)
                            .setIsActiveEdit(true);
                      }
                    },
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
