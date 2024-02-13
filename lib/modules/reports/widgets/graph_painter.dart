import 'dart:math';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../models/reports_model.dart';

class GraphPainter extends CustomPainter {
  final double percentage;
  final double width;
  final double height;
  final List<SalesModel> points;
  Path fullPath;
  Path fillPath;

  GraphPainter(this.percentage, this.height, this.width, this.points,
      this.fullPath, this.fillPath);

  @override
  void paint(Canvas canvas, Size size) {
    // final fullPath = Path();

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < points.length; i++) {
      drawTextCentered(
          canvas,
          Offset(points[i].offset.dx, height + 10),
          points[i].weekDays,
          const TextStyle(color: Colors.white, fontSize: 12),
          width);
    }

    final path = Path();
    final metrics = fullPath.computeMetrics().toList();
    final fullPathLength = metrics.fold(
      0.0,
      (prev, metric) => prev + metric.length,
    );
    final pathEnd = percentage * fullPathLength;
    double currentPathEnd = 0;
    const step = 2;
    for (var metric in metrics) {
      final metricStart = currentPathEnd;
      final metricEnd = currentPathEnd + metric.length;
      while (currentPathEnd != metricEnd) {
        final upcomingPathEnd = min(currentPathEnd + step, metricEnd);
        final segment = metric.extractPath(
          currentPathEnd - metricStart,
          upcomingPathEnd - metricStart,
        );
        path.addPath(segment, Offset.zero);
        currentPathEnd = upcomingPathEnd;
        if (currentPathEnd >= pathEnd) break;
      }
      if (currentPathEnd >= pathEnd) break;
    }
    canvas.drawPath(path, paint);

    // paint the gradient fill
    paint.style = PaintingStyle.fill;
    paint.shader = ui.Gradient.linear(
      Offset.zero,
      Offset(0.0, size.height),
      [
        Colors.white.withOpacity(0.95),
        Colors.white.withOpacity(0.2),
      ],
    );
    canvas.drawPath(fillPath, paint);
  }

  TextPainter measureText(
      String s, TextStyle style, double maxWidth, TextAlign align) {
    final span = TextSpan(text: s, style: style);
    final tp = TextPainter(
        text: span, textAlign: align, textDirection: ui.TextDirection.ltr);
    tp.layout(minWidth: 0, maxWidth: maxWidth);
    return tp;
  }

  void drawTextCentered(
      Canvas canvas, Offset c, String text, TextStyle style, double maxWidth) {
    final tp = measureText(text, style, maxWidth, TextAlign.center);
    final offset = c + Offset(-tp.width / 2, 0);
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
