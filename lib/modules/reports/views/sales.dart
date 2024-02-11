import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../services/date_services.dart';
import '../controllers/reports_controller.dart';
import '../models/reports_model.dart';
import '../widgets/graph_painter.dart';

class Sales extends HookConsumerWidget {
  const Sales({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = DateTime.now();
    int timeToFilter = 7;

    final timeStamp =
        dateTimetoTimeStamp(date.subtract(Duration(days: timeToFilter)));

    AnimationController salesController =
        useAnimationController(duration: const Duration(seconds: 1));

    final Animation<double> animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: salesController, curve: Curves.easeInOutCirc));

    final salesReport = ref.read(salesReportProvider).getSalesReport(timeStamp);

    List<SalesModel> salesList = [];

    final daysToGenerate =
        date.difference(date.subtract(Duration(days: timeToFilter))).inDays;
    var days = List.generate(
        daysToGenerate, (i) => getDate(date.subtract(Duration(days: i))));
    days = days.reversed.toList();

    for (var i = 0; i < days.length; i++) {
      print(DateFormat('EEEE').format(getDate(days[i])));
    }

    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 28.0),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: FutureBuilder(
            future: salesReport,
            builder: (context, snapshot) {
              // print("snapshot ==== $snapshot");
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }

              return snapshot.data != null
                  ? LayoutBuilder(builder: (context, constraints) {
                      // print(
                      //     "constraints.maxHeight ==== ${constraints.maxHeight}");

                      var groupByDate = groupBy(
                          snapshot.data!,
                          (obj) => timeStampToDate(obj.date)
                              .toString()
                              .substring(0, 10));
                      Map groupedAndSum = {};

                      groupByDate.forEach((k, v) {
                        // Header
                        // print('${date}:');

                        groupedAndSum[k] = {
                          'list': v,
                          'totalSum': v.fold(0.00, (prev, element) {
                            return prev + element.total;
                          }),
                        };

                        // day section divider
                      });

                      // print("groupByDate ==== $groupByDate");
                      print("groupedAndSum ==== $groupedAndSum");
                      var thevalue = 0.0;
                      var thekey;
                      groupedAndSum.entries.forEach((element) {
                        if (element.value['totalSum'] > thevalue) {
                          thevalue = element.value['totalSum'];
                          thekey = element.key;
                        }
                      });

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        salesController.forward();
                      });

                      print("thekey ===> $thekey");
                      print("thevalue ===> $thevalue");
                      print("days.length ===> ${days.length}");
                      for (var i = days.length - 1; i >= 0; i--) {
                        print("i ==== $i");

                        if (groupedAndSum.containsKey(
                            getDate(days[i]).toString().substring(0, 10))) {
                          print(groupedAndSum.entries
                              .firstWhere((element) =>
                                  element.key ==
                                  getDate(days[i]).toString().substring(0, 10))
                              .value['totalSum']);
                        }
                        // print(DateFormat('EEE', 'pt_BR')
                        //     .format(getDate(days[i])));
                        salesList.add(SalesModel(
                            weekDays: DateFormat('EEE', 'pt_BR')
                                .format(getDate(days[i])),
                            offset: Offset(
                                ((constraints.maxWidth / days.length) * i) + 30,
                                groupedAndSum.containsKey(getDate(days[i])
                                        .toString()
                                        .substring(0, 10))
                                    ? (groupedAndSum.entries
                                                .firstWhere((element) =>
                                                    element.key ==
                                                    getDate(days[i])
                                                        .toString()
                                                        .substring(0, 10))
                                                .value['totalSum'] *
                                            constraints.maxHeight) /
                                        (thevalue * 1.2)
                                    : constraints.maxHeight)));
                      }
                      return AnimatedBuilder(
                          animation: salesController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: GraphPainter(
                                  animation.value,
                                  constraints.maxHeight,
                                  constraints.maxWidth,
                                  salesList),
                            );
                          });
                      //!! fazer o animation do background color gradient da receita de vendas em paralelo com os valores das proprias receitas do grafico.
                    })
                  : const SizedBox();
            }),
      ),
    );
  }
}
