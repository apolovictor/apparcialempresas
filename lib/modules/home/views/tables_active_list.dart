import 'package:apparcialempresas/modules/home/model/tables_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../orders/controller/orders_notifier.dart';
import '../controller/tables_notifier.dart';
import '../widgets/tables.dart';
import '../widgets/tables_active_widget.dart';

class TablesListActive extends HookConsumerWidget {
  const TablesListActive({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tables = ref.read(tablesNotifierProvider);

    // final isOpen = ref.watch(isOpenProvider);
    // final clientName = ref.watch(clientNameProvider);

    // ref.read(ordersNotifierProvider).getOrderByIdDocument(table!.documentId);

    AnimationController tablesController =
        useAnimationController(duration: const Duration(milliseconds: 0));
    SequenceAnimation sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 100.0),
            curve: Curves.easeOut,
            from: const Duration(milliseconds: 450),
            to: const Duration(milliseconds: 650),
            tag: 'avatarSize')
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 40.0),
            curve: Curves.easeOut,
            from: const Duration(milliseconds: 500),
            to: const Duration(milliseconds: 750),
            tag: 'iconSize')
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: 12.0),
            curve: Curves.easeOut,
            from: const Duration(milliseconds: 500),
            to: const Duration(milliseconds: 750),
            tag: 'fontSize')
        .animate(tablesController);

    tablesController.forward();
    return ref.watch(tables.tableChangeNotifier).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(err.toString())),
        data: (data) {
          return data != null
              ? ref.watch(tables.tableActiveNotifier).when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text(err.toString())),
                  data: (activeData) => activeData != null
                      ? DragTarget<DashboardTables>(
                          onWillAccept: (value) => !activeData.contains(value),
                          onAccept: (DashboardTables data) {
                            Timestamp currentTimeStamp =
                                Timestamp.fromDate(DateTime.now());
                            ref
                                .read(dragTableNotifier.notifier)
                                .bookingOrderedByDraggable(data);
                          },
                          builder: (BuildContext context,
                              List<DashboardTables?> candidateData,
                              List<dynamic> rejectedData) {
                            // activeData.forEach((e) {
                            //   print(e!.idTable);
                            // });
                            return LayoutBuilder(
                                builder: (context, constraints) {
                              final width = constraints.maxWidth;
                              return Align(
                                alignment: const Alignment(-1, 0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: AnimatedBuilder(
                                      animation: tablesController,
                                      builder: (context, child) => Wrap(
                                            alignment: WrapAlignment.start,
                                            direction: Axis.horizontal,
                                            spacing: 20,
                                            children: [
                                              for (var i = 0;
                                                  i < activeData.length;
                                                  i++)
                                                ActiveTableWidget(
                                                  width: width,
                                                  i: i,
                                                  tablesController:
                                                      tablesController,
                                                  dashboardTable:
                                                      activeData[i]!,
                                                  avatarSize: sequenceAnimation[
                                                              'avatarSize']
                                                          .value +
                                                      60,
                                                  iconSize: sequenceAnimation[
                                                          'iconSize']
                                                      .value,
                                                )
                                            ],
                                          )),
                                ),
                              );
                            });
                          },
                        )
                      : const SizedBox())
              : const SizedBox();
        });
  }
}
