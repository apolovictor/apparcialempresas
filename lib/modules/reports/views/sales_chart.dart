import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:ui' as ui;

// import '../components/chart_data_point.dart';
import '../components/chart_labels.dart';
import '../components/slide_selector.dart';
import '../components/week_summary.dart';
import '../models/laughing_data.dart';

// convert HookConsumerWidget on line 6 to ConsumerStatefulWidget to use the ref.watch method

class SalesChart extends ConsumerStatefulWidget {
  const SalesChart({super.key});

  @override
  SalesChartState createState() => SalesChartState();
}

class SalesChartState extends ConsumerState<SalesChart>
    with SingleTickerProviderStateMixin {
  late List<ChartDataPoint> chartData;

  int activeWeek = 3;
  PageController summaryController = PageController(
    viewportFraction: 1,
    initialPage: 3,
  );
  // double chartHeight = 240;
  static const leftPadding = 60.0;
  static const rightPadding = 60.0;

  @override
  void initState() {
    super.initState();
    chartData = normalizeData(weeksData[activeWeek - 1]);
  }

  List<ChartDataPoint> normalizeData(WeekData weekData) {
    final maxDay = weekData.days.reduce((DayData dayA, DayData dayB) {
      return dayA.laughs > dayB.laughs ? dayA : dayB;
    });
    final normalizedList = <ChartDataPoint>[];
    weekData.days.forEach((element) {
      normalizedList.add(ChartDataPoint(
          value: maxDay.laughs == 0 ? 0 : element.laughs / maxDay.laughs));
    });
    return normalizedList;
  }

  void changeWeek(int week) {
    setState(() {
      activeWeek = week;
      summaryController.animateToPage(week,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      chartData = normalizeData(weeksData[week - 1]);
    });
  }

  Path drawPath(chartHeight, double width, bool closePath) {
    final height = chartHeight;
    final path = Path();
    final segmentWidth =
        (width - leftPadding - rightPadding) / ((chartData.length - 1) * 3);

    path.moveTo(0, height - chartData[0].value * height);
    path.lineTo(leftPadding, height - chartData[0].value * height);
// curved line
    for (var i = 1; i < chartData.length; i++) {
      path.cubicTo(
          (3 * (i - 1) + 1) * segmentWidth + leftPadding,
          height - chartData[i - 1].value * height,
          (3 * (i - 1) + 2) * segmentWidth + leftPadding,
          height - chartData[i].value * height,
          (3 * (i - 1) + 3) * segmentWidth + leftPadding,
          height - chartData[i].value * height);
    }
    path.lineTo(width, height - chartData[chartData.length - 1].value * height);
// for the gradient fill, we want to close the path
    if (closePath) {
      path.lineTo(width, height);
      path.lineTo(0, height);
    }

    return path;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrainst) {
      double chartHeight = constrainst.maxHeight;
      return Material(
        child: Stack(
          children: [
            const DashboardBackground(),
            ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SlideSelector(
                    defaultSelectedIndex: activeWeek - 1,
                    items: <SlideSelectorItem>[
                      SlideSelectorItem(
                        text: 'Semana 1',
                        onTap: () {
                          changeWeek(1);
                        },
                      ),
                      SlideSelectorItem(
                        text: 'Semana 2',
                        onTap: () {
                          changeWeek(2);
                        },
                      ),
                      SlideSelectorItem(
                        text: 'Semana 3',
                        onTap: () {
                          changeWeek(3);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: (chartHeight + (constrainst.maxHeight / 15)) / 2.5,
                  color: Colors.blueAccent,
                  child: Stack(
                    children: [
                      ChartLaughLabels(
                        chartHeight: chartHeight / 3,
                        topPadding: 40,
                        leftPadding: leftPadding,
                        rightPadding: rightPadding,
                        weekData: weeksData[activeWeek - 1],
                      ),
                      Positioned(
                        top: 40,
                        child: CustomPaint(
                          size: Size(constrainst.maxWidth, chartHeight / 2),
                          painter: PathPainter(
                            path: drawPath(chartHeight / 2.89,
                                constrainst.maxWidth, false),
                            fillPath: drawPath(
                                chartHeight / 2.89, constrainst.maxWidth, true),
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ChartDayLabels(
                          leftPadding: leftPadding,
                          rightPadding: rightPadding,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: 400,
                  child: PageView.builder(
                    clipBehavior: Clip.none,
                    physics: const NeverScrollableScrollPhysics(),
                    controller: summaryController,
                    itemCount: 4,
                    itemBuilder: (_, i) {
                      return WeekSummary(week: i);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class DashboardBackground extends StatelessWidget {
  const DashboardBackground({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.blueAccent,
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class PathPainter extends CustomPainter {
  Path path;
  Path fillPath;

  PathPainter({required this.path, required this.fillPath});
  @override
  void paint(Canvas canvas, Size size) {
    // paint the line
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawPath(path, paint);
    paint.style = PaintingStyle.fill;
    paint.shader = ui.Gradient.linear(
      Offset.zero,
      Offset(0.0, size.height),
      [
        Colors.white.withOpacity(0.2),
        Colors.white.withOpacity(0.85),
      ],
    );
    canvas.drawPath(fillPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ChartDataPoint {
  double value;
  ChartDataPoint({required this.value});
}
