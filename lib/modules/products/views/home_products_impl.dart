import 'dart:io';

import 'package:cached_firestorage/remote_picture.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../routes/widgets/app_scaffold.dart';
import '../controller/products_notifier.dart';
import '../model/products_model.dart';
import 'home_products.dart';

class HomeProducts extends HookConsumerWidget {
  const HomeProducts({super.key});

  // final Key dataKey = new GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Product>? products = ref.watch(productsStreamProvider).value;
    final categories = ref.watch(categoriesNotifier).value;
    if (categories != null) {
      for (var i = 0; i < categories.length; i++) {
        // print("categories[i].documentId === ${categories[i].documentId}");
      }
    }
    // running on the web!

    if (kIsWeb) {
      if (products != null) {
        print("products.length ==== ${products?.length}");
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          for (var index = 0; index < products.length; index++) {
            if (products[index].logo != null) {
              print('products[index].logo!  === ${products[index].logo!}');
              await ref.read(pictureProductListProvider.notifier).add(
                    RemotePicture(
                      mapKey: products[index].logo!,
                      imagePath:
                          'gs://appparcial-123.appspot.com/products/${products[index].logo!}',
                    ),
                  );
            }
          }
        });
      }
      if (categories != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          for (var i = 0; i < categories.length; i++) {
            // print("categories[i].documentId === ${categories[i].documentId}");
            ref.read(pictureCategoryListProvider.notifier).add(
                RemotePicture(
                  mapKey: categories[i].documentId,
                  imagePath:
                      'gs://appparcial-123.appspot.com/categories_icons/${categories[i].documentId}.png',
                ),
                categories.length);
          }
        });
      }
    } else {
      if (Platform.isAndroid) {
        if (products != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            for (var index = 0; index < products.length; index++) {
              await ref.read(pictureProductListAndroidProvider.notifier).add(
                    products[index].logo!,
                    products.length,
                  );
            }
          });
        }

        if (categories != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            for (var i = 0; i < categories.length; i++) {
              ref
                  .read(pictureCategoriesListAndroidProvider.notifier)
                  .add(categories[i].documentId, categories.length);
            }
          });
        }
        // NOT running on the web! You can check for additional platforms here.
        // Intl.defaultLocale = 'pt_BR';
      }
    }
    List<dynamic> cachePictures = kIsWeb
        ? ref.watch(pictureProductListProvider)
        : ref.watch(pictureProductListAndroidProvider);
    return AppScaffold(
      pageTitle: "Produtos",
      body: products != null
          ? cachePictures.length == products.length
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
              : const MaterialApp()
          : const MaterialApp(),
      key: key,
    );
  }
}
