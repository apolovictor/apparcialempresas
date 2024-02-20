import 'package:botecaria/modules/reports/views/sales.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../services/date_services.dart';
import '../controllers/reports_controller.dart';
import '../models/reports_model.dart';

var timeToFilterNotifier = StateProvider((_) => 7);

class SalesImpl extends HookConsumerWidget {
  const SalesImpl({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(getSalesReportProvider);
    final salesList = ref.watch(salesListNotifier);

    return salesList.isNotEmpty ? Sales() : SizedBox();
  }
}
