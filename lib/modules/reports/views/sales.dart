import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../services/date_services.dart';
import '../controllers/reports_controller.dart';
import '../models/reports_model.dart';
import '../widgets/graph_painter.dart';
import 'sales_impl.dart';

var scaleFactorNotifier = StateProvider((_) => 1.0);
var baseScaleFactorNotifier = StateProvider((_) => 1.0);

class Sales extends HookConsumerWidget {
  const Sales({
    super.key,
    required this.max,
  });

  final double max;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // double scaleFactor = ref.watch(scaleFactorNotifier);
    // double baseScaleFactor = ref.watch(baseScaleFactorNotifier);
    int timeToFilter = ref.watch(timeToFilterNotifier);
    final salesList = ref.watch(salesListNotifier);

    // print(scaleFactor);

    AnimationController salesController =
        useAnimationController(duration: const Duration(seconds: 1));

    final Animation<double> animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: salesController, curve: Curves.easeInOutCirc));

    return LayoutBuilder(builder: (context, constraints) {
      // print(
      //     "constraints.maxHeight ==== ${constraints.maxHeight}");
      // print(salesController.status);
      // salesController.addStatusListener((status) {
      //   print(status);
      // });
      // Future.delayed(Duration.zero, () {
      // });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        salesController.forward();
      });
      print(salesList.length);
      salesList.forEach((element) {
        print("element =========== $element");
      });
      return GestureDetector(
          // onScaleStart: (details) {
          //   if (scaleFactor >= 0.5) {
          //     ref.read(baseScaleFactorNotifier.notifier).state = scaleFactor;
          //   } else {
          //     ref.read(scaleFactorNotifier.notifier).state = 0.51;
          //     // return;
          //   }
          // },
          // onScaleUpdate: (details) {
          //   if (scaleFactor > 0.5 && details.scale > 0.5) {
          //     ref.read(scaleFactorNotifier.notifier).state =
          //         ref.read(baseScaleFactorNotifier) * details.scale;
          //   } else {
          //     return;
          //   }
          // },
          onDoubleTap: () {
            // ref.read(salesListNotifier.notifier).clear();
            // salesController.reset();

            timeToFilter == 7
                ? ref.read(timeToFilterNotifier.notifier).state = 15
                : ref.read(timeToFilterNotifier.notifier).state = 7;
          },
          // onScaleEnd: (details) {
          //   ref.read(salesListNotifier.notifier).clear();

          //   if (scaleFactor < 0.7) {
          //     ref.read(timeToFilterNotifier.notifier).state = 15;
          //   } else {
          //     ref.read(timeToFilterNotifier.notifier).state = 7;
          //   }
          // },
          child: AnimatedBuilder(
              animation: salesController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: GraphPainter(animation.value, constraints.maxHeight,
                      constraints.maxWidth, salesList, max * 1.2),
                );
              })
          // : SizedBox(),
          );
    });
  }
}

// class CustomCircularProgressIndicator extends LeafRenderObjectWidget {
//   final double progress;

//   CustomCircularProgressIndicator({required this.progress});

//   // Step 1: Create the RenderObject
//   @override
//   RenderObject createRenderObject(BuildContext context) {
//     // Step 1.1: Instantiate the custom RenderObject with the provided progress
//     return _CustomCircularProgressIndicatorRenderObject(progress: progress);
//   }

//   // Step 2: Update the RenderObject when the widget's properties change
//   @override
//   void updateRenderObject(BuildContext context,
//       _CustomCircularProgressIndicatorRenderObject renderObject) {
//     // Step 2.1: Update the progress property of the custom RenderObject
//     renderObject..progress = progress;
//   }
// }

// class _CustomCircularProgressIndicatorRenderObject extends RenderBox {
//   double progress;

//   _CustomCircularProgressIndicatorRenderObject({required this.progress});

//   // Step 1: Indicate that this RenderBox uses parent's constraints for sizing
//   @override
//   bool get sizedByParent => true;

//   // Step 2: Perform layout to set the size of the RenderBox
//   @override
//   void performLayout() {
//     // Step 2.1: Set the size of the RenderBox to be the biggest possible within its constraints
//     size = constraints.biggest;
//   }

//   // Step 3: Paint the visual representation of the custom circular progress indicator
//   @override
//   void paint(PaintingContext context, Offset offset) {
//     // Step 3.1: Create a Paint object with a radial gradient shader
//     final Paint paint = Paint()
//       ..shader = RadialGradient(
//         colors: [Colors.blue, Colors.green],
//         stops: [0.0, 1.0],
//         center: Alignment.center,
//       ).createShader(Rect.fromCircle(
//           center: size.center(offset), radius: size.shortestSide / 2));

//     // Step 3.2: Create a rectangle that covers the entire RenderBox area
//     final rect = Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);

//     // Step 3.3: Draw an arc using the custom progress value
//     //           starting from the top (-pi / 2) and spanning the percentage of the circle (progress * 2 * pi)
//     context.canvas.drawArc(rect, -pi / 2, progress * 2 * pi, true, paint);
//   }
// }
