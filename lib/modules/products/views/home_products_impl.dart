import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../widgets/app_scaffold.dart';
import '../controller/product_list.notifier.dart';
import '../controller/products_notifier.dart';
import '../model/products_model.dart';
import 'home_products.dart';

class HomeProducts extends HookConsumerWidget {
  const HomeProducts({Key? key}) : super(key: key);

  // final Key dataKey = new GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterNotifier);

    List<Product> filteredProducts = ref.watch(filteredProductListProvider);
    List<Product>? products = ref.watch(exampleProvider).value;

    downloadUrl(product) async =>
        await storage.ref("products").child(product).getDownloadURL();

    updateImageToProductList() async {
      if (products != null) {
        for (var i = 0; i < products.length; i++) {
          var imgLink = await downloadUrl(products[i].logo);

          if (imgLink.isNotEmpty) {
            ref.read(imageProductsNotifier.notifier).fetchimageProductList(
                UrlProduct(
                    title: products[i].logo!,
                    url: imgLink,
                    category: products[i].categories));
          }
        }
      }
    }

    useValueChanged(filter, (_, __) async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(filteredProductListProvider.notifier).fetchFilteredList(
            products!
                .where((product) => product.categories == filter['category'])
                .toList());
        ref.read(imageProductsNotifier.notifier).clear();
        updateImageToProductList();
      });
    });

    updateImageToProductList();

    return AppScaffold(
      pageTitle: "Produtos",
      loadingAppBar: true,
      body: products != null || filteredProducts.length > 0
          ? MaterialApp(
              debugShowCheckedModeBanner: false,
              routes: {
                '/': (context) => ProductScreen(),
              },
              theme: ThemeData(
                appBarTheme: const AppBarTheme(
                  color: Colors.white,
                  titleTextStyle: TextStyle(color: Colors.black87),
                ),
                fontFamily: 'HelveticaNeue',
                primaryColor: Colors.white,
                colorScheme: ThemeData().colorScheme.copyWith(
                    secondary: const Color(0xFF181818),
                    background: Colors.white),
                textTheme: ThemeData().textTheme.copyWith(
                      bodySmall: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w100),
                      bodyMedium: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w400),
                      bodyLarge: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w700),
                      labelSmall: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w100),
                      labelMedium: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w400),
                      labelLarge: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w700),
                      titleSmall: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w300,
                          color: Colors.black54),
                      titleMedium: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w700,
                          color: Colors.black54),
                      titleLarge: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w900,
                          color: Colors.black54),
                      headlineSmall: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w100,
                          color: Colors.black87),
                      headlineMedium: const TextStyle(
                          fontSize: 26,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w700,
                          color: Colors.black87),
                      headlineLarge: const TextStyle(
                          fontSize: 32,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w700,
                          color: Colors.black87),
                    ),
              ),
            )
          : SizedBox(),
      key: key,
    );
  }
}
