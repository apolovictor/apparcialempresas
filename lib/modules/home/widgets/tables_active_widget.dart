import 'package:apparcialempresas/modules/home/model/tables_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../orders/controller/orders_notifier.dart';
import '../model/orders_model.dart';
import 'tables.dart';

class ActiveTableWidget extends HookConsumerWidget {
  const ActiveTableWidget({
    super.key,
    required this.width,
    required this.i,
    required this.tablesController,
    required this.dashboardTable,
    required this.avatarSize,
    required this.iconSize,
  });

  final double width;
  final int i;
  final AnimationController tablesController;
  final DashboardTables dashboardTable;
  final double avatarSize;
  final double iconSize;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemList = ref.watch(itemListProvider);

    final idDocumentTable = ref.watch(tableIdDocumentNotifier);
    final itemOrderList = ref
        .read(recentOrdersDashboardProvider.notifier)
        .getOrdersByIdDocumentTable(dashboardTable.documentId!);

    return AnimationLimiter(
        key: GlobalKey<AnimatedListState>(debugLabel: i.toString()),
        child: AnimationConfiguration.staggeredList(
            position: i,
            child: SlideAnimation(
              horizontalOffset: width,
              child: FadeTransition(
                opacity: tablesController,
                child: SizeTransition(
                  sizeFactor: tablesController,
                  child: MaterialButton(
                    shape: const CircleBorder(),
                    height: 75,
                    onPressed: () async {
                      if (idDocumentTable != dashboardTable.documentId &&
                          itemList.isNotEmpty) {
                        ref.read(currentOrderStateProvider.notifier).state =
                            OrderStateWidget.open;
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  insetPadding: const EdgeInsets.all(10),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        // 1.3,
                                        height: 200,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.white),
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 50, 20, 20),
                                        child: Text(
                                            "Deseja descartar itens da mesa nº ${dashboardTable.idTable} e abrir a mesa nº ${dashboardTable.idTable}?",
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.black87),
                                            textAlign: TextAlign.center),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                                child: const Text(
                                                  'Não',
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  ref
                                                          .read(
                                                              currentOrderStateProvider
                                                                  .notifier)
                                                          .state =
                                                      OrderStateWidget.close;
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Itens removidos da mesa nº ${dashboardTable.idTable} com sucesso!",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity: ToastGravity.TOP,
                                                      timeInSecForIosWeb: 3,
                                                      webBgColor: '#151515',
                                                      textColor: Colors.white,
                                                      fontSize: 18.0);

                                                  ref
                                                      .read(itemListProvider
                                                          .notifier)
                                                      .clearItemList();
                                                  bool isAddingItem = ref.watch(
                                                      isAddingItemProvider);
                                                  ref
                                                      .read(isAddingItemProvider
                                                          .notifier)
                                                      .toogle(false);

                                                  ref
                                                          .read(
                                                              currentOrderStateProvider
                                                                  .notifier)
                                                          .state =
                                                      OrderStateWidget.open;

                                                  ref
                                                          .read(
                                                              tableIdDocumentNotifier
                                                                  .notifier)
                                                          .state =
                                                      dashboardTable
                                                          .documentId!;

                                                  Navigator.pop(context, false);
                                                },
                                                child: const Text(
                                                  'Sim',
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold),
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

                        ref.read(tableIdDocumentNotifier.notifier).state =
                            dashboardTable.documentId!;
                      }

                      // ref
                      //     .read(isOpenProvider
                      //         .notifier)
                      //     .toogle(
                      //         true);
                    },
                    child: StreamBuilder(
                        stream: itemOrderList,
                        builder: (ctx,
                            AsyncSnapshot<List<DashboardDetailOrders>>
                                snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.data != null) {
                            // print(snapshot.data!
                            //     .map((e) => e.price)
                            //     .reduce((a, b) => a + b));

                            return NeumorphismTable(
                              radius: avatarSize,
                              avatarSize: iconSize,
                              padding: 15,
                              table: dashboardTable,
                              total: snapshot.data!.length > 0
                                  ? snapshot.data!
                                      .map((e) => e.price)
                                      .reduce((a, b) => a + b)
                                  : 0,
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                  ),
                ),
              ),
            )));
  }
}
