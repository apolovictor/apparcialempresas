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
    required this.animation,
    required this.constraints,
  });

  final double height;
  final double width;
  final Animation<double> animation;
  final BoxConstraints constraints;
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
    final filter = ref.watch(filterNotifier);
    final bool isActiveEdit = ref.watch(isActiveEditNotifier);

    List<Product> filteredProducts = ref.watch(filteredProductListProvider);
    List<Product>? products = ref.watch(exampleProvider).value;

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

    productNameController.addListener(() {
      ref
          .read(productNameProvider.notifier)
          .fetchProductName(productNameController);
    });

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
    useValueChanged(productSelected, (_, __) async {
      editController.forward();

      editController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          editController.reverse();
        }
      });
      editController.forward();
    });

    return productSelected > -1 && isActiveEdit
        ? Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                  right: -25,
                  top: height * 0.20,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Text(
                      productSelected > -1
                          ? products![productSelected].name
                          : "",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 125,
                          color: Color(0xFF6265FF)
                          // productSelected > -1
                          //     ? filter['category'].isNotEmpty &&
                          //             filteredProducts.isNotEmpty
                          //         ? Color(int.parse(
                          //             filteredProducts[productSelected]
                          //                 .secondaryColor))
                          //         : products!.isNotEmpty
                          //             ? Color(int.parse(products[productSelected]
                          //                 .secondaryColor))
                          //             : Colors.transparent
                          //     : Colors.transparent,
                          ),
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
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
                                border:
                                    Border.all(width: 2, color: Colors.white12),
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
                                            ? filter['category'].isNotEmpty &&
                                                    filteredProducts.isNotEmpty
                                                ? ref
                                                    .watch(
                                                        pictureProductListProvider)
                                                    .firstWhere((element) =>
                                                        element.mapKey ==
                                                        filteredProducts[
                                                                productSelected]
                                                            .logo)
                                                : ref
                                                    .watch(
                                                        pictureProductListProvider)
                                                    .firstWhere((element) =>
                                                        element.mapKey ==
                                                        products![
                                                                productSelected]
                                                            .logo)
                                            : SizedBox()
                                        // Stack(
                                        //   children: [
                                        //     ListView(
                                        //         scrollDirection: Axis.horizontal,
                                        //         itemExtent: 300,
                                        //         children: <Widget>[
                                        //           ...generate_tags()
                                        //         ])
                                        //   ],
                                        // ),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment(1, 1),
                          child: Positioned(
                              top: height * 0.55,
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
                                        child: fieldWidget(
                                          productNameController,
                                          productSelected > -1
                                              ? filter['category'].isNotEmpty &&
                                                      filteredProducts
                                                          .isNotEmpty
                                                  ? filteredProducts[
                                                          productSelected]
                                                      .name
                                                  : products!.isNotEmpty
                                                      ? products[
                                                              productSelected]
                                                          .name
                                                      : "Nome"
                                              : "Nome",
                                          context,
                                          productSelected > -1
                                              ? filter['category'].isNotEmpty &&
                                                      filteredProducts
                                                          .isNotEmpty
                                                  ? Color(int.parse(
                                                      filteredProducts[
                                                              productSelected]
                                                          .secondaryColor))
                                                  : products!.isNotEmpty
                                                      ? Color(int.parse(products[
                                                              productSelected]
                                                          .secondaryColor))
                                                      : Colors.transparent
                                              : Colors.transparent,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ScaleTransition(
                                        scale: animation,
                                        child: fieldWidget(
                                          productPriceController,
                                          productSelected > -1
                                              ? filter['category'].isNotEmpty &&
                                                      filteredProducts
                                                          .isNotEmpty
                                                  ? filteredProducts[
                                                          productSelected]
                                                      .price['price']
                                                  : products!.isNotEmpty
                                                      ? products[
                                                              productSelected]
                                                          .price['price']
                                                      : "Preço"
                                              : "Preço",
                                          context,
                                          productSelected > -1
                                              ? filter['category'].isNotEmpty &&
                                                      filteredProducts
                                                          .isNotEmpty
                                                  ? Color(int.parse(
                                                      filteredProducts[
                                                              productSelected]
                                                          .secondaryColor))
                                                  : products!.isNotEmpty
                                                      ? Color(int.parse(products[
                                                              productSelected]
                                                          .secondaryColor))
                                                      : Colors.transparent
                                              : Colors.transparent,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ScaleTransition(
                                        scale: animation,
                                        child: fieldWidget(
                                          productPromoController,
                                          productSelected > -1
                                              ? filter['category'].isNotEmpty &&
                                                      filteredProducts
                                                          .isNotEmpty
                                                  ? filteredProducts[
                                                              productSelected]
                                                          .price['promo']
                                                          .isNotEmpty
                                                      ? filteredProducts[
                                                              productSelected]
                                                          .price['promo']
                                                      : "Promoção"
                                                  : products!.isNotEmpty
                                                      ? products[productSelected]
                                                              .price['promo']
                                                              .isNotEmpty
                                                          ? products[
                                                                  productSelected]
                                                              .price['promo']
                                                          : "Promoção"
                                                      : "Promoção"
                                              : "Promoção",
                                          context,
                                          productSelected > -1
                                              ? filter['category'].isNotEmpty &&
                                                      filteredProducts
                                                          .isNotEmpty
                                                  ? Color(int.parse(
                                                      filteredProducts[
                                                              productSelected]
                                                          .secondaryColor))
                                                  : products!.isNotEmpty
                                                      ? Color(int.parse(products[
                                                              productSelected]
                                                          .secondaryColor))
                                                      : Colors.transparent
                                              : Colors.transparent,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ScaleTransition(
                                        scale: animation,
                                        child: fieldWidget(
                                          productQuantityController,
                                          productSelected > -1
                                              ? filter['category'].isNotEmpty &&
                                                      filteredProducts
                                                          .isNotEmpty
                                                  ? filteredProducts[
                                                          productSelected]
                                                      .quantity
                                                  : products!.isNotEmpty
                                                      ? products[
                                                              productSelected]
                                                          .quantity
                                                      : "Quantidade"
                                              : "Quantidade",
                                          context,
                                          productSelected > -1
                                              ? filter['category'].isNotEmpty &&
                                                      filteredProducts
                                                          .isNotEmpty
                                                  ? Color(int.parse(
                                                      filteredProducts[
                                                              productSelected]
                                                          .secondaryColor))
                                                  : products!.isNotEmpty
                                                      ? Color(int.parse(products[
                                                              productSelected]
                                                          .secondaryColor))
                                                      : Colors.transparent
                                              : Colors.transparent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                        Align(
                          alignment: const Alignment(-1.1, 1.1),
                          child: Container(
                            height: 80,
                            width: width * 0.3,
                            child: UpdateButton(
                              buttonName: "Salvar",
                              animation: animation,
                              product: filter['category'].isNotEmpty &&
                                      filteredProducts.isNotEmpty
                                  ? filteredProducts[productSelected]
                                  : products![productSelected],
                            ),
                          ),
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
                    alignment: Alignment(
                        -1.2, constraints.maxWidth == width * 0.3 ? 0 : -1),
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
          )
        : SizedBox();
  }
}
