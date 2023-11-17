import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_register.dart';
import '../controller/products_notifier.dart';

class RegisterButton extends HookConsumerWidget {
  const RegisterButton({
    super.key,
    required this.buttonName,
    required this.animation,
  });

  final String buttonName;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  register button
    final String category = ref.watch(categoryProductNotifier);
    final categories = ref.watch(categoriesNotifier).value;
    final imgConverted = ref.watch(imgConvertedProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
      child: ScaleTransition(
        scale: animation,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                backgroundColor: Colors.black87,
                minimumSize: const Size.fromHeight(60)),
            child: const Text(
              'Cadastrar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              if (ref.watch(productNameProvider).text.isEmpty ||
                  ref.watch(productPriceProvider).text.isEmpty ||
                  ref.watch(productQuantityProvider).text.isEmpty ||
                  category.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Todos os campos devem ser preenchidos!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 3,
                    webBgColor: '#151515',
                    textColor: Colors.white,
                    fontSize: 18.0);

                return;
              } else {
                final result = await ref
                    .read(registerProductProvider)
                    .registerProduct(
                        ref.watch(productNameProvider).text,
                        {
                          'price': ref.watch(productPriceProvider).text,
                          'promo': '0.00'
                        },
                        ref.watch(productQuantityProvider).text,
                        categories!
                            .firstWhere((e) => e.documentId == category)
                            .color!,
                        categories
                            .firstWhere((e) => e.documentId == category)
                            .secondaryColor!,
                        category,
                        imgConverted,
                        ref);

                if (result) {
                  ref.read(productNameProvider.notifier).clear();
                  ref.read(productPriceProvider.notifier).clear();
                  ref.read(productPromoProvider.notifier).clear();
                  ref.read(productQuantityProvider.notifier).clear();

                  ref.read(isProductsOpenedProvider.notifier).fetch(false);
                  ref.read(categoryProductNotifier.notifier).clear();
                  ref.read(imgFileProvider.notifier).clear();
                  ref.read(imgConvertedProvider.notifier).clear();

                  ref
                      .read(isReloagingImgNotifier.notifier)
                      .isReloadingImg(true);

                  Fluttertoast.showToast(
                      msg: "Produto cadastrado com sucesso!",
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
              }
            }),
      ),
    );
  }
}
