import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/orders_notifier.dart';

const double minHeight = 120;
const double iconStartSize = 44; //<-- add edge values
const double iconEndSize = 120; //<-- add edge values
const double iconStartMarginTop = 36; //<-- add edge values
const double iconEndMarginTop = 80; //<-- add edge values
const double iconsVerticalSpacing = 24; //<-- add edge values
const double iconsHorizontalSpacing = 16; //<-- add edge values

class AddOrderWidget extends HookConsumerWidget {
  AddOrderWidget(
      {super.key,
      required this.minHeight,
      required this.minWidth,
      required this.height});

  double minHeight;
  double minWidth;
  double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AnimationController _controller = ref.watch(animationItemsProvider);
    AnimationController _controller = useAnimationController(
      duration: const Duration(milliseconds: 600),
    );

    final isOpen = ref.watch(isOpenProvider);

    double maxHeight =
        MediaQuery.of(context).size.height; //<-- Get max height of the screen
    double lerp(double min, double max) => ref.watch(lerpProvider(
        MyParameter(min: min, max: max, value: _controller.value)));

    // lerpDouble(min, max,
    //     _controller.value)!; //<-- lerp any value based on the controller

    // double headerTopMargin = lerp(
    //     20, 20 + MediaQuery.of(context).padding.top); //<-- Add new property

    // double headerFontSize = lerp(14, 24); //<-- Add new property

    // double itemBorderRadius = lerp(8, 24); //<-- increase item border radius

    double verticalPadding = ref.watch(
        lerpProvider(MyParameter(min: 6, max: 32, value: _controller.value)));

    // lerp(6, 32);

    // double iconSize = lerp(iconStartSize, iconEndSize); //<-- increase icon size

    // double iconTopMargin(int index) => lerp(
    //     iconStartMarginTop,
    //     iconEndMarginTop * 2 +
    //         index *
    //             (iconsVerticalSpacing +
    //                 iconEndSize)); //<-- calculate top margin based on header margin, and size of all of icons above (from small to big)

    // double iconLeftMargin(int index) => lerp(
    //     index * (iconsHorizontalSpacing + iconStartSize),
    //     0); //<-- calculate left margin (from big to small)

    Widget spaceHeight = SizedBox(height: height * 0.05);

    // Widget _buildFullItem(Event event) {
    //   int index = events.indexOf(event);
    //   return ExpandedEventItem(
    //     topMargin: iconTopMargin(
    //         index), //<--provide margins and height same as for icon
    //     leftMargin: iconLeftMargin(index),
    //     height: iconSize,
    //     isVisible:
    //         _controller.status == AnimationStatus.completed, //<--set visibility
    //     borderRadius: itemBorderRadius, //<-- pass border radius
    //     title: event.title, //<-- data to be displayed
    //     date: event.date, //<-- data to be displayed
    //   );
    // }

    void _toggle() {
      // notifier.toogle(isOpen);
      // ref.read(isOpenProvider.notifier).toogle(isOpen);
      final bool isOpen = _controller.status == AnimationStatus.completed;
      _controller.fling(
          velocity:
              isOpen ? -2 : 2); //<-- ...snap the sheet in proper direction
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
      if (flingVelocity < 0.0) {
        _controller.fling(
            velocity:
                math.max(2.0, -flingVelocity)); //<-- either continue it upwards
      } else if (flingVelocity > 0.0) {
        _controller.fling(
            velocity:
                math.min(-2.0, -flingVelocity)); //<-- or continue it downwards
      } else {
        _controller.fling(
            velocity: _controller.value < 0.5
                ? -2.0
                : 2.0); //<-- or just continue to whichever edge is closer
      }
    }

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Positioned(
            height: lerp(minHeight, maxHeight),
            left: minWidth * 0.7,
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
                        horizontal: 18, vertical: verticalPadding),
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

                        Positioned(
                          top:
                              lerp(10, 20 + MediaQuery.of(context).padding.top),
                          right: 0,
                          child: LayoutBuilder(builder: (context, constraints) {
                            print(
                                " maxHeight =========== ${constraints.maxHeight}");
                            print(
                                " maxWidth =========== ${constraints.maxWidth}");
                            print(minWidth);
                            return SheetHeader(
                              //<-- Add a header with params
                              width: minWidth * 0.3,
                              height: height,
                              fontSize: lerp(14, 24),

                              isVisible: _controller.status ==
                                  AnimationStatus.completed,
                              // _controller.status == AnimationStatus.completed,
                            );
                          }),
                        ),
                        _controller.status == AnimationStatus.completed
                            ? spaceHeight
                            : const SizedBox(),

                        Positioned(
                          top: lerp(0, height * 0.1),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 600),
                            opacity:
                                _controller.status == AnimationStatus.completed
                                    ? 1
                                    : 0,
                            child: Column(
                              children: [
                                const Row(
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
                                ),
                                _controller.status == AnimationStatus.completed
                                    ? spaceHeight
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: lerp(0, height * 0.2),
                          child: Container(
                            color: Colors.transparent,
                            height: lerp(minHeight, height * 0.45),
                            width: minWidth * 0.3,
                            child: DefaultTabController(
                              length: 3,
                              child: Column(
                                children: [
                                  _controller.status ==
                                          AnimationStatus.completed
                                      ? TabBar(
                                          isScrollable: true,
                                          labelColor: Colors.white,
                                          indicatorColor: Colors.white,
                                          labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                          unselectedLabelColor:
                                              Color(0xFFF00695c),
                                          tabs: <Widget>[
                                            Tab(
                                              text: 'Carrinho',
                                            ),
                                            Tab(
                                              text: 'Resumo',
                                            ),
                                            Tab(
                                              text: 'Detalhado',
                                            ),
                                          ],
                                          // : <Widget>[
                                          //     Tab(
                                          //       icon: Icon(Icons.add_circle),
                                          //     ),
                                          //     Tab(
                                          //       icon: Icon(Icons.check_circle),
                                          //     ),
                                          //     Tab(
                                          //       icon: Icon(Icons.cancel_rounded),
                                          //     ),
                                          //   ],
                                          indicator: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                Radius.circular(10),
                                              )),
                                              color: Color(0xFFF00695c)),
                                        )
                                      : const SizedBox(),

                                  // SizedBox(height: 150),
                                  Expanded(
                                    child: TabBarView(
                                      children: [
                                        OrderDetails(
                                          controller: _controller,
                                          height: height,
                                        ),
                                        // SizedBox(
                                        //   height: 100,
                                        //   width: 100,
                                        // ),
                                        SizedBox(
                                          height: 100,
                                          width: 100,
                                        ),
                                        SizedBox(
                                          height: 100,
                                          width: 100,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          );
        });
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
  final double height;
  final double width;
  final bool isVisible;

  const SheetHeader(
      {super.key,
      required this.fontSize,
      required this.isVisible,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Positioned(
                left: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Sr. Apolo",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // isVisible
                    //     ? const Text(
                    //         "Mesa",
                    //         style: TextStyle(
                    //           fontSize: 17,
                    //           color: Colors.white,
                    //         ),
                    //       )
                    //     : const SizedBox(),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                child: const CircleAvatar(
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
                ),
              )
            ],
          ),
        ),
      );
    });
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
  OrderDetails({super.key, required this.controller, required this.height});
  final AnimationController controller;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double lerp(double min, double max) => ref.watch(
        lerpProvider(MyParameter(min: min, max: max, value: controller.value)));

    double itemBorderRadius = lerp(8, 24); //<-- increase item border radius

    double headerTopMargin = lerp(
        20, 20 + MediaQuery.of(context).padding.top); //<-- Add new property

    Widget _buildIcon(Event event) {
      int index = events.indexOf(event); //<-- Get index of the event
      return Positioned(
        height: lerp(iconStartSize, iconEndSize), //<-- Specify icon's size
        width: lerp(iconStartSize, iconEndSize), //<-- Specify icon's size
        top: lerp(iconStartMarginTop,
            height * 0.2 * (index / 1.5)), //<-- Specify icon's top margin
        left: lerp(index * (iconsHorizontalSpacing + iconStartSize),
            0), //<-- Specify icon's left margin
        child: ClipRRect(
          borderRadius: BorderRadius.horizontal(
            left:
                Radius.circular(itemBorderRadius), //<-- Set the rounded corners
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

    return Stack(
      children: [
        for (Event event in events)
          _buildIcon(event), //<-- Add icons to the stack

        // Row(
        // children: buildIconsbuildItems,
        // )
      ],
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     Row(
      //       children: [
      //         Icon(
      //           Icons.shopping_cart,
      //           color: Colors.white,
      //         ),
      //         Text(
      //           'Conta',
      //           style: TextStyle(
      //             color: Colors.white,
      //           ),
      //         )
      //       ],
      //     ),
      //     Text(
      //       'Ordem ID: 236Wo0KaJduh6vw3OZW0',
      //       style: TextStyle(
      //         color: Colors.white,
      //       ),
      //     )
      //   ],
      // )
      // ],
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
