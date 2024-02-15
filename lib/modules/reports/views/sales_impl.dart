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
    return Consumer(builder: (context, ref, child) {
      final salesReport = ref.watch(getSalesReportProvider);

      return Center(
        /// Since network-requests are asynchronous and can fail, we need to
        /// handle both error and loading states. We can use pattern matching for this.
        /// We could alternatively use `if (activity.isLoading) { ... } else if (...)`
        child: switch (salesReport) {
          AsyncData(:final value) => Column(
              children: value.map((e) => Text(e.total.toString())).toList(),
            ),
          AsyncError() => const Text('Oops, something unexpected happened'),
          _ => const CircularProgressIndicator(),
        },
      );
    });

    // return FutureBuilder(
    //     future: salesReport,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasError) {
    //         return const Text("Algo deu errado");
    //       }

    //       return snapshot.data != null
    //           ? Padding(
    //               padding: const EdgeInsets.only(
    //                   left: 32.0, top: 8.0, right: 32.0, bottom: 28.0),
    //               child: Container(
    //                   height: 200,
    //                   width: double.infinity,
    //                   child: LayoutBuilder(builder: (context, constraints) {
    //                     var groupByDate = groupBy(
    //                         snapshot.data!,
    //                         (obj) => timeStampToDate(obj.date)
    //                             .toString()
    //                             .substring(0, 10));
    //                     Map groupedAndSum = {};

    //                     groupByDate.forEach((k, v) {
    //                       groupedAndSum[k] = {
    //                         'list': v,
    //                         'totalSum': v.fold(0.00, (prev, element) {
    //                           return prev + element.total;
    //                         }),
    //                       };
    //                     });

    //                     var max = 0.0;
    //                     var theKey;
    //                     groupedAndSum.entries.forEach((element) {
    //                       if (element.value['totalSum'] > max) {
    //                         max = element.value['totalSum'];
    //                         theKey = element.key;
    //                       }
    //                     });

    //                     print("groupedAndSum ========== $groupedAndSum");
    //                     double intervaloTotal = max * 1.2;

    //                     double calcularPorcentagens(dynamic points) {
    //                       double deslocamentoRelativo = points;
    //                       double posicaoRelativa =
    //                           (deslocamentoRelativo / intervaloTotal) * 100;
    //                       double posicaoRelativaEmPixels =
    //                           ((100 - posicaoRelativa) / 100) *
    //                               constraints.maxHeight;

    //                       return posicaoRelativaEmPixels;
    //                     }

    //                     for (var i = 0; i < days.length; i++) {
    //                       WidgetsBinding.instance.addPostFrameCallback((_) {
    //                         ref.read(salesListNotifier.notifier).addItem(SalesModel(
    //                             weekDays: DateFormat('EEE', 'pt_BR')
    //                                 .format(getDate(days[i])),
    //                             offset: Offset(
    //                                 ((constraints.maxWidth / (days.length - 1)) *
    //                                     i),
    //                                 groupedAndSum.containsKey(getDate(days[i]).toString().substring(0, 10))
    //                                     ? calcularPorcentagens(groupedAndSum
    //                                         .entries
    //                                         .firstWhere((element) =>
    //                                             element.key ==
    //                                             getDate(days[i])
    //                                                 .toString()
    //                                                 .substring(0, 10))
    //                                         .value['totalSum'])
    //                                     : constraints.maxHeight),
    //                             total: groupedAndSum.containsKey(getDate(days[i]).toString().substring(0, 10))
    //                                 ? groupedAndSum.entries
    //                                     .firstWhere((element) => element.key == getDate(days[i]).toString().substring(0, 10))
    //                                     .value['totalSum']
    //                                 : 0));
    //                       });
    //                     }

    //                     return Sales(max: max);
    //                   })),
    //             )
    //           : SizedBox();
    //     });
  }
}
