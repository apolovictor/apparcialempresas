import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';
import '../controller/products_notifier.dart';
import '../model/products_model.dart';
import '../widgets/quick_fields.dart';

class ProducQuickEdit extends HookConsumerWidget {
  const ProducQuickEdit(
      {super.key,
      required this.height,
      required this.width,
      required this.animation});

  final double height;
  final double width;
  final Animation<double> animation;
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

    List<Product> filteredProducts = ref.watch(filteredProductListProvider);
    List<Product>? products = ref.watch(exampleProvider).value;

    return Positioned(
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
                            ? Color(int.parse(filteredProducts[productSelected]
                                .secondaryColor))
                            : products!.isNotEmpty
                                ? Color(int.parse(
                                    products[productSelected].secondaryColor))
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
                            ? filteredProducts[productSelected].price['price']
                            : products!.isNotEmpty
                                ? products[productSelected].price['price']
                                : "Preço"
                        : "Preço",
                    context,
                    productSelected > -1
                        ? filter['category'].isNotEmpty &&
                                filteredProducts.isNotEmpty
                            ? Color(int.parse(filteredProducts[productSelected]
                                .secondaryColor))
                            : products!.isNotEmpty
                                ? Color(int.parse(
                                    products[productSelected].secondaryColor))
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
                                    ? products[productSelected].price['promo']
                                    : "Promoção"
                                : "Promoção"
                        : "Promoção",
                    context,
                    productSelected > -1
                        ? filter['category'].isNotEmpty &&
                                filteredProducts.isNotEmpty
                            ? Color(int.parse(filteredProducts[productSelected]
                                .secondaryColor))
                            : products!.isNotEmpty
                                ? Color(int.parse(
                                    products[productSelected].secondaryColor))
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
                            ? Color(int.parse(filteredProducts[productSelected]
                                .secondaryColor))
                            : products!.isNotEmpty
                                ? Color(int.parse(
                                    products[productSelected].secondaryColor))
                                : Colors.transparent
                        : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
