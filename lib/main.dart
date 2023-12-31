// ignore_for_file: prefer_for_elements_to_map_fromiterable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:html';

import 'constants/route_names.dart';
import 'modules/home/controller/home_notifier.dart';
import 'modules/home/views/dashboard_impl.dart';
import 'modules/products/controller/product_list.notifier.dart';
import 'modules/products/controller/products_notifier.dart';
import 'modules/products/views/home_products_impl.dart';
import 'modules/products/views/product_details.dart';
import 'modules/products/views/product_details_impl.dart';
import 'modules/routes/controller/routes_controller.dart';
import 'modules/routes/widgets/app_route_observer.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAEZanCLyBeY4rU9Cj77on_vu7H0fHAbqE",
        authDomain: "appparcial-123.firebaseapp.com",
        projectId: "appparcial-123",
        storageBucket: "appparcial-123.appspot.com",
        messagingSenderId: "900861690548",
        appId: "1:900861690548:web:001dff373b3178e7b28de1"),
  );

  runApp(const ProviderScope(child: MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref
    //       .read(sizeLayoutNotifier.notifier)
    //       .setSize(MediaQuery.of(context).size);
    // });
    return MaterialApp(
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
