import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:botecaria/services/date_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/reports_model.dart';
import 'package:tuple/tuple.dart';

class ChartPainter extends CustomPainter {
  final List<SalesModel> entries;
  final double drawingHeight;
  final double drawingWidth;
  final int numberOfDays;

  ChartPainter({
    required this.entries,
    required this.drawingHeight,
    required this.drawingWidth,
    required this.numberOfDays,
  });

  static int NUMBER_OF_HORIZONTAL_LINES = 4;

  @override
  void paint(Canvas canvas, Size size) {
    double leftOffsetStart = size.width * 0.05;
    double topOffsetEnd = size.height * 0.9;

    // double drawingHeight = topOffsetEnd;

    Tuple2<int, int> borderLineValues = _getMinAndMaxValues(entries);
    _drawHorizontalLinesAndLabels(canvas, size, borderLineValues.item1,
        borderLineValues.item2, leftOffsetStart);
    _drawBottomLabels(canvas, size, leftOffsetStart);
    _drawLines(canvas, borderLineValues.item1, borderLineValues.item2,
        leftOffsetStart);
  }

  double get _calculateHorizontalOffsetStep {
    return drawingHeight / (NUMBER_OF_HORIZONTAL_LINES - 1);
  }

  /// Draws horizontal lines and labels informing about weight values attached to those lines
  void _drawHorizontalLinesAndLabels(Canvas canvas, Size size, int minLineValue,
      int maxLineValue, double leftOffsetStart) {
    final paint = Paint()..color = Colors.black;
    int lineStep = _calculateHorizontalLineStep(maxLineValue, minLineValue);
    double offsetStep = _calculateHorizontalOffsetStep;
    print("offsetStep === $offsetStep");
    for (int line = 0; line < NUMBER_OF_HORIZONTAL_LINES; line++) {
      double yOffset = line * offsetStep;
      _drawHorizontalLabel(
          maxLineValue, line, lineStep, canvas, yOffset, leftOffsetStart);
      _drawHorizontalLine(canvas, yOffset, size, paint, leftOffsetStart);
    }
  }

  // Calculates weight difference between horizontal lines.
  ///
  /// e.g. every line should increment weight by 5
  int _calculateHorizontalLineStep(int maxLineValue, int minLineValue) {
    return (maxLineValue - minLineValue) ~/ (NUMBER_OF_HORIZONTAL_LINES - 1);
  }

  /// Calculates offset difference between horizontal lines.
  ///
  /// e.g. between every line should be 100px space.

  void _drawHorizontalLine(ui.Canvas canvas, double yOffset, ui.Size size,
      ui.Paint paint, double leftOffsetStart) {
    canvas.drawLine(
      Offset(leftOffsetStart, 5 + yOffset),
      Offset(size.width, 5 + yOffset),
      paint,
    );
  }

  void _drawHorizontalLabel(int maxLineValue, int line, int lineStep,
      ui.Canvas canvas, double yOffset, double leftOffsetStart) {
    ui.Paragraph paragraph = _buildParagraphForLeftLabel(
        maxLineValue, line, lineStep, leftOffsetStart);
    canvas.drawParagraph(
        paragraph, Offset(0.0, yOffset - (drawingHeight * 0.02)));
  }

  ///Builds text paragraph for label placed on the left side of a chart (weights)
  ui.Paragraph _buildParagraphForLeftLabel(
      int maxLineValue, int line, int lineStep, double leftOffsetStart) {
    ui.ParagraphBuilder builder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        fontSize: 20.0,
        textAlign: TextAlign.right,
      ),
    )
      ..pushStyle(ui.TextStyle(color: Colors.black))
      ..addText((maxLineValue - line * lineStep).toString());
    final ui.Paragraph paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: leftOffsetStart - 4));
    return paragraph;
  }

  void _drawBottomLabels(Canvas canvas, Size size, double leftOffsetStart) {
    for (int daysFromStart = numberOfDays;
        daysFromStart >= 0;
        daysFromStart -= numberOfDays == 32 ? 6 : 2) {
      double offsetXbyDay = drawingWidth / (numberOfDays);
      double offsetX = leftOffsetStart + offsetXbyDay * daysFromStart;
      ui.Paragraph paragraph = _buildParagraphForBottomLabel(daysFromStart);
      canvas.drawParagraph(
        paragraph,
        Offset(offsetX - 50.0, 10.0 + drawingHeight),
      );
    }
  }

  ///Builds paragraph for label placed on the bottom (dates)
  ui.Paragraph _buildParagraphForBottomLabel(int daysFromStart) {
    ui.ParagraphBuilder builder = ui.ParagraphBuilder(
        ui.ParagraphStyle(fontSize: 20.0, textAlign: TextAlign.right))
      ..pushStyle(ui.TextStyle(color: Colors.black))
      ..addText(DateFormat('d MMM').format(DateTime.now()
          .subtract(Duration(days: numberOfDays - daysFromStart))));
    final ui.Paragraph paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: 75.0));
    return paragraph;
  }

  void _drawLines(ui.Canvas canvas, int minLineValue, int maxLineValue,
      double leftOffsetStart) {
    final paint = Paint()
      ..color = Colors.blue[400]!
      ..strokeWidth = 4.0;
    DateTime beginningOfChart = _getStartDateOfChart();
    for (int i = 0; i < entries.length - 1; i++) {
      if (entries[i].dateTime.isAfter(beginningOfChart)) {
        // print("entries ==== ${entries[i].dateTime} ===== ${entries[i].weight}");
        Offset startEntryOffset = _getEntryOffset(entries[i], beginningOfChart,
            minLineValue, maxLineValue, leftOffsetStart);
        Offset endEntryOffset = _getEntryOffset(entries[i + 1],
            beginningOfChart, minLineValue, maxLineValue, leftOffsetStart);
        canvas.drawLine(startEntryOffset, endEntryOffset, paint);
        canvas.drawCircle(endEntryOffset, 5.0, paint);
      }
    }
    // canvas.drawRect(
    //     Rect.fromCenter(center: Offset.zero, width: 50, height: 0), paint);

    canvas.drawCircle(
        _getEntryOffset(entries.first, beginningOfChart, minLineValue,
            maxLineValue, leftOffsetStart),
        5.0,
        paint);
  }

  /// Calculates offset at which given entry should be painted
  Offset _getEntryOffset(SalesModel entry, DateTime beginningOfChart,
      int minLineValue, int maxLineValue, double leftOffsetStart) {
    // print(entry.weight);
    int daysFromBeginning = entry.dateTime.difference(beginningOfChart).inDays;
    double relativeXposition = daysFromBeginning / numberOfDays;
    double xOffset = leftOffsetStart + relativeXposition * drawingWidth;
    double relativeYposition =
        (entry.total - minLineValue) / (maxLineValue - minLineValue);
    double yOffset = 5 + drawingHeight - relativeYposition * drawingHeight;
    return Offset(xOffset, yOffset);
  }

  Tuple2<int, int> _getMinAndMaxValues(List<SalesModel> entries) {
    double maxWeight = entries.map((entry) => entry.total).reduce(math.max);
    double minWeight = entries.map((entry) => entry.total).reduce(math.min);

    int maxLineValue = (maxWeight * 1.1).ceil();

    int difference = maxLineValue - minWeight.floor();
    int toSubtract = (NUMBER_OF_HORIZONTAL_LINES - 1) -
        (difference % (NUMBER_OF_HORIZONTAL_LINES - 1));
    if (toSubtract == NUMBER_OF_HORIZONTAL_LINES - 1) {
      toSubtract = 0;
    }
    int minLineValue = minWeight.floor() - toSubtract;

    return Tuple2(minLineValue, maxLineValue);
  }

  DateTime _getStartDateOfChart() {
    DateTime now = DateTime.now();
    DateTime beginningOfChart = now.subtract(
        Duration(days: numberOfDays + 1, hours: now.hour, minutes: now.minute));
    return beginningOfChart;
  }

  @override
  bool shouldRepaint(ChartPainter oldDelegate) => true;
}
