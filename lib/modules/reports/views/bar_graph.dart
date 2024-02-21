import 'package:botecaria/modules/reports/widgets/product_reports_sitck.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/reports_model.dart';
import '../widgets/label.dart';

class BarGraph extends HookConsumerWidget {
  const BarGraph({super.key, required this.dataset});

  final List<Data> dataset;

  List<double> get amounts =>
      dataset.map((e) => e.medical + e.food + e.travel + e.others).toList();

  double get maxAmount => amounts.reduce((a, b) => a > b ? a : b);

  double get scale => maxAmount / 10;

  List<String> get horizontalLabels => dataset.map((e) => e.monthName).toList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: constraints.maxHeight,
        child: Row(
          key: key,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(horizontalLabels.length, (index) {
            final foodHeight = (dataset[index].food / maxAmount) *
                (constraints.maxHeight * 0.9);
            final medicalHeight = (dataset[index].medical / maxAmount) *
                (constraints.maxHeight * 0.9);
            final travelHeight = (dataset[index].travel / maxAmount) *
                (constraints.maxHeight * 0.9);
            final othersHeight = (dataset[index].others / maxAmount) *
                (constraints.maxHeight * 0.9);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              verticalDirection: VerticalDirection.up,
              children: [
                Label(label: horizontalLabels[index]),
                SizedBox(
                  height: constraints.maxHeight - 40,
                  child: Bar(
                    foodHeight: foodHeight,
                    medicalHeight: medicalHeight,
                    travelHeight: travelHeight,
                    othersHeight: othersHeight,
                    foodInfo: dataset[index].food.toString(),
                    medicalInfo: dataset[index].medical.toString(),
                    travelInfo: dataset[index].travel.toString(),
                    othersInfo: dataset[index].others.toString(),
                    width: constraints.maxWidth,
                  ),
                )
              ],
            );
          }),
        ),
      );
    });
  }
}

class Bar extends StatefulHookConsumerWidget {
  const Bar({
    super.key,
    required this.foodHeight,
    required this.medicalHeight,
    required this.travelHeight,
    required this.othersHeight,
    required this.foodInfo,
    required this.medicalInfo,
    required this.travelInfo,
    required this.othersInfo,
    required this.width,
  });

  final double foodHeight;
  final double medicalHeight;
  final double travelHeight;
  final double othersHeight;
  final String foodInfo;
  final String medicalInfo;
  final String travelInfo;
  final String othersInfo;
  final double width;

  @override
  ConsumerState<Bar> createState() => _BarState();
}

class _BarState extends ConsumerState<Bar> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> foodAnimation;
  late Animation<double> medicalAnimation;
  late Animation<double> travelAnimation;
  late Animation<double> othersAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    foodAnimation =
        Tween<double>(begin: 0, end: widget.foodHeight).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0, 0.25),
    ));

    medicalAnimation = Tween<double>(begin: 0, end: widget.medicalHeight)
        .animate(CurvedAnimation(
            parent: controller, curve: const Interval(0.25, 0.50)));
    travelAnimation = Tween<double>(begin: 0, end: widget.travelHeight).animate(
        CurvedAnimation(parent: controller, curve: const Interval(0.50, 0.75)));
    othersAnimation = Tween<double>(begin: 0, end: widget.othersHeight).animate(
        CurvedAnimation(parent: controller, curve: const Interval(0.75, 1.0)));

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Column(
            verticalDirection: VerticalDirection.up,
            children: [
              Stick(
                  value: foodAnimation.value,
                  color: Colors.grey,
                  info: widget.foodInfo,
                  uniqueKey: LabeledGlobalKey(widget.foodInfo),
                  width: widget.width),
              Stick(
                  value: medicalAnimation.value,
                  color: Colors.black87,
                  info: widget.medicalInfo,
                  uniqueKey: LabeledGlobalKey(widget.foodInfo),
                  width: widget.width),
              Stick(
                  value: travelAnimation.value,
                  color: Colors.blueAccent,
                  info: widget.travelInfo,
                  uniqueKey: LabeledGlobalKey(widget.foodInfo),
                  width: widget.width),
              Stick(
                  value: othersAnimation.value,
                  color: Colors.grey[200]!,
                  info: widget.othersInfo,
                  uniqueKey: LabeledGlobalKey(widget.foodInfo),
                  width: widget.width),
            ],
          );
        });
  }
}
