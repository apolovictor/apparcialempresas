import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/orders_notifier.dart';
import '../model/order_model.dart';
import '../widgets/register_button.dart';

// const double startHeight = 0;
const double iconStartSize = 44; //<-- add edge values
const double iconEndSize = 100; //<-- add edge values
const double iconStartMarginTop = 36; //<-- add edge values
const double iconEndMarginTop = 80; //<-- add edge values
const double iconsVerticalSpacing = 24; //<-- add edge values
const double iconsHorizontalSpacing = 16; //<-- add edge values

class AddOrderWidget extends HookConsumerWidget {
  AddOrderWidget({
    super.key,
    required this.minHeight,
    required this.minWidth,
    required this.height,
  });

  double minHeight;
  double minWidth;
  double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idDocument = ref.watch(tableIdDocumentNotifier);
    // AnimationController controller = ref.watch(animationItemsProvider);
    final isOpen = ref.watch(isOpenProvider);

    // final orderListState = ref.watch(orderStateListProvider);
    final currentOrderState = ref.watch(currentOrderStateProvider);

    double minHeight = currentOrderState == OrderStateWidget.onResume ||
            currentOrderState == OrderStateWidget.dragUpdate ||
            currentOrderState == OrderStateWidget.dragEnd
        ? 120
        : 0;
    print(currentOrderState);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(isOldOpenProvider.notifier).toogle(isOpen);
    // });

    // print(isDrag);

    final Animation<double> animation = Tween(begin: .0, end: 1.0).animate(
        CurvedAnimation(
            parent: orderWidgetController(ref), curve: Curves.ease));
    // final controller = orderWidgetController(ref, 0);

    double maxHeight =
        MediaQuery.of(context).size.height; //<-- Get max height of the screen
    double lerp(double min, double max) => ref.watch(
        lerpProvider(MyParameter(min: min, max: max, value: animation.value)));
    // print(animation.status);
    // lerpDouble(min, max,
    //     controller.value)!; //<-- lerp any value based on the controller

    // double headerTopMargin = lerp(
    //     20, 20 + MediaQuery.of(context).padding.top); //<-- Add new property

    // double headerFontSize = lerp(14, 24); //<-- Add new property

    // double itemBorderRadius = lerp(8, 24); //<-- increase item border radius

    double verticalPadding = ref.watch(
        lerpProvider(MyParameter(min: 6, max: 32, value: animation.value)));

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
    //         controller.status == AnimationStatus.completed, //<--set visibility
    //     borderRadius: itemBorderRadius, //<-- pass border radius
    //     title: event.title, //<-- data to be displayed
    //     date: event.date, //<-- data to be displayed
    //   );
    // }

    void _toggle() {
      if (currentOrderState == OrderStateWidget.open) {
        ref.read(currentOrderStateProvider.notifier).state =
            OrderStateWidget.onResume;
      } else {
        ref.read(currentOrderStateProvider.notifier).state =
            OrderStateWidget.open;
      }

      // ref.read(isOpenProvider.notifier).toogle(!isOpen);
      // notifier.toogle(isOpen);
      // ref.read(isOpenProvider.notifier).toogle(isOpen);
      // final bool isOpen = animation.status == AnimationStatus.completed;
      // animation.fling(
      //     velocity:
      //         isOpen ? -2 : 2); //<-- ...snap the sheet in proper direction
    }

    void _handleDragUpdate(DragUpdateDetails details) {
      ref.read(currentOrderStateProvider.notifier).state =
          OrderStateWidget.dragUpdate;
      ref.read(dragValueProvider.notifier).state -=
          details.primaryDelta! / maxHeight;
      // _toggle();
      // ref.read(isOldOpenProvider.notifier).toogle(true);
      // ref
      //     .read(dragUpdateProvider.notifier)
      //     .setDrag(details.primaryDelta! / maxHeight);
      // // ref.read(isOldOpenProvider.notifier).toogle(false);
      // print(details.primaryDelta! / maxHeight);
      // orderWidgetController(ref, details.primaryDelta! / maxHeight);
      // ref.read(provider)
      // controller.value -= details.primaryDelta! /
      //     maxHeight; //<-- Update the animation.value by the movement done by user.
    }

    void _handleDragEnd(DragEndDetails details) {
      ref.read(currentOrderStateProvider.notifier).state =
          OrderStateWidget.dragEnd;
      ref.read(flingVelocityProvider.notifier).state =
          details.velocity.pixelsPerSecond.dy / maxHeight;

      if (animation.status == AnimationStatus.completed) {
        ref.read(currentOrderStateProvider.notifier).state =
            OrderStateWidget.open;
      }

      // if (controller.isAnimating ||
      //     controller.status == AnimationStatus.completed) return;

      // final double flingVelocity = details.velocity.pixelsPerSecond.dy /
      //     maxHeight; //<-- calculate the velocity of the gesture
      // if (flingVelocity < 0.0) {
      //   controller.fling(
      //       velocity:
      //           math.max(2.0, -flingVelocity)); //<-- either continue it upwards
      // } else if (flingVelocity > 0.0) {
      //   controller.fling(
      //       velocity:
      //           math.min(-2.0, -flingVelocity)); //<-- or continue it downwards
      // } else {
      //   controller.fling(
      //       velocity: animation.value < 0.5
      //           ? -2.0
      //           : 2.0); //<-- or just continue to whichever edge is closer
      // }
    }

    final order =
        ref.read(ordersNotifierProvider).getOrderByIdDocument(idDocument);

    return idDocument.isNotEmpty
        ? AnimatedBuilder(
            animation: animation,
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
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('business')
                                .doc('bandiis')
                                .collection('orders')
                                .doc(idDocument)
                                // .where('idDocument', isEqualTo: idDocument)
                                .snapshots()
                                .map((doc) => ActiveOrder.fromDoc(doc)),
                            builder:
                                (context, AsyncSnapshot<ActiveOrder> snapshot) {
                              // if (!snapshot.hasData) {
                              //   return Center(child: CircularProgressIndicator());
                              // }
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.white,
                                ));
                              }

                              print(snapshot.data!.clientName);

                              return Stack(
                                //<-- Add a stack
                                children: <Widget>[
                                  Positioned(
                                    top: lerp(
                                        5,
                                        20 +
                                            MediaQuery.of(context).padding.top),
                                    right: 0,
                                    child: SheetHeader(
                                      //<-- Add a header with params
                                      width: minWidth * 0.3,
                                      height: height,
                                      fontSize: lerp(14, 24),

                                      isVisible: animation.status ==
                                          AnimationStatus.completed,
                                      clientName: snapshot.data?.clientName,
                                      idTable: snapshot.data!.idTable,
                                    ),
                                  ),
                                  animation.status == AnimationStatus.completed
                                      ? spaceHeight
                                      : const SizedBox(),
                                  Positioned(
                                    top: lerp(0, height * 0.09),
                                    right: 0,
                                    child: AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      opacity: animation.status ==
                                              AnimationStatus.completed
                                          ? 1
                                          : 0,
                                      child: SizedBox(
                                        // height: 50,
                                        width: minWidth * 0.3,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 40.0),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.list_alt_sharp,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      'Conta',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                child: Text(
                                                  'ID: 236Wo0KaJduh6vw3OZW0',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              animation.status ==
                                                      AnimationStatus.completed
                                                  ? spaceHeight
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: lerp(0, height * 0.15),
                                    child: Container(
                                      color: Colors.transparent,
                                      height: lerp(minHeight, height * 0.475),
                                      width: minWidth * 0.3,
                                      child: DefaultTabController(
                                        length: 3,
                                        child: Column(
                                          children: [
                                            currentOrderState ==
                                                    OrderStateWidget.open
                                                ? TabBar(
                                                    isScrollable: true,
                                                    labelColor: Colors.white,
                                                    dividerColor:
                                                        Colors.transparent,
                                                    padding: EdgeInsets.all(10),
                                                    labelStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                    unselectedLabelColor:
                                                        Colors.white,
                                                    tabs: <Widget>[
                                                      Tab(
                                                        text: 'Carrinho',
                                                        iconMargin:
                                                            EdgeInsets.all(25),
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
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                          Radius.circular(10),
                                                        )),
                                                        color: Colors.black54),
                                                  )
                                                : const SizedBox(),
                                            animation.status ==
                                                    AnimationStatus.completed
                                                ? const SizedBox(height: 50)
                                                : const SizedBox(),
                                            Expanded(
                                              child: TabBarView(
                                                children: [
                                                  OrderDetails(
                                                    controller: animation,
                                                    height: height,
                                                    width: minWidth * 0.3,
                                                  ),
                                                  const SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                  ),
                                                  const SizedBox(
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
                                  ),
                                  animation.status == AnimationStatus.completed
                                      ? Positioned(
                                          top: lerp(0, height * 0.65),
                                          child: SizedBox(
                                              width: minWidth * 0.3,
                                              child: const MySeparator(
                                                  color: Colors.white)))
                                      : const SizedBox(),
                                ],
                              );
                            }),
                      )),
                ),
              );
            })
        : SizedBox();
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

class SheetHeader extends HookConsumerWidget {
  final double fontSize;
  final double height;
  final double width;
  final bool isVisible;
  final String? clientName;
  final int idTable;

  const SheetHeader({
    super.key,
    required this.fontSize,
    required this.isVisible,
    required this.height,
    required this.width,
    this.clientName,
    required this.idTable,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    isVisible
                        ? MaterialButton(
                            shape: const CircleBorder(),
                            onPressed: () {
                              ref
                                  .read(currentOrderStateProvider.notifier)
                                  .state = OrderStateWidget.close;
                            },
                            child: Icon(
                              Icons.close,
                              // size: ,
                              color: Colors.white,
                            ),
                          )
                        : const SizedBox(),
                    Text(
                      clientName ?? "",
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
                child: CircleAvatar(
                  maxRadius: 30,
                  backgroundColor: Colors.black54,
                  child: Center(
                    child: Text(
                      idTable.toString(),
                      style: const TextStyle(
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

final List<Product> productsList = [];

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
        const SizedBox(height: 8),
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
            const SizedBox(width: 8),
            Text(
              date,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const Spacer(),
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
  OrderDetails(
      {super.key,
      required this.controller,
      required this.height,
      required this.width});
  final Animation<double> controller;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double lerp(double min, double max) => ref.watch(
        lerpProvider(MyParameter(min: min, max: max, value: controller.value)));

    double itemBorderRadius = lerp(8, 24); //<-- increase item border radius

    double headerTopMargin = lerp(
        20, 20 + MediaQuery.of(context).padding.top); //<-- Add new property

    Widget _buildIcon(Product event) {
      int index = productsList.indexOf(event); //<-- Get index of the event
      return Positioned(
        height: lerp(iconStartSize, iconEndSize), //<-- Specify icon's size
        width: lerp(iconStartSize, iconEndSize), //<-- Specify icon's size
        top: lerp(iconStartMarginTop,
            height * 0.2 * (index / 1.8)), //<-- Specify icon's top margin
        left: lerp(index * (iconsHorizontalSpacing + iconStartSize),
            0), //<-- Specify icon's left margin
        child: ClipRRect(
          borderRadius: BorderRadius.horizontal(
            left:
                Radius.circular(itemBorderRadius), //<-- Set the rounded corners
            right: Radius.circular(itemBorderRadius),
          ),
          child: Image.asset(
            'assets/imgs/${event.photo_url}',
            fit: BoxFit.cover,
            alignment: Alignment(
                lerp(1, 0), 0), //<-- Play with alignment for extra style points
          ),
        ),
      );
    }

    Widget _buildFullItem(Product event) {
      int index = productsList.indexOf(event);
      return ExpandedEventItem(
        topMargin: lerp(
            iconStartMarginTop,
            height *
                0.2 *
                (index / 1.8)), //<--provide margins and height same as for icon
        leftMargin: lerp(index * (iconsHorizontalSpacing + iconStartSize), 0),
        height: lerp(iconStartSize, iconEndSize),
        isVisible:
            controller.status == AnimationStatus.completed, //<--set visibility
        borderRadius: itemBorderRadius, //<-- pass border radius
        title: event.productName, //<-- data to be displayed
        date: event.price, //<-- data to be displayed
      );
    }

    // print(productsList.isEmpty);

    return SingleChildScrollView(
      physics: controller.status == AnimationStatus.completed
          ? BouncingScrollPhysics()
          : NeverScrollableScrollPhysics(),
      child: SizedBox(
        height: height * 0.45,
        width: width,
        child: productsList.isEmpty
            ? SizedBox(
                width: width,
                height: height * 0.45,
                child: Center(
                  child: AddProductButton(
                    buttonName: 'Adicionar Produtos',
                  ),
                ),
              )
            : Stack(
                children: [
                  for (Product event in productsList)
                    _buildFullItem(event), //<-- Add icons to the stack
                  for (Product event in productsList)
                    _buildIcon(event), //<-- Add icons to the stack

                  // Row(
                  // children: buildIconsbuildItems,
                  // )
                ],
              ),
      ),
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

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
