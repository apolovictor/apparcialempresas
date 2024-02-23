// import 'dart:async';
// import 'dart:math';
// import 'package:vector_math/vector_math.dart' as math;

// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../products/controller/products_notifier.dart';
// import '../controllers/reports_controller.dart';
// import '../models/reports_model.dart';
// import 'overlay_mixin.dart';

// const pieColors = [
//   Color(0xFFFEF1C2),
//   Color(0xFF99653D),
//   Color(0xFFE0AD1E),
//   Color(0xFFBDC94C),
//   Color(0xFF572C02),
//   Color(0xFFF2EC14),
//   Color(0xFFFFC41E),
//   Color(0xFF822B46),
//   Color(0xFFF94B4A),
//   Color(0xFFC2B2A0),
// ];

// class ArcData {
//   final Color color;
//   final Animation<double> radius;
//   final double startAngle;
//   final Data data;

//   ArcData({
//     required this.color,
//     required this.radius,
//     required this.startAngle,
//     required this.data,
//   });
// }

// class NightingaleChart extends StatefulWidget {
//   const NightingaleChart({
//     super.key,
//     required this.radius,
//     this.strokeWidth = 1,
//     required this.dataset,
//   });

//   final double radius;
//   final double strokeWidth;
//   final List<Data> dataset;

//   @override
//   State<NightingaleChart> createState() => _NightingaleChartState();
// }

// class _NightingaleChartState extends State<NightingaleChart>
//     with SingleTickerProviderStateMixin, OverlayStateMixin {
//   late AnimationController _controller;
//   late List<ArcData> arcs;

//   double get maxValue =>
//       widget.dataset.reduce((a, b) => a.value > b.value ? a : b).value;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     );

//     double sectionDegree = 360 / widget.dataset.length;
//     double currentSum = 0.0;
//     final intervalGap = 1 / widget.dataset.length;
//     arcs = widget.dataset.indexed.map((item) {
//       final (index, data) = item;
//       final startAngle = currentSum;
//       currentSum += sectionDegree;
//       return ArcData(
//         color: pieColors[index],
//         radius: Tween<double>(
//           begin: 0,
//           end: data.value / maxValue * widget.radius,
//         ).animate(
//           CurvedAnimation(
//             parent: _controller,
//             curve: Interval(
//               index * intervalGap,
//               (index + 1) * intervalGap,
//             ),
//           ),
//         ),
//         startAngle: -90 + startAngle,
//         data: data,
//       );
//     }).toList();

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = Size.fromRadius(widget.radius);
//     return SizedBox.fromSize(
//       size: size,
//       child: AnimatedBuilder(
//         animation: _controller,
//         builder: (context, child) {
//           return CanvasTouchDetector(
//             gesturesToOverride: const [
//               GestureType.onTapDown,
//             ],
//             builder: (canvasContext) {
//               return CustomPaint(
//                 painter: _ProgressPainter(
//                   context: canvasContext,
//                   strokeWidth: widget.strokeWidth,
//                   arcs: arcs,
//                   onSectionTap: _onSectionTap,
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   void _onSectionTap(
//     TapDownDetails details,
//     BuildContext context,
//     Color color,
//     String info,
//   ) {
//     late Offset offset;
//     final width = MediaQuery.sizeOf(context).width;
//     if (details.globalPosition > Offset(width - 60, 0)) {
//       offset = details.globalPosition - const Offset(50, 0);
//     } else {
//       offset = details.globalPosition;
//     }
//     toggleOverlay(
//       OverlayUI(borderColor: color, info: info),
//       offset,
//     );
//   }
// }

// class _ProgressPainter extends CustomPainter {
//   const _ProgressPainter({
//     required this.strokeWidth,
//     required this.arcs,
//     required this.context,
//     required this.onSectionTap,
//   });

//   final BuildContext context;
//   final double strokeWidth;
//   final List<ArcData> arcs;
//   final Function(
//     TapDownDetails details,
//     BuildContext context,
//     Color color,
//     String info,
//   ) onSectionTap;

//   List<Paint> get paints => arcs.map((arc) {
//         return Paint()
//           ..color = arc.color
//           ..strokeCap = StrokeCap.round
//           ..style = PaintingStyle.fill
//           ..strokeWidth = strokeWidth;
//       }).toList();

//   Paint get linePaint => Paint()
//     ..strokeWidth = strokeWidth
//     ..color = Colors.white;

//   double get sweepAngle => 360 / arcs.length;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final touchyCanvas = TouchyCanvas(context, canvas);
//     Offset center = Offset(size.width / 2, size.height / 2);

//     arcs.indexed.map((item) {
//       final (index, arc) = item;
//       touchyCanvas.drawArc(
//         Rect.fromCircle(
//           center: center,
//           radius: arc.radius.value,
//         ),
//         math.radians(arc.startAngle),
//         math.radians(sweepAngle),
//         true,
//         paints[index],
//         onTapDown: (tapDownDetails) => onSectionTap(
//           tapDownDetails,
//           context,
//           arc.color,
//           '${arc.data.label}\n${arc.data.value.toInt()}%',
//         ),
//       );
//       final endPoint = Offset(
//         arc.radius.value * cos(math.radians(arc.startAngle + sweepAngle)) +
//             center.dx,
//         arc.radius.value * sin(math.radians(arc.startAngle + sweepAngle)) +
//             center.dy,
//       );
//       touchyCanvas.drawLine(
//         center,
//         endPoint,
//         linePaint,
//       );
//     }).toList();
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
