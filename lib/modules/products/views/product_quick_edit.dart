import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';
import '../controller/products_notifier.dart';
import '../model/products_model.dart';
import '../widgets/quick_fields.dart';
import '../widgets/submit_button.dart';
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
    bool isActiveEdit = ref.watch(isActiveEditNotifier);

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

    return Stack(
      children: [
        Positioned(
            top: height * 0.55,
            child: SizedBox(
              width: width * 0.3,
              height: height * 0.4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    ScaleTransition(
                      scale: animation,
                      child: fieldWidget(
                        productNameController,
                        productSelected > -1
                            ? filter['category'].isNotEmpty &&
                                    filteredProducts.isNotEmpty
                                ? filteredProducts[productSelected].name
                                : products!.isNotEmpty
                                    ? products[productSelected].name
                                    : "Nome"
                            : "Nome",
                        context,
                        productSelected > -1
                            ? filter['category'].isNotEmpty &&
                                    filteredProducts.isNotEmpty
                                ? Color(int.parse(
                                    filteredProducts[productSelected]
                                        .secondaryColor))
                                : products!.isNotEmpty
                                    ? Color(int.parse(products[productSelected]
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
                                    filteredProducts.isNotEmpty
                                ? filteredProducts[productSelected]
                                    .price['price']
                                : products!.isNotEmpty
                                    ? products[productSelected].price['price']
                                    : "Preço"
                            : "Preço",
                        context,
                        productSelected > -1
                            ? filter['category'].isNotEmpty &&
                                    filteredProducts.isNotEmpty
                                ? Color(int.parse(
                                    filteredProducts[productSelected]
                                        .secondaryColor))
                                : products!.isNotEmpty
                                    ? Color(int.parse(products[productSelected]
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
                                    filteredProducts.isNotEmpty
                                ? filteredProducts[productSelected]
                                        .price['promo']
                                        .isNotEmpty
                                    ? filteredProducts[productSelected]
                                        .price['promo']
                                    : "Promoção"
                                : products!.isNotEmpty
                                    ? products[productSelected]
                                            .price['promo']
                                            .isNotEmpty
                                        ? products[productSelected]
                                            .price['promo']
                                        : "Promoção"
                                    : "Promoção"
                            : "Promoção",
                        context,
                        productSelected > -1
                            ? filter['category'].isNotEmpty &&
                                    filteredProducts.isNotEmpty
                                ? Color(int.parse(
                                    filteredProducts[productSelected]
                                        .secondaryColor))
                                : products!.isNotEmpty
                                    ? Color(int.parse(products[productSelected]
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
                                    filteredProducts.isNotEmpty
                                ? filteredProducts[productSelected].quantity
                                : products!.isNotEmpty
                                    ? products[productSelected].quantity
                                    : "Quantidade"
                            : "Quantidade",
                        context,
                        productSelected > -1
                            ? filter['category'].isNotEmpty &&
                                    filteredProducts.isNotEmpty
                                ? Color(int.parse(
                                    filteredProducts[productSelected]
                                        .secondaryColor))
                                : products!.isNotEmpty
                                    ? Color(int.parse(products[productSelected]
                                        .secondaryColor))
                                    : Colors.transparent
                            : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            )),
        Positioned(
          top: 0,
          right: 0,
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              height: height * 0.4,
              width: (isActiveEdit && productSelected > -1) ? width * 0.3 : 0,
              child: productSelected > -1
                  ? filter['category'].isNotEmpty && filteredProducts.isNotEmpty
                      ? ref.watch(pictureProductListProvider).firstWhere(
                          (element) =>
                              element.mapKey ==
                              filteredProducts[productSelected].logo)
                      : ref.watch(pictureProductListProvider).firstWhere(
                          (element) =>
                              element.mapKey == products![productSelected].logo)
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
        Container(
          alignment: Alignment.bottomCenter,

          child: SubmitButton(
            buttonName: "Salvar",
            animation: animation,
            product:
                filter['category'].isNotEmpty && filteredProducts.isNotEmpty
                    ? filteredProducts[productSelected]
                    : products![productSelected],
          ),
          // )
        ),
        Align(
          alignment: const Alignment(-1.1, -1),
          child: InkWell(
            onTap: () {
              ref.read(isActiveEditNotifier.notifier).setIsActiveEdit(false);
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
              alignment:
                  Alignment(-1.2, constraints.maxWidth == width * 0.3 ? 0 : -1),
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
    );
  }
}
