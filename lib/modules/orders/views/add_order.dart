import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddOrderWidget extends StatefulHookConsumerWidget {
  AddOrderWidget({super.key, required this.minHeight, required this.minWidth});

  double minHeight;
  double minWidth;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddOrderWidgetState();
}

const double iconStartSize = 44; //<-- add edge values
const double iconEndSize = 120; //<-- add edge values
const double iconStartMarginTop = 36; //<-- add edge values
const double iconEndMarginTop = 80; //<-- add edge values
const double iconsVerticalSpacing = 24; //<-- add edge values
const double iconsHorizontalSpacing = 16; //<-- add edge values

class _AddOrderWidgetState extends ConsumerState<AddOrderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; //<-- Create a controller

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      //<-- initialize a controller
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); //<-- and remember to dispose it!
    super.dispose();
  }

  double get maxHeight =>
      MediaQuery.of(context).size.height; //<-- Get max height of the screen

  double lerp(double min, double max) => lerpDouble(min, max,
      _controller.value)!; //<-- lerp any value based on the controller

  double get headerTopMargin =>
      lerp(20, 20 + MediaQuery.of(context).padding.top); //<-- Add new property

  double get headerFontSize => lerp(14, 24); //<-- Add new property

  double get itemBorderRadius => lerp(8, 24); //<-- increase item border radius

  double get verticalPadding => lerp(6, 32);

  double get iconSize =>
      lerp(iconStartSize, iconEndSize); //<-- increase icon size

  double iconTopMargin(int index) => lerp(
      iconStartMarginTop,
      iconEndMarginTop +
          index *
              (iconsVerticalSpacing +
                  iconEndSize)); //<-- calculate top margin based on header margin, and size of all of icons above (from small to big)

  double iconLeftMargin(int index) => lerp(
      index * (iconsHorizontalSpacing + iconStartSize),
      0); //<-- calculate left margin (from big to small)

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Positioned(
            height: lerp(widget.minHeight, maxHeight),
            left: widget.minWidth * 0.7,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _toggle,
              onVerticalDragUpdate:
                  _handleDragUpdate, //<-- Add verticalDragUpdate callback
              onVerticalDragEnd: _handleDragEnd,
              child: ClipPath(
                clipper: ZigZagClipper(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 32, vertical: verticalPadding),
                  height: 600,
                  width: 500,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    //<-- Add a stack
                    children: <Widget>[
                      // MenuButton(), //<-- With a menu button

                      SheetHeader(
                        //<-- Add a header with params
                        fontSize: headerFontSize,
                        topMargin: headerTopMargin,
                        minWidth: widget.minWidth,
                        isVisible:
                            _controller.status == AnimationStatus.completed,
                      ),
                      for (Event event in events)
                        _buildIcon(event), //<-- Add icons to the stack
                      for (Event event in events)
                        _buildFullItem(event), //<-- Add icons to the stack

                      AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity:
                              _controller.status == AnimationStatus.completed
                                  ? 1
                                  : 0,
                          child: const Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.shopping_cart,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        'Conta',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    'Ordem ID: 236Wo0KaJduh6vw3OZW0',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              )
                            ],
                          )),
                      // OrderDetails(
                      //   isVisible:
                      //       _controller.status == AnimationStatus.completed,
                      //   topMargin: headerTopMargin
                      //   //  _buildFullItem( events), //<-- Add FullItems
                      //   ,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildIcon(Event event) {
    int index = events.indexOf(event); //<-- Get index of the event
    return Positioned(
      height: iconSize, //<-- Specify icon's size
      width: iconSize, //<-- Specify icon's size
      top: iconTopMargin(index), //<-- Specify icon's top margin
      left: iconLeftMargin(index), //<-- Specify icon's left margin
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(itemBorderRadius), //<-- Set the rounded corners
          right: Radius.circular(itemBorderRadius),
        ),
        child: Image.asset(
          'assets/${event.assetName}',
          fit: BoxFit.cover,
          alignment: Alignment(
              lerp(1, 0), 0), //<-- Play with alignment for extra style points
        ),
      ),
    );
  }

  Widget _buildFullItem(Event event) {
    int index = events.indexOf(event);
    return ExpandedEventItem(
      topMargin:
          iconTopMargin(index), //<--provide margins and height same as for icon
      leftMargin: iconLeftMargin(index),
      height: iconSize,
      isVisible:
          _controller.status == AnimationStatus.completed, //<--set visibility
      borderRadius: itemBorderRadius, //<-- pass border radius
      title: event.title, //<-- data to be displayed
      date: event.date, //<-- data to be displayed
    );
  }

  void _toggle() {
    final bool isOpen = _controller.status == AnimationStatus.completed;
    _controller.fling(
        velocity: isOpen ? -2 : 2); //<-- ...snap the sheet in proper direction
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -= details.primaryDelta! /
        maxHeight; //<-- Update the _controller.value by the movement done by user.
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy /
        maxHeight; //<-- calculate the velocity of the gesture
    if (flingVelocity < 0.0)
      _controller.fling(
          velocity:
              math.max(2.0, -flingVelocity)); //<-- either continue it upwards
    else if (flingVelocity > 0.0)
      _controller.fling(
          velocity:
              math.min(-2.0, -flingVelocity)); //<-- or continue it downwards
    else
      _controller.fling(
          velocity: _controller.value < 0.5
              ? -2.0
              : 2.0); //<-- or just continue to whichever edge is closer
  }
}

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      //<-- Align the icon to bottom right corner
      right: 0,
      bottom: 24,
      child: Icon(
        Icons.menu,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}

class SheetHeader extends StatelessWidget {
  final double fontSize;
  final double topMargin;
  final double minWidth;
  final bool isVisible;

  const SheetHeader(
      {super.key,
      required this.fontSize,
      required this.topMargin,
      required this.minWidth,
      required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sr. Apolo",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            isVisible
                ? const Text(
                    "Mesa",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        const CircleAvatar(
          maxRadius: 30,
          backgroundColor: Colors.black54,
          child: Center(
            child: Text(
              '1',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20),
            ),
          ),
        )
      ],
    );
  }
}

final List<Event> events = [
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('rodion-kutsaev.jpeg', 'Dawan District Guangdong Hong Kong', '4.28-31'),
];

class Event {
  final String assetName;
  final String title;
  final String date;

  Event(this.assetName, this.title, this.date);
}

class ExpandedEventItem extends StatelessWidget {
  final double topMargin;
  final double leftMargin;
  final double height;
  final bool isVisible;
  final double borderRadius;
  final String title;
  final String date;

  const ExpandedEventItem({
    Key? key,
    required this.topMargin,
    required this.height,
    required this.isVisible,
    required this.borderRadius,
    required this.title,
    required this.date,
    required this.leftMargin,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      left: leftMargin,
      right: 0,
      height: height,
      child: AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(left: height).add(EdgeInsets.all(8)),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: <Widget>[
        // Text(title, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Row(
          children: <Widget>[
            Text(
              '1 ticket',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(width: 8),
            Text(
              date,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Spacer(),
        Row(
          children: <Widget>[
            Icon(
              Icons.place,
              color: Colors.grey.shade400,
              size: 16,
            ),
            Text(
              'Science Park 10 25A',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 13,
              ),
            )
          ],
        )
      ],
    );
  }
}

class OrderDetails extends HookConsumerWidget {
  OrderDetails({super.key, required this.isVisible, required this.topMargin});
  bool isVisible;
  double topMargin;
  // Widget widget;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(topMargin);
    return Positioned(
      top: topMargin * 4,
      child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isVisible ? 1 : 0,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      Text(
                        'Conta',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Text(
                    'Ordem ID: 236Wo0KaJduh6vw3OZW0',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}

class ZigZagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double factor = 8;
    Path path = Path();
    path.moveTo(factor, 0);
    path.arcToPoint(Offset(0, factor),
        radius: Radius.circular(8), clockwise: false);
    // path.quadraticBezierTo(factor, 0, 0, factor);

    path.lineTo(0, size.height);
    double x = 0;
    double y = size.height;
    double increment = size.width / 50;

    while (x < size.width) {
      if (x + increment > size.width) {
        x += size.width - x;
      } else {
        x += increment;
      }

      y = (y == size.height) ? size.height - increment : size.height;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, factor);
    path.arcToPoint(Offset(size.width - factor, 0),
        radius: Radius.circular(8), clockwise: false);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}

class BorderPainter extends CustomPainter {
  Color color;
  BorderPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    double factor = 8;
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    Path path = Path();
    path.moveTo(factor, 0);
    path.arcToPoint(Offset(0, factor),
        radius: Radius.circular(8), clockwise: false);
    // path.quadraticBezierTo(factor, 0, 0, factor);
    path.lineTo(0, size.height);
    double x = 0;
    double y = size.height;
    double increment = size.width / 50;

    while (x < size.width) {
      if (x + increment > size.width) {
        x += size.width - x;
      } else {
        x += increment;
      }

      y = (y == size.height) ? size.height - increment : size.height;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, factor);
    path.arcToPoint(Offset(size.width - factor, 0),
        radius: Radius.circular(8), clockwise: false);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
