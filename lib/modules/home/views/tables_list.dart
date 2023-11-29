import 'package:apparcialempresas/modules/home/model/tables_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
                                            child: AnimationConfiguration
                                                .staggeredList(
                                                    position: i,
                                                    child: SlideAnimation(
                                                        horizontalOffset: width,
                                                        child: FadeTransition(
                                                          opacity:
                                                              tablesController,
                                                          child: SizeTransition(
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
                                                                        data[
                                                                            i]!);
                                                                print(data[i]!
                                                                    .idTable);
                                                                print(
                                                                    'onDragStarted');
                                                              },
                                                              onDragCompleted:
                                                                  () {
                                                                print(
                                                                    'onDragCompleted');
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
                                                                radius: sequenceAnimation[
                                                                            'avatarSize']
                                                                        .value +
                                                                    80,
                                                                avatarSize:
                                                                    sequenceAnimation['iconSize']
                                                                            .value +
                                                                        30,
                                                                padding: 15,
                                                                table: data[i]!,
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
                                                                  radius: sequenceAnimation[
                                                                              'avatarSize']
                                                                          .value +
                                                                      60,
                                                                  avatarSize:
                                                                      sequenceAnimation[
                                                                              'iconSize']
                                                                          .value,
                                                                  padding: 15,
                                                                  table:
                                                                      data[i]!,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ))),
                                          )
                                        : SizedBox(),
                                ],
                              )),
                    ),
                  );
                })
              : const SizedBox();
        });
  }
}
