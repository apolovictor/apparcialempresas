import 'package:botecaria/modules/home/model/tables_model.dart';
import 'package:botecaria/modules/orders/model/order_model.dart';
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

class TablesList extends HookConsumerWidget {
  const TablesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tables = ref.read(tablesNotifierProvider);

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

    TextEditingController clientName = TextEditingController();

    return ref.watch(tables.tableChangeNotifier).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(err.toString())),
        data: (data) {
          return data != null
              ? LayoutBuilder(builder: (context, constraints) {
                  double width = constraints.maxWidth;

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
                                  for (var i = 0; i < data.length; i++)
                                    data[i]!.status == 1
                                        ? AnimationLimiter(
                                            key: GlobalKey<AnimatedListState>(
                                                debugLabel: i.toString()),
                                            child:
                                                AnimationConfiguration
                                                    .staggeredList(
                                                        position: i,
                                                        child: SlideAnimation(
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
                                                                child: LongPressDraggable<
                                                                    DashboardTables>(
                                                                  onDragStarted:
                                                                      () {
                                                                    ref
                                                                        .read(dragTableNotifier
                                                                            .notifier)
                                                                        .fetchdragTable(
                                                                            data[i]!);
                                                                  },
                                                                  onDragCompleted:
                                                                      () {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      barrierDismissible:
                                                                          false,
                                                                      builder:
                                                                          (context) =>
                                                                              Dialog(
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        insetPadding: const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                        child:
                                                                            Stack(
                                                                          clipBehavior:
                                                                              Clip.none,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          children: <Widget>[
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width / 2,
                                                                              height: 200,
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                                                                              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                                                                              child: Center(
                                                                                child: Column(
                                                                                  children: [
                                                                                    const Text("Adicione o nome do cliente da mesa", style: TextStyle(fontSize: 22, color: Colors.black54), textAlign: TextAlign.center),
                                                                                    TextFormField(
                                                                                        controller: clientName,
                                                                                        decoration: InputDecoration(
                                                                                          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
                                                                                          hintText: 'Nome',
                                                                                          fillColor: Colors.purple[50],
                                                                                          // fillColor: const Color(0xFFD7D7F4),
                                                                                          hintStyle: TextStyle(color: Colors.purple[50]),
                                                                                          filled: true,
                                                                                        ),
                                                                                        keyboardType: TextInputType.text)
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              bottom: 10,
                                                                              right: 0,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  TextButton(
                                                                                      onPressed: () {
                                                                                        // ref.read(addOrderProvider.notifier).addOrder(AddOrder('', clientName.text, data[i]!.idTable.toString(), [], 0, Timestamp(0, 0)));
                                                                                        ref.read(isOpenProvider.notifier).toogle(ref.watch(isOpenProvider));
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: const Text('Não', style: TextStyle(color: Color(0xFF00796b), fontWeight: FontWeight.bold))),
                                                                                  TextButton(
                                                                                      onPressed: () async {
                                                                                        // ref.read(addOrderProvider.notifier).addOrder(AddOrder('', clientName.text, data[i]!.idTable.toString(), [], 0, Timestamp(0, 0)));
                                                                                        ref.read(isOpenProvider.notifier).toogle(ref.watch(isOpenProvider));
                                                                                        if (clientName.text.isEmpty) {
                                                                                          Fluttertoast.showToast(
                                                                                            msg: "Prosseguindo sem uma referência da mesa.\nPoderá ser adicionado no carrinho de produtos.",
                                                                                            webPosition: "center",
                                                                                            webBgColor: "#bbdefb",
                                                                                            timeInSecForIosWeb: 5,
                                                                                            textColor: Colors.black87,
                                                                                            gravity: ToastGravity.SNACKBAR,
                                                                                          );
                                                                                        }

                                                                                        ref.read(registerOrderProvider).registerOrder(data[i]!.idTable, clientName.text);

                                                                                        Fluttertoast.showToast(msg: "Conta aberta com sucesso!", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP, timeInSecForIosWeb: 3, webBgColor: '#151515', textColor: Colors.white, fontSize: 18.0);

                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: const Text(
                                                                                        'Sim',
                                                                                        style: TextStyle(color: Color(0xFF00796b), fontWeight: FontWeight.bold),
                                                                                      )),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  onDragEnd:
                                                                      (DraggableDetails
                                                                          details) {
                                                                    ref
                                                                        .read(dragTableNotifier
                                                                            .notifier)
                                                                        .clear();
                                                                  },
                                                                  // onDraggableCanceled:
                                                                  //     (Velocity velocity,
                                                                  //         Offset offset) {
                                                                  //   print(
                                                                  //       'onDraggableCanceled');
                                                                  //   print(
                                                                  //       'velocity: $velocity}');
                                                                  //   print(
                                                                  //       'offset: $offset');
                                                                  // },
                                                                  data: data[i],
                                                                  feedback:
                                                                      NeumorphismTable(
                                                                    radius:
                                                                        sequenceAnimation['avatarSize'].value +
                                                                            80,
                                                                    avatarSize:
                                                                        sequenceAnimation['iconSize'].value +
                                                                            30,
                                                                    padding: 15,
                                                                    table: data[
                                                                        i]!,
                                                                  ),
                                                                  child:
                                                                      MaterialButton(
                                                                    shape:
                                                                        const CircleBorder(),
                                                                    height: 75,
                                                                    onPressed:
                                                                        () {},
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
                                                                      table: data[
                                                                          i]!,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ))),
                                          )
                                        : const SizedBox(),
                                ],
                              )),
                    ),
                  );
                })
              : const SizedBox();
        });
  }
}
