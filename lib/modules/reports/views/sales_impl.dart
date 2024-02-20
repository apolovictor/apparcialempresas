import 'package:botecaria/modules/reports/views/sales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/reports_controller.dart';

class SalesImpl extends HookConsumerWidget {
  const SalesImpl({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.read(getSalesReportProvider.notifier).updateSalesList();
    dynamic result = ref.watch(getSalesReportProvider);
    // print(result.runtimeType);

    return result.runtimeType == bool
        ? result
            ? Sales()
            : SizedBox()
        : SizedBox();
  }
}
