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

import 'cache/model/products_cache_model.dart';
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
import 'package:hive_flutter/hive_flutter.dart';

Future main() async {
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  // CachedNetworkImage.logLevel = CacheManagerLogLevel.verbose;
  WidgetsFlutterBinding.ensureInitialized();
  //Initialize Hive
  await Hive.initFlutter();

  // Registering the adapter
  Hive.registerAdapter(ProductInServiceModelAdapter());

  //Open Hive Box for Key-value entries
  await Hive.openBox<ProductInServiceModel>('productsInService');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeDateFormatting('pt_BR');

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
    // print("cachePictures.length === ${cachePictures.length}");

    // cachePictures.forEach(<FileResponse>(element) {
    //   print(elemen);
    // });

    return
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
            secondary: const Color(0xFF181818), background: Colors.white),
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
              value: (dynamic _) => const _InanimatePageTransitionsBuilder()),
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
    );
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
