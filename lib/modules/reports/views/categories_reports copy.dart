import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../products/controller/products_notifier.dart';
import '../controllers/reports_controller.dart';
import '../models/reports_model.dart';

class DataItem {
  final double value;
  final String label;
  final Color color;
  DataItem({
    required this.value,
    required this.label,
    required this.color,
  });
}

const pal = [0xFFF238C, 0xFF05C7F2, 0xFF04D9C4, 0xFFF2B705, 0xFFF26241];

class CategoriesReport extends HookConsumerWidget {
  CategoriesReport({super.key});

  final List<DataItem> dataset = [
    DataItem(value: 0.2, label: 'Comedy', color: Color(pal[0])),
    DataItem(value: 0.25, label: 'Action', color: Color(pal[1])),
    DataItem(value: 0.3, label: 'Romance', color: Color(pal[2])),
    DataItem(value: 0.05, label: 'Drama', color: Color(pal[3])),
    DataItem(value: 0.2, label: 'Scifi', color: Color(pal[4]))
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DonutChartWidget(dataset: dataset);
  }
}

class DonutChartWidget extends StatefulHookConsumerWidget {
  const DonutChartWidget({super.key, required this.dataset});

  final List<DataItem> dataset;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DonutChartWidgetState();
}

class _DonutChartWidgetState extends ConsumerState<DonutChartWidget> {
  late Timer timer;
  double fullAngle = 0.0;
  double secondsToComplete = 5.0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 1000 ~/ 60), (timer) {
      setState(() {
        fullAngle += 360.0 / (secondsToComplete * 100 ~/ 60);
        if (fullAngle >= 360.0) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productSales = ref.watch(productSalesReportProvider);
    final categories = ref.watch(categoriesNotifier).value;

    List<CategoriesReportModel> categoriesReport = [];

    if (categories != null && productSales.isNotEmpty) {
      for (var category in categories) {
        final result = productSales
            .where((element) => element.productCategory == category.documentId)
            .map((e) => e.price)
            .reduce((value, e) => e + value);
        print("category = ${category.name}   total == $result");
        categoriesReport.add(CategoriesReportModel(
            total: result,
            productCategory: category.name,
            color: Color(pal[categories.indexOf(category)])));
      }
    }

    print(categoriesReport.length);

    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      double height = constraints.maxHeight;
      // print(constraints.maxWidth);
      // print(constraints.maxHeight);
      return Container(
        width: width,
        height: height,
        child: categoriesReport.isNotEmpty
            ? CustomPaint(
                child: Container(
                  height: height,
                  width: width,
                ),
                painter: DonutChartPainter(
                    dataset: categoriesReport,
                    width: width,
                    height: height,
                    fullAngle: fullAngle),
              )
            : const SizedBox(),
      );
    });
  }
}

final linePaint = Paint()
  ..color = Colors.white
  ..strokeWidth = 2.0
  ..style = PaintingStyle.stroke;

final midPaint = Paint()
  ..color = Colors.white
  ..style = PaintingStyle.fill;

const textFieldTextBigStyle = TextStyle(
  color: Colors.black38,
  fontSize: 24,
  fontWeight: FontWeight.bold,
);
const labelStyle = TextStyle(
  color: Colors.black87,
  fontSize: 12,
);

class DonutChartPainter extends CustomPainter {
  DonutChartPainter(
      {required this.dataset,
      required this.width,
      required this.height,
      required this.fullAngle});

  final List<CategoriesReportModel> dataset;
  final double width;
  final double height;
  final double fullAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(width / 2, height / 2);

    var startAngle = 0.0;
    final radius = width * 0.4;
    final rect = Rect.fromCenter(center: c, width: radius, height: radius);
    canvas.drawArc(rect, startAngle, fullAngle, false, linePaint);
    dataset.forEach((di) {
      var sweepAngle = di.total * fullAngle * pi / 180;
      drawSector(canvas, di, rect, startAngle);

      drawLine(canvas, c, radius, startAngle);
      startAngle += sweepAngle;
      // print("${di.label}: ${di.value}");
    });
    startAngle = 0.0;
    dataset.forEach((di) {
      var sweepAngle = di.total * fullAngle * pi / 180;

      drawLine(canvas, c, radius, startAngle);
      startAngle += sweepAngle;
    });
    startAngle = 0.0;
    dataset.forEach((di) {
      var sweepAngle = di.total * fullAngle * pi / 180;

      drawLabels(canvas, c, radius, startAngle, sweepAngle, di.productCategory);
      startAngle += sweepAngle;
    });
    //draw the middle
    canvas.drawCircle(c, radius * 0.3, midPaint);

    //draw the title
    drawTextCentered(canvas, c, 'Favourite\nMovie Genres',
        textFieldTextBigStyle, radius * 0.6);
  }

  void drawLabels(Canvas canvas, Offset c, double radius, double startAngle,
      double sweepAngle, String label) {
    final r = radius * 0.6;
    final dx = r * cos(startAngle + sweepAngle / 2);
    final dy = r * sin(startAngle + sweepAngle / 2);
    final position = c + Offset(dx, dy);
    drawTextCentered(canvas, position, label, labelStyle, 100);
  }

  TextPainter measureText(
      String s, TextStyle style, double maxWidth, TextAlign align) {
    final span = TextSpan(text: s, style: style);
    final tp = TextPainter(
        text: span, textAlign: align, textDirection: TextDirection.ltr);
    tp.layout(minWidth: 0, maxWidth: maxWidth);
    return tp;
  }

  Size drawTextCentered(Canvas canvas, Offset position, String text,
      TextStyle style, double maxWidth) {
    final tp = measureText(text, style, maxWidth, TextAlign.center);
    final pos = position + Offset(-tp.width / 2, -tp.height / 2);
    tp.paint(canvas, pos);
    return tp.size;
  }

  void drawLine(Canvas canvas, Offset c, double radius, double startAngle) {
    final dx = radius / 2.0 * cos(startAngle);
    final dy = radius / 2.0 * sin(startAngle);
    final p2 = c + Offset(dx, dy);
    canvas.drawLine(c, p2, linePaint);
  }

  void drawSector(
      Canvas canvas, CategoriesReportModel di, Rect rect, double startAngle) {
    var sweepAngle = di.total * 360 * pi / 180;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = di.color;
    canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
