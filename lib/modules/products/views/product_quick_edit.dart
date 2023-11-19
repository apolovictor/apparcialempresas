import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';
import '../controller/products_notifier.dart';
import '../model/products_model.dart';
import '../widgets/quick_fields.dart';
import '../widgets/update_button.dart';
import 'product_details_impl.dart';

class ProducQuickEdit extends HookConsumerWidget {
  const ProducQuickEdit({
    super.key,
    required this.height,
    required this.width,
    required this.constraints,
    required this.products,
  });

  final double height;
  final double width;
  final BoxConstraints constraints;
  final List<Product> products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController productNameController =
        ref.watch(productNameProvider);
    final TextEditingController productPriceController =
        ref.watch(productPriceProvider);
    final TextEditingController productPromoController =
        ref.watch(productPromoProvider);
    final TextEditingController productQuantityController =
        ref.watch(productQuantityProvider);

    int productSelected = ref.watch(selectedProductNotifier);

    final bool isActiveEdit = ref.watch(isActiveEditNotifier);

    Route createRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetails(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }

    // productNameController.addListener(() {
    //   ref
    //       .read(productNameProvider.notifier)
    //       .fetchProductName(productNameController);
    // });

    final Animation<double> animation = Tween(begin: .0, end: 1.0).animate(
        CurvedAnimation(
            parent: getQuickFieldsController(ref), curve: Curves.ease));

    AnimationController editController =
        useAnimationController(duration: const Duration(milliseconds: 0));
    SequenceAnimation sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween(begin: 480.0, end: 440.0),
            curve: Curves.easeOut,
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 50),
            tag: 'imgWidgetSize')
        .addAnimatable(
            animatable: Tween(begin: -100.0, end: 0.0),
            curve: Curves.easeOut,
            from: const Duration(milliseconds: 500),
            to: const Duration(milliseconds: 750),
            tag: 'topPositioned')
        .addAnimatable(
            animatable: Tween<double>(begin: -80, end: 0.0),
            curve: Curves.easeOut,
            from: const Duration(milliseconds: 500),
            to: const Duration(milliseconds: 750),
            tag: 'rightPositioned')
        .animate(editController);
    // useValueChanged(productSelected, (_, __) async {
    //   editController.forward();

    //   editController.addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {
    //       editController.reverse();
    //     }
    //   });
    // });
    editController.forward();
    AsyncValue<List<Product>> filteredProducts =
        ref.watch(filteredProductsProvider(products!));

    return productSelected > -1 && isActiveEdit
        ? AnimatedContainer(
            duration: const Duration(milliseconds: 375),
            width: (isActiveEdit && productSelected > -1) ? width * 0.3 : 0,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                color: productSelected > -1
                    ? filteredProducts.when(
                        data: (List<Product> data) {
                          return Color(
                              int.parse(data[productSelected].primaryColor));
                        },
                        error: (err, stack) => Colors.transparent,
                        loading: () => Colors.transparent,
                      )
                    : Colors.transparent),
            child: Stack(
              children: [
                Positioned(
                    right: -25,
                    top: height * 0.20,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: filteredProducts.when(
                        data: (List<Product> data) {
                          return Text(data[productSelected].name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 125,
                                  color: Colors.black54));
                        },
                        error: (err, stack) {
                          print(err);
                          return const Text('');
                        },
                        loading: () => const Text(''),
                      ),
                    )),
                AnimatedBuilder(
                    animation: editController,
                    builder: (context, child) => AnimatedPositioned(
                          duration: const Duration(milliseconds: 50),
                          curve: Curves.easeInOut,
                          top: sequenceAnimation['topPositioned'].value,
                          right: sequenceAnimation['rightPositioned'].value,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 50),
                            curve: Curves.easeInOut,
                            height: sequenceAnimation['imgWidgetSize'].value,
                            width: sequenceAnimation['imgWidgetSize'].value,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.grey[200]!.withOpacity(0.05),
                                      Colors.white.withOpacity(0.9),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                                border:
                                    Border.all(width: 2, color: Colors.white12),
                                borderRadius: BorderRadius.circular(500.0)),
                          ),
                        )),
                Positioned(
                  top: 0,
                  left: 0,
                  child: SizedBox(
                    height: height,
                    width: width * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 18.0, right: 18.0, top: 18.0, bottom: 48),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.1),
                                        Colors.black.withOpacity(0.7),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter),
                                  border: Border.all(
                                      width: 2, color: Colors.white12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 375),
                                          height: height * 0.4,
                                          width: (isActiveEdit &&
                                                  productSelected > -1)
                                              ? width * 0.3
                                              : 0,
                                          child: productSelected > -1
                                              ? filteredProducts.when(
                                                  data: (List<Product> data) {
                                                    return ref
                                                        .watch(
                                                            pictureProductListProvider)
                                                        .firstWhere((element) =>
                                                            element.mapKey ==
                                                            data[productSelected]
                                                                .logo);
                                                  },
                                                  error: (err, stack) =>
                                                      const Text(''),
                                                  loading: () => const Text(''),
                                                )
                                              : const SizedBox()),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //  Fields
                          Align(
                            alignment: const Alignment(1, 1),
                            child: SizedBox(
                              width: width * 0.3,
                              height: height * 0.4,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  children: [
                                    ScaleTransition(
                                        scale: animation,
                                        child: filteredProducts.when(
                                          data: (List<Product> data) {
                                            return fieldWidget(
                                              productNameController,
                                              productSelected > -1
                                                  ? data[productSelected].name
                                                  : "Nome",
                                              context,
                                              productSelected > -1
                                                  ? Color(int.parse(
                                                      data[productSelected]
                                                          .secondaryColor))
                                                  : Colors.transparent,
                                            );
                                          },
                                          error: (err, stack) => const Text(''),
                                          loading: () => const Text(''),
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ScaleTransition(
                                        scale: animation,
                                        child: filteredProducts.when(
                                          data: (List<Product> data) {
                                            return fieldWidget(
                                              productPriceController,
                                              productSelected > -1
                                                  ? data[productSelected]
                                                      .price['price']
                                                  : "Preço",
                                              context,
                                              productSelected > -1
                                                  ? Color(int.parse(
                                                      data[productSelected]
                                                          .secondaryColor))
                                                  : Colors.transparent,
                                            );
                                          },
                                          error: (err, stack) => const Text(''),
                                          loading: () => const Text(''),
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ScaleTransition(
                                        scale: animation,
                                        child: filteredProducts.when(
                                          data: (List<Product> data) {
                                            return fieldWidget(
                                              productPromoController,
                                              productSelected > -1
                                                  ? data[productSelected]
                                                      .price['promo']
                                                  : "Promoção",
                                              context,
                                              productSelected > -1
                                                  ? Color(int.parse(
                                                      data[productSelected]
                                                          .secondaryColor))
                                                  : Colors.transparent,
                                            );
                                          },
                                          error: (err, stack) => const Text(''),
                                          loading: () => const Text(''),
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ScaleTransition(
                                        scale: animation,
                                        child: filteredProducts.when(
                                          data: (List<Product> data) {
                                            return fieldWidget(
                                              productQuantityController,
                                              productSelected > -1
                                                  ? data[productSelected]
                                                      .quantity
                                                  : "Nome",
                                              context,
                                              productSelected > -1
                                                  ? Color(int.parse(
                                                      data[productSelected]
                                                          .secondaryColor))
                                                  : Colors.transparent,
                                            );
                                          },
                                          error: (err, stack) => const Text(''),
                                          loading: () => const Text(''),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const Alignment(-1.1, 1.1),
                            child: Container(
                                height: 80,
                                width: width * 0.3,
                                child: filteredProducts.when(
                                  data: (List<Product> data) {
                                    UpdateButton(
                                        buttonName: "Salvar",
                                        animation: animation,
                                        product: data[productSelected]);
                                  },
                                  error: (err, stack) => const Text(''),
                                  loading: () => const Text(''),
                                )),
                          ),
                          Align(
                            alignment: const Alignment(-1.1, -1),
                            child: InkWell(
                              onTap: () {
                                ref
                                    .read(isActiveEditNotifier.notifier)
                                    .setIsActiveEdit(false);
                              },
                              child: Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          Align(
                            alignment: const Alignment(-1.1, 1.1),
                            child: Container(
                                height: 80,
                                width: width * 0.3,
                                child: filteredProducts.when(
                                  data: (List<Product> data) {
                                    UpdateButton(
                                        buttonName: "Salvar",
                                        animation: animation,
                                        product: data[productSelected]);
                                  },
                                  error: (err, stack) => const Text(''),
                                  loading: () => const Text(''),
                                )),
                          ),

                          Align(
                            alignment: const Alignment(-1.1, -1),
                            child: InkWell(
                              onTap: () {
                                ref
                                    .read(isActiveEditNotifier.notifier)
                                    .setIsActiveEdit(false);
                              },
                              child: Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Hero(
                  tag: 'detailProduct',
                  flightShuttleBuilder:
                      (_, Animation<double> animation, __, ___, ____) {
                    final customAnimation =
                        Tween<double>(begin: 0, end: constraints.maxWidth * 0.3)
                            .animate(animation);

                    return AnimatedBuilder(
                        animation: customAnimation,
                        builder: (context, child) {
                          return const SizedBox();
                          // ProductDetails();
                        });
                  },
                  child: SizedBox(
                    height: height,
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 375),
                      alignment: Alignment(-1.0, isActiveEdit ? 0 : -1),
                      child: Container(
                        height: 75.0,
                        width: 75.0,
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(50.0)),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(createRoute());
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ))
        : const SizedBox();
  }
}
