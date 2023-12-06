import 'package:apparcialempresas/modules/home/model/tables_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../orders/controller/orders_notifier.dart';
import '../controller/tables_notifier.dart';
import '../widgets/tables.dart';

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
                            ref
                                .read(dragTableNotifier.notifier)
                                .bookingOrderedByDraggable(data);
                          },
                          builder: (BuildContext context,
                              List<DashboardTables?> candidateData,
                              List<dynamic> rejectedData) {
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
                                                AnimationLimiter(
                                                    key: GlobalKey<
                                                            AnimatedListState>(
                                                        debugLabel:
                                                            i.toString()),
                                                    child: AnimationConfiguration
                                                        .staggeredList(
                                                            position: i,
                                                            child:
                                                                SlideAnimation(
                                                              horizontalOffset:
                                                                  width,
                                                              child:
                                                                  FadeTransition(
                                                                opacity:
                                                                    tablesController,
                                                                child:
                                                                    SizeTransition(
                                                                  sizeFactor:
                                                                      tablesController,
                                                                  child:
                                                                      MaterialButton(
                                                                    shape:
                                                                        const CircleBorder(),
                                                                    height: 75,
                                                                    onPressed:
                                                                        () async {
                                                                      // if (activeData[i]!
                                                                      //         .idTable
                                                                      //         .toString() ==
                                                                      //     addOrder
                                                                      //         .idTable) {}
                                                                      // print(
                                                                      //     'here');
                                                                      ref.read(currentOrderStateProvider.notifier).state =
                                                                          OrderStateWidget
                                                                              .open;

                                                                      ref
                                                                          .read(tableIdDocumentNotifier
                                                                              .notifier)
                                                                          .state = activeData[
                                                                              i]!
                                                                          .documentId!;

                                                                      // ref
                                                                      //     .read(isOpenProvider
                                                                      //         .notifier)
                                                                      //     .toogle(
                                                                      //         true);
                                                                    },
                                                                    child:
                                                                        NeumorphismTable(
                                                                      radius:
                                                                          sequenceAnimation['avatarSize'].value +
                                                                              60,
                                                                      avatarSize:
                                                                          sequenceAnimation['iconSize']
                                                                              .value,
                                                                      padding:
                                                                          15,
                                                                      table:
                                                                          activeData[
                                                                              i]!,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ))),
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
