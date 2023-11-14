import 'package:apparcialempresas/modules/products/model/products_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';
import '../controller/product_update.dart';
import '../controller/products_notifier.dart';

class UpdateButton extends HookConsumerWidget {
  const UpdateButton({
    super.key,
    required this.buttonName,
    required this.animation,
    required this.product,
  });

  final String buttonName;
  final Animation<double> animation;
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  register button
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
      child: ScaleTransition(
        scale: animation,
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                backgroundColor: Colors.black87,
                minimumSize: const Size.fromHeight(60)),
            icon: const Icon(Icons.done_outline, color: Colors.white, size: 32),
            label: const Text(
              'Enviar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              if (ref.watch(productNameProvider).text.isEmpty &&
                  ref.watch(productPriceProvider).text.isEmpty &&
                  ref.watch(productPromoProvider).text.isEmpty &&
                  ref.watch(productQuantityProvider).text.isEmpty) return;

              final result =
                  await ref.read(updateProductProvider).updateQuickProduct(
                        product.documentId!,
                        ref.watch(productNameProvider).text.isEmpty
                            ? product.name
                            : ref.watch(productNameProvider).text,
                        ref.watch(productPriceProvider).text.isEmpty
                            ? product.price['price']
                            : ref.watch(productPriceProvider).text,
                        ref.watch(productPromoProvider).text.isEmpty
                            ? product.price['promo']
                            : ref.watch(productPromoProvider).text,
                        ref.watch(productQuantityProvider).text.isEmpty
                            ? product.quantity
                            : ref.watch(productQuantityProvider).text,
                      );

              if (result) {
                ref.read(productNameProvider.notifier).clear();
                ref.read(productPriceProvider.notifier).clear();
                ref.read(productPromoProvider.notifier).clear();
                ref.read(productQuantityProvider.notifier).clear();

                ref.read(isActiveEditNotifier.notifier).setIsActiveEdit(false);

                Fluttertoast.showToast(
                    msg: "${product.name} atualizado(a) com sucesso!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 3,
                    webBgColor: '#151515',
                    textColor: Colors.white,
                    fontSize: 18.0);
              } else {
                Fluttertoast.showToast(
                  msg: result.toString(),
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 3,
                  webBgColor: '#151515',
                  textColor: Colors.white,
                  fontSize: 18.0,
                );
              }
            }),
      ),
    );
  }
}
