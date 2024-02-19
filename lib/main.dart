// ignore_for_file: prefer_for_elements_to_map_fromiterable

import 'dart:io' show Platform;

import 'package:cached_firestorage/lib.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'constants/route_names.dart';
import 'firebase_options.dart';
import 'modules/home/controller/home_notifier.dart';
import 'modules/home/controller/product_notifier.dart';
import 'modules/home/views/dashboard_impl.dart';
import 'modules/products/controller/products_notifier.dart';
import 'modules/products/model/products_model.dart';
import 'modules/products/views/home_products_impl.dart';
import 'modules/products/views/product_details_impl.dart';
import 'modules/reports/views/home_reports_impl.dart';
import 'modules/routes/widgets/app_route_observer.dart';

Future main() async {
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  // CachedNetworkImage.logLevel = CacheManagerLogLevel.verbose;
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug,
  // );

  runApp(const ProviderScope(child: MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Product>? products = ref.watch(productProvider).value;
    final categories = ref.watch(categoriesNotifier).value;
    if (categories != null) {
      for (var i = 0; i < categories.length; i++) {
        // print("categories[i].documentId === ${categories[i].documentId}");
      }
    }
    if (kIsWeb) {
      if (products != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          for (var index = 0; index < products.length; index++) {
            await ref.read(pictureProductListProvider.notifier).add(
                  RemotePicture(
                    mapKey: products[index].logo!,
                    imagePath:
                        'gs://appparcial-123.appspot.com/products/${products[index].logo!}',
                  ),
                  products.length,
                );
          }
        });
      }
      if (categories != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          for (var i = 0; i < categories.length; i++) {
            print("categories[i].documentId === ${categories[i].documentId}");
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
      // running on the web!
      initializeDateFormatting('pt_BR');
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
        initializeDateFormatting('pt_BR');
      }
    }
    List<Stream<FileResponse>> cachePictures =
        // = kIsWeb
        //     ? ref.watch(pictureProductListProvider)
        // :
        ref.watch(pictureProductListAndroidProvider);

    // print("cachePictures.length === ${cachePictures.length}");

    // cachePictures.forEach(<FileResponse>(element) {
    //   print(elemen);
    // });

    // if (products != null) {
    //   for (var product in products)
    //     print(ref
    //         .read(pictureProductListAndroidProvider.notifier)
    //         .downLoadFile(product.logo!)
    //         .first
    //         .then((value) => print(value.originalUrl)));
    // }
    return products != null
        ? cachePictures.length == products.length
            ?
            // ? MaterialApp(title: ' Loaded')
            MaterialApp(
                title: ref.watch(responseProvider("bandiis")).when(
                    data: (dataResponse) => dataResponse.name,
                    error: (err, stack) => err.toString(),
                    loading: () => ""),
                debugShowCheckedModeBanner: false,
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
                            fontSize: 22,
                            fontFamily: 'HelveticaNeue',
                            fontWeight: FontWeight.w800),
                      ),
                  pageTransitionsTheme: PageTransitionsTheme(
                    // makes all platforms that can run Flutter apps display routes without any animation
                    builders: Map<TargetPlatform,
                            _InanimatePageTransitionsBuilder>.fromIterable(
                        TargetPlatform.values.toList(),
                        key: (dynamic k) => k,
                        value: (dynamic _) =>
                            const _InanimatePageTransitionsBuilder()),
                  ),
                ),
                initialRoute: RouteNames.home,
                navigatorObservers: [AppRouteObserver()],
                routes: {
                  RouteNames.home: (_) => const HomeDashboard(),
                  RouteNames.products: (_) => const HomeProducts(),
                  RouteNames.productDetails: (_) => ProductDetails(),
                  RouteNames.reports: (_) => const ReportsDashboard(),
                },
              )
            : const MaterialApp()
        : const MaterialApp();
  }
}

/// This class is used to build page transitions that don't have any animation
class _InanimatePageTransitionsBuilder extends PageTransitionsBuilder {
  const _InanimatePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return child;
  }
}
