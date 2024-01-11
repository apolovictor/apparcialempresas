import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';
import '../controller/product_update.dart';
import '../controller/products_notifier.dart';
import '../model/products_model.dart';
import 'product_card_image.dart';
import 'product_card_information.dart';

class ProductCard extends HookConsumerWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.index,
  });

  final Product product;

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selected = ref.watch(selectedProductNotifier);

    bool isActiveProductRegister = ref.watch(isProductsOpenedProvider);

    // List<Product> filteredProducts = ref.watch(filteredProductListProvider);
    // List<Product>? products = ref.watch(exampleProvider).value;
    final categories = ref.watch(categoriesNotifier).value;
    const Color backgroundColor = Colors.black38;
    const Color shadowColor = Colors.black45;

    double height = MediaQuery.of(context).size.height;

    return categories != null
        ? Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 375),
                margin: const EdgeInsets.all(16.0),
                height: selected == index && height > 800
                    ? 350.0
                    : selected == index && height < 750
                        ? 280
                        : height < 750
                            ? 280
                            : 350.0,
                width: selected == index ? 450.0 : 400.0,
                decoration: BoxDecoration(
                  color: product.categories.isNotEmpty
                      ? product.status == 1
                          ? Color(int.parse(
                              '${categories.firstWhere((element) => element.documentId == product.categories).color}'))
                          : Colors.grey[300]
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12.0),
                    splashColor: product.categories.isNotEmpty
                        ? Color(int.parse(product.secondaryColor))
                            .withOpacity(0.7)
                        : Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              ProductCardImg(
                                product: product,
                              ),
                              Text(
                                product.name,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              SizedBox(
                                height: 75,
                                width: 400,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    BasicInformations(
                                      index: index,
                                      icon: const Icon(Icons.star),
                                      price: product.price,
                                      quantity: product.quantity,
                                    ),
                                    BasicInformations(
                                      index: index,
                                      icon: const Icon(
                                        Icons.attach_money_rounded,
                                      ),
                                      price: product.price,
                                      quantity: product.quantity,
                                    ),

                                    //!! status of amount on stock:
                                    //**charging_station it's ok
                                    //todo security_update_warning warning, need attention
                                    //?? screen_lock_portrait it's blocked by the user
                                    //!! mobile_off it's over. need be replace

                                    BasicInformations(
                                      index: index,
                                      icon: const Icon(
                                          Icons.local_fire_department),
                                      price: product.price,
                                      quantity: product.quantity,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                // alignment: const Alignment(-0.155, 0.55),
                left: 50,
                bottom: height > 1400
                    ? 275
                    : height > 1300
                        ? 225
                        : height > 1200
                            ? 175
                            : height > 1100
                                ? 125
                                : height > 1000
                                    ? 75
                                    : 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 375),
                      curve: Curves.easeOut,
                      height: height > 900
                          ? 160.0
                          : height > 750
                              ? 130
                              : 100,
                      width: selected == index ? 200.0 : 0.0,
                      padding: const EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.2),
                                Colors.black.withOpacity(0.5),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                          border:
                              Border.all(color: Colors.black.withOpacity(0.05)),
                          borderRadius: BorderRadius.circular(20.0)
                          // color: Colors.black12.withOpacity(0.3)
                          ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              product.status == 1 ? 'Bloquear' : 'Ativar',
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 16),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(32),
                                  boxShadow: [
                                    product.status == 1
                                        ? const BoxShadow(
                                            color: shadowColor,
                                            offset: Offset(4, 4),
                                            blurRadius: 2)
                                        : const BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(1, 4)),
                                    product.status == 1
                                        ? const BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(-4, -4),
                                            blurRadius: 2)
                                        : const BoxShadow(
                                            color: shadowColor,
                                            offset: Offset(-1, -4)),
                                  ]),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    ref
                                        .read(updateProductProvider)
                                        .updateStatusProduct(
                                            product.documentId!,
                                            product.status == 1 ? 2 : 1);
                                  },
                                  borderRadius: BorderRadius.circular(32.0),
                                  splashColor: Colors.white60,
                                  child: Center(
                                      child: Icon(product.status == 1
                                          ? Icons.block_outlined
                                          : Icons
                                              .check_circle_outline_outlined)),
                                ),
                              ),
                            ),
                          ],
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
                          0.75,
                          height > 1400
                              ? 0.3
                              : height > 1300
                                  ? 0.35
                                  : height > 1200
                                      ? 0.5
                                      : height > 1100
                                          ? 0.65
                                          : height > 1000
                                              ? 0.8
                                              : height > 900
                                                  ? 1.0
                                                  : 0.9,
                        )
                      : Alignment(
                          0.0,
                          height > 1500
                              ? -0.15
                              : height > 1400
                                  ? -0.05
                                  : height > 1300
                                      ? 0.05
                                      : height > 1200
                                          ? 0.15
                                          : height > 1100
                                              ? 0.25
                                              : height > 1000
                                                  ? 0.35
                                                  : height > 900
                                                      ? 0.5
                                                      : height > 800
                                                          ? 0.7
                                                          : 0.7),
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
          )
        : const SizedBox();
  }
}
