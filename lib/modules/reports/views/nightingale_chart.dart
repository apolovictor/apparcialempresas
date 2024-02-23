import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:touchable/touchable.dart';
// import 'package:micro_animations/distributed_graph_ui/overlay_mixin.dart';
// import 'package:micro_animations/nightingale_chart/dataset.dart';
// import 'package:micro_animations/overlay_ui.dart';
import 'package:vector_math/vector_math.dart' as math;

import '../models/reports_model.dart';
import 'overlay_mixin.dart';

const pal = [0xFF04D9C4, 0xFF05C7F2, 0xFFF238C, 0xFFF2B705, 0xFFF26241];

class NightingaleChart extends StatefulHookConsumerWidget {
  const NightingaleChart({
    super.key,
    required this.width,
    required this.height,
    required this.radius,
    this.strokeWidth = 1,
    required this.categoriesReport,
  });
  final double width;
  final double height;
  final double radius;
  final double strokeWidth;
  final List<CategoriesReportModel> categoriesReport;

  @override
  ConsumerState<NightingaleChart> createState() => _NightingaleChartState();
}

class _NightingaleChartState extends ConsumerState<NightingaleChart>
    with SingleTickerProviderStateMixin, OverlayStateMixin {
  // late AnimationController _controller;
  late List<ArcData> arcs;

  double get maxValue =>
      widget.categoriesReport.reduce((a, b) => a.total > b.total ? a : b).total;

  List<CategoriesReportModel> get getCategoriesReport =>
      widget.categoriesReport;

  @override
  Widget build(BuildContext context) {
    AnimationController _controller =
        useAnimationController(duration: const Duration(milliseconds: 1000));

    _controller.forward();

    double sectionDegree = 360 / widget.categoriesReport.length;
    double currentSum = 0.0;
    final intervalGap = 1 / widget.categoriesReport.length;
    arcs = getCategoriesReport.indexed.map((item) {
      final (index, data) = item;
      final startAngle = currentSum;
      currentSum += sectionDegree;
      return ArcData(
        color: Color(pal[index]),
        radius: Tween<double>(
          begin: 0,
          end: data.total / maxValue * widget.radius,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              index * intervalGap,
              (index + 1) * intervalGap,
            ),
          ),
        ),
        startAngle: -90 + startAngle,
        data: data,
      );
    }).toList();

    // _controller.forward();
    final size = Size(widget.radius, widget.radius);
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox.fromSize(
        size: size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return TapRegion(
              onTapOutside: (_) => removeOverlay(),
              child: CanvasTouchDetector(
                gesturesToOverride: const [
                  GestureType.onTapDown,
                ],
                builder: (canvasContext) {
                  final GlobalKey globalKey = GlobalKey();

                  return CustomPaint(
                    painter: _ProgressPainter(
                      context: canvasContext,
                      strokeWidth: widget.strokeWidth,
                      arcs: arcs,
                      key: globalKey,
                      onSectionTap: _onSectionTap,
                    ),
                    child: TapRegion(
                      onTapOutside: (_) => removeOverlay(),
                      child: Container(
                        key: globalKey,
                        width: widget.width,
                        height: widget.height,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    });
  }

  _onSectionTap(
    TapDownDetails details,
    BuildContext context,
    Color color,
    String info,
    GlobalKey key,
  ) {
    Offset offset = Offset.zero;

    final box = key.currentContext!.findRenderObject() as RenderBox;
    offset = Offset(box.localToGlobal(Offset.zero).dx, 0);

    removeOverlay();
    toggleOverlay(
      OverlayUI(borderColor: color, info: info),
      offset,
    );
  }
}

class _ProgressPainter extends CustomPainter {
  const _ProgressPainter({
    required this.strokeWidth,
    required this.arcs,
    required this.context,
    required this.onSectionTap,
    required this.key,
  });

  final BuildContext context;
  final double strokeWidth;
  final List<ArcData> arcs;
  final GlobalKey key;

  final Function(
    TapDownDetails details,
    BuildContext context,
    Color color,
    String info,
    GlobalKey key,
  ) onSectionTap;

  List<Paint> get paints => arcs.map((arc) {
        return Paint()
          ..color = arc.color
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.fill
          ..strokeWidth = strokeWidth;
      }).toList();

  Paint get linePaint => Paint()
    ..strokeWidth = strokeWidth
    ..color = Colors.white;

  double get sweepAngle => 360 / arcs.length;

  @override
  void paint(Canvas canvas, Size size) {
    final touchyCanvas = TouchyCanvas(context, canvas);
    Offset center = Offset(size.width / 2, size.height / 2);

    arcs.indexed.map((item) {
      final (index, arc) = item;
      // print("arc.data.total == ${arc.data.total}");
      touchyCanvas.drawArc(
        Rect.fromCircle(
          center: center,
          // radius: arc.radius,
          radius: arc.radius.value,
        ),
        math.radians(arc.startAngle),
        math.radians(sweepAngle),
        true,
        paints[index],
        onTapDown: (tapDownDetails) => onSectionTap(
          tapDownDetails,
          context,
          arc.color,
          '${arc.data.productCategory}\nTotal R\$ ${arc.data.total.toStringAsFixed(2)}',
          key,
        ),
      );
      final endPoint = Offset(
        arc.radius.value * cos(math.radians(arc.startAngle + sweepAngle)) +
            center.dx,
        arc.radius.value * sin(math.radians(arc.startAngle + sweepAngle)) +
            center.dy,
      );
      touchyCanvas.drawLine(
        center,
        endPoint,
        linePaint,
      );
    }).toList();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class OverlayUI extends StatelessWidget {
  const OverlayUI({super.key, required this.borderColor, required this.info});

  final Color borderColor;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 4),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Text(
        info,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
      ),
    );
  }
}

class ArcData {
  final Color color;
  final Animation<double> radius;
  final double startAngle;
  final CategoriesReportModel data;

  ArcData({
    required this.color,
    required this.radius,
    required this.startAngle,
    required this.data,
  });
}
