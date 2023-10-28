import 'package:flutter/material.dart';

import '../../../widgets/app_scaffold.dart';
import 'home_products.dart';

class HomeProducts extends StatelessWidget {
  const HomeProducts({Key? key}) : super(key: key);

  // final Key dataKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      pageTitle: "Produtos",
      // orders: orders,
      loadingAppBar: true,
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const ProductScreen(),
        },
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
      ),
      key: key,
    );
  }
}
