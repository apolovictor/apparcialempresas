import 'dart:math';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../models/reports_model.dart';

class GraphPainter extends CustomPainter {
  final double percentage;
  final double width;
  final double height;
  final List<SalesModel> points;

  final double max;

  GraphPainter(this.percentage, this.height, this.width, this.points, this.max);

  @override
  void paint(Canvas canvas, Size size) {
    Path drawPath(bool closePath) {
      final path = Path();
      for (var i = 0; i < points.length - 1; i++) {
        path.moveTo(points[i].offset.dx,
            points.length == i ? height : points[i].offset.dy);
        path.cubicTo(
          (points[i].offset.dx + points[i + 1].offset.dx) / 2,
          points[i].offset.dy,
          (points[i].offset.dx + points[i + 1].offset.dx) / 2,
          points[i + 1].offset.dy,
          points[i + 1].offset.dx,
          points[i + 1].offset.dy,
        );

        // for the gradient fill, we want to close the path
        if (closePath) {
          path.lineTo(width, height);
          // if (i <= points.length - 1) {
          // path.lineTo(points[i].offset.dx, points[i].offset.dy);
          // }
        }
      }
      return path;
    }

    double minHeight = height;

    final paint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // List<String> labels = [];
    // labels = _computeValues();

    for (var i = 0; i < points.length; i++) {
      drawTextCentered(
          canvas,
          Offset(points[i].offset.dx, height + 10),
          points[i].weekDays,
          const TextStyle(color: Colors.white, fontSize: 12),
          width);
      final labele = points[i].total!.toStringAsFixed(2);

      drawTextCentered(
          canvas,
          Offset(points[i].offset.dx, points[i].offset.dy - 25),
          labele,
          const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          width);
    }

    List<Offset> _computePoints(List<SalesModel> points, double hr) {
      List<Offset> _points = [];
      points.forEach((yp) {
        final dp = Offset(yp.offset.dx, yp.offset.dy);
        _points.add(dp);
      });

      return _points;
    }

    final resultPoints = _computePoints(points, height / max);

    final path = Path();
    final metrics = drawPath(false).computeMetrics().toList();
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
        Colors.white.withOpacity(percentage),
        Colors.white.withOpacity(0.2),
      ],
    );
    canvas.drawPath(drawPath(true), paint);

    resultPoints.forEach((p) {
      canvas.drawCircle(
          p,
          5,
          Paint()
            ..color = Colors.black87
            ..style = PaintingStyle.fill
            ..strokeWidth = 1.0);

      canvas.drawCircle(
          p,
          5,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0);
    });
  }

  List<String> _computeValues() {
    return points.map((e) => e.total!.toStringAsFixed(2)).toList();
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
  bool shouldRepaint(GraphPainter oldDelegate) => true;
  // percentage != oldDelegate.percentage;
}
