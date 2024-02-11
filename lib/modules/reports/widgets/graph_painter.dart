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

  GraphPainter(this.percentage, this.height, this.width, this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final fullPath = Path();

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // final points = [
    //   Offset(36, height),
    //   Offset(100, 50),
    //   Offset(200, 100),
    //   Offset(300, 70),
    //   Offset(400, 135),
    //   Offset(500, 30),
    //   Offset(600, 168),
    // ];

    for (var i = 0; i < points.length - 1; i++) {
      fullPath.moveTo(points[i].offset.dx, points[i].offset.dy);
      fullPath.cubicTo(
        (points[i].offset.dx + points[i + 1].offset.dx) / 2,
        points[i].offset.dy,
        (points[i].offset.dx + points[i + 1].offset.dx) / 2,
        points[i + 1].offset.dy,
        points[i + 1].offset.dx,
        points[i + 1].offset.dy,
      );
    }
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
