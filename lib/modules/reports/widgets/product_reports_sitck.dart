import 'package:botecaria/modules/reports/widgets/overlay_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Stick extends StatefulHookConsumerWidget {
  const Stick({
    super.key,
    required this.value,
    required this.color,
    required this.info,
    required this.uniqueKey,
    required this.width,
  });

  final double value;
  final Color color;
  final String info;
  final LabeledGlobalKey uniqueKey;
  final double width;
  @override
  ConsumerState<Stick> createState() => StickState();
}

class StickState extends ConsumerState<Stick> with OverLayStateMixin {
  Offset currentOffset = Offset.zero;
  RenderBox? _initializedRenderBox;
  OverlayEntry? sticky;
  GlobalKey stickyKey = GlobalKey();

  @override
  void initState() {
    sticky?.remove();
    // sticky = OverlayEntry(
    //   builder: (context) => stickyBuilder(context),
    // );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (sticky != null) {
        Overlay.of(context).insert(sticky!);
      }
    });
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _initializedRenderBox = context.findRenderObject() as RenderBox?;
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    sticky?.remove();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    // if (_initializedRenderBox?.localToGlobal(Offset.zero) != null) {
    //   print(_initializedRenderBox);

    //   print(_initializedRenderBox?.localToGlobal(Offset.zero));
    // }
    return TapRegion(
      onTapInside: (_) {},
      onTapOutside: (_) => removeOverlay(),
      child: GestureDetector(
        onTapDown: (details) => _onTapDown(details, context),
        child: Container(
          height: widget.value,
          key: widget.uniqueKey,
          width: 100,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Widget stickyBuilder(BuildContext context) {
  //   final keyContext = widget.uniqueKey.currentContext;
  //   print("keyContext ===== $keyContext");
  //   if (keyContext != null) {
  //     // widget is visible
  //     final box = keyContext.findRenderObject() as RenderBox;
  //     final pos = box.localToGlobal(Offset.zero);
  //     return Positioned(
  //       top: pos.dy + box.size.height,
  //       left: 50.0,
  //       right: 50.0,
  //       height: box.size.height,
  //       child: Material(
  //         child: Container(
  //           width: 50,
  //           height: 50,
  //           alignment: Alignment.center,
  //           color: Colors.purple,
  //           child: const Text("^ Nah I think you're okay"),
  //         ),
  //       ),
  //     );
  //   }
  //   // return AnimatedBuilder(
  //   //   animation: controller,
  //   //   builder: (context, child) {

  //   //   },
  //   // );
  //   return Container();
  // }

  void _onTapDown(TapDownDetails details, BuildContext context) {
    late Offset offset;
    final width = MediaQuery.sizeOf(context).width;
    if (details.globalPosition > Offset(width - 60, 0)) {
      offset = details.globalPosition - const Offset(50, 0);
    } else {
      offset = details.globalPosition;
    }
    toggleOverlay(
      OverlayUI(
        info: widget.info,
        borderColor: widget.color,
      ),
      offset,
    );
  }
}

class OverlayUI extends StatefulWidget {
  const OverlayUI({
    super.key,
    required this.info,
    required this.borderColor,
  });

  final String info;
  final Color borderColor;
  @override
  State<OverlayUI> createState() => _OverlayUIState();
}

class _OverlayUIState extends State<OverlayUI> {
  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: widget.borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Text(widget.info,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.black)),
    );
  }
}
