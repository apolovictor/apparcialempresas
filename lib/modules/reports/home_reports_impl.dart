import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../routes/widgets/app_scaffold.dart';
import 'home_report.dart';

class ReportsDashboard extends HookConsumerWidget {
  const ReportsDashboard({super.key});
  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      pageTitle: "Produtos",
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => ReportScreen(),
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
