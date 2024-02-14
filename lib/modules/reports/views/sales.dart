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
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(36),
        //   border: Border.all(
        //     color: Colors.white,
        //   ),
        // ),
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
                      var max = 0.0;
                      var theKey;
                      groupedAndSum.entries.forEach((element) {
                        if (element.value['totalSum'] > max) {
                          max = element.value['totalSum'];
                          theKey = element.key;
                        }
                      });
                      double intervaloTotal = max * 1.2;

                      double calcularPorcentagens(dynamic points) {
                        double deslocamentoRelativo = points;
                        double posicaoRelativa =
                            (deslocamentoRelativo / intervaloTotal) * 100;
                        double posicaoRelativaEmPixels =
                            ((100 - posicaoRelativa) / 100) *
                                constraints.maxHeight;

                        return posicaoRelativaEmPixels;
                      }

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        salesController.forward();
                      });

                      for (var i = 0; i < days.length; i++) {
                        // if (groupedAndSum.containsKey(
                        //     getDate(days[i]).toString().substring(0, 10))) {
                        //   // print(groupedAndSum.entries
                        //   //     .firstWhere((element) =>
                        //   //         element.key ==
                        //   //         getDate(days[i]).toString().substring(0, 10))
                        //   //     .value['totalSum']);
                        // }
                        // print(getDate(days[i]));

                        // print(groupedAndSum.entries
                        //     .firstWhere((element) =>
                        //         element.key ==
                        //         getDate(days[i]).toString().substring(0, 10))
                        //     .value['totalSum']);

                        // print(
                        //     "constraints.maxHeight === ${constraints.maxHeight}");

                        salesList.add(SalesModel(
                            weekDays: DateFormat('EEE', 'pt_BR')
                                .format(getDate(days[i])),
                            offset: Offset(
                                ((constraints.maxWidth / (days.length - 1)) *
                                    i),
                                groupedAndSum.containsKey(getDate(days[i]).toString().substring(0, 10))
                                    ? calcularPorcentagens(groupedAndSum.entries
                                        .firstWhere((element) =>
                                            element.key ==
                                            getDate(days[i])
                                                .toString()
                                                .substring(0, 10))
                                        .value['totalSum'])
                                    : constraints.maxHeight),
                            total: groupedAndSum.containsKey(getDate(days[i]).toString().substring(0, 10))
                                ? groupedAndSum.entries
                                    .firstWhere((element) => element.key == getDate(days[i]).toString().substring(0, 10))
                                    .value['totalSum']
                                : 0));
                      }
                      Path drawPath(bool closePath) {
                        final path = Path();
                        for (var i = 0; i < salesList.length - 1; i++) {
                          path.moveTo(
                              salesList[i].offset.dx, salesList[i].offset.dy);
                          path.cubicTo(
                            (salesList[i].offset.dx +
                                    salesList[i + 1].offset.dx) /
                                2,
                            salesList[i].offset.dy,
                            (salesList[i].offset.dx +
                                    salesList[i + 1].offset.dx) /
                                2,
                            salesList[i + 1].offset.dy,
                            salesList[i + 1].offset.dx,
                            salesList[i + 1].offset.dy,
                          );

                          // for the gradient fill, we want to close the path
                          if (closePath) {
                            path.lineTo(
                                constraints.maxWidth, constraints.maxHeight);
                            path.lineTo(
                                salesList[i].offset.dx, salesList[i].offset.dy);
                          }
                        }
                        return path;
                      }

                      salesList.forEach((value) {
                        print('${value.offset.dy}  ========  ${value.total}');
                      });

                      return AnimatedBuilder(
                          animation: salesController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: GraphPainter(
                                  animation.value,
                                  constraints.maxHeight,
                                  constraints.maxWidth,
                                  salesList,
                                  drawPath(false),
                                  drawPath(true),
                                  max * 1.2),
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
