import 'package:botecaria/services/date_services.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/reports_controller.dart';
import '../models/reports_model.dart';
import '../widgets/graph_painter.dart';
import 'sales_impl.dart';

class Sales extends StatefulHookConsumerWidget {
  const Sales({
    super.key,
  });

  @override
  ConsumerState<Sales> createState() => SalesState();
}

class SalesState extends ConsumerState<Sales>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  int? previousNumOfDays = 0;
  int numberOfDays = 7;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      animationController.forward();
    });
    // _prepareEntryList(widget.entries)
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    animation = Tween(begin: 7.0, end: 32.0).animate(animationController)
      ..addListener(() {
        setState(() {
          numberOfDays = animation.value.toInt();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final salesList = ref.watch(salesListNotifier);

    salesList.forEach((element) {
      print("element =========== ${element.dateTime} === ${element.total}");
    });

    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
          onScaleStart: (scaleDetails) =>
              setState(() => previousNumOfDays = numberOfDays),
          onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
            setState(() {
              int newNumberOfDays =
                  (previousNumOfDays! / scaleDetails.scale).round();
              if (newNumberOfDays >= 7 && newNumberOfDays <= 32) {
                numberOfDays = newNumberOfDays;
              }
            });
          },
          onDoubleTap: () => setState(
              () => numberOfDays > 15 ? numberOfDays = 7 : numberOfDays = 32),
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: ChartPainter(
              entries: salesList,
              drawingHeight: constraints.maxHeight * 0.9,
              drawingWidth: constraints.maxWidth * 0.94,
              numberOfDays: numberOfDays,
            ),
          ));
    });
  }
}
