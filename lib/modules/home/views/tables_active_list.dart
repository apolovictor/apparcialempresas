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

class TablesListActive extends HookConsumerWidget {
  const TablesListActive({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tables = ref.read(tablesNotifierProvider);
    final itemList = ref.watch(itemListProvider);
    final idDocumentTable = ref.watch(tableIdDocumentNotifier);
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
                            print(currentTimeStamp);
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
                                                                      if (idDocumentTable !=
                                                                              activeData[i]!.documentId &&
                                                                          itemList.isNotEmpty) {
                                                                        ref.read(currentOrderStateProvider.notifier).state =
                                                                            OrderStateWidget.open;
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder: (context) =>
                                                                                Dialog(
                                                                                  backgroundColor: Colors.transparent,
                                                                                  insetPadding: const EdgeInsets.all(10),
                                                                                  child: Stack(
                                                                                    clipBehavior: Clip.none,
                                                                                    alignment: Alignment.center,
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                        width: MediaQuery.of(context).size.width / 2,
                                                                                        // 1.3,
                                                                                        height: 200,
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                                                                                        padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                                                                                        child: Text("Deseja descartar itens da mesa nº ${activeData.firstWhere((e) => e!.documentId == idDocumentTable)!.idTable} e abrir a mesa nº ${activeData[i]!.idTable}?", style: TextStyle(fontSize: 22, color: Colors.black87), textAlign: TextAlign.center),
                                                                                      ),
                                                                                      Positioned(
                                                                                        bottom: 10,
                                                                                        right: 0,
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                          children: [
                                                                                            TextButton(
                                                                                                onPressed: () {
                                                                                                  Navigator.pop(context, false);
                                                                                                },
                                                                                                child: const Text(
                                                                                                  'Não',
                                                                                                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                                                                                                )),
                                                                                            TextButton(
                                                                                                onPressed: () {
                                                                                                  ref.read(currentOrderStateProvider.notifier).state = OrderStateWidget.close;
                                                                                                  Fluttertoast.showToast(msg: "Itens removidos da mesa nº ${activeData.firstWhere((e) => e!.documentId == idDocumentTable)!.idTable} com sucesso!", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP, timeInSecForIosWeb: 3, webBgColor: '#151515', textColor: Colors.white, fontSize: 18.0);

                                                                                                  ref.read(itemListProvider.notifier).clearItemList();
                                                                                                  bool isAddingItem = ref.watch(isAddingItemProvider);
                                                                                                  ref.read(isAddingItemProvider.notifier).toogle(false);

                                                                                                  ref.read(currentOrderStateProvider.notifier).state = OrderStateWidget.open;

                                                                                                  ref.read(tableIdDocumentNotifier.notifier).state = activeData[i]!.documentId!;

                                                                                                  Navigator.pop(context, false);
                                                                                                },
                                                                                                child: const Text(
                                                                                                  'Sim',
                                                                                                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                                                                                                )),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ));
                                                                      } else {
                                                                        ref.read(currentOrderStateProvider.notifier).state =
                                                                            OrderStateWidget.open;

                                                                        ref
                                                                            .read(tableIdDocumentNotifier
                                                                                .notifier)
                                                                            .state = activeData[
                                                                                i]!
                                                                            .documentId!;
                                                                      }

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
