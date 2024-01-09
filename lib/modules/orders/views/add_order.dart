import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/orders_notifier.dart';
import '../model/order_model.dart';
import 'order_details.dart';

// const double startHeight = 0;
const double iconStartSize = 44; //<-- add edge values
const double iconEndSize = 80; //<-- add edge values
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

  final double minHeight;
  final double minWidth;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idDocument = ref.watch(tableIdDocumentNotifier);
    AnimationController controller = orderWidgetController(ref);

    // final orderListState = ref.watch(orderStateListProvider);
    final currentOrderState = ref.watch(currentOrderStateProvider);
    final double widthPadding = minWidth * 0.01;
    double minHeight = currentOrderState == OrderStateWidget.onResume ||
            currentOrderState == OrderStateWidget.dragUpdate ||
            currentOrderState == OrderStateWidget.dragEnd
        ? 120
        : 0;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(isOldOpenProvider.notifier).toogle(isOpen);
    // });

    final Animation<double> animation = Tween(begin: .0, end: 1.0).animate(
        CurvedAnimation(
            parent: orderWidgetController(ref), curve: Curves.ease));
    // final controller = orderWidgetController(ref, 0);

    double maxHeight =
        MediaQuery.of(context).size.height; //<-- Get max height of the screen
    double lerp(double min, double max) => ref.watch(
        lerpProvider(MyParameter(min: min, max: max, value: controller.value)));
    // print(animation.status);
    // lerpDouble(min, max,
    //     controller.value)!; //<-- lerp any value based on the controller

    // double headerTopMargin = lerp(
    //     20, 20 + MediaQuery.of(context).padding.top); //<-- Add new property

    // double headerFontSize = lerp(14, 24); //<-- Add new property

    // double itemBorderRadius = lerp(8, 24); //<-- increase item border radius

    double verticalPadding = ref.watch(
        lerpProvider(MyParameter(min: 0, max: 32, value: controller.value)));

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
      print('here');
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
      // controller.addListener(() {
      ref.read(dragValueProvider.notifier).state -=
          details.primaryDelta! / maxHeight;
      // });
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
      if (controller.status == AnimationStatus.completed) {
        ref.read(currentOrderStateProvider.notifier).state =
            OrderStateWidget.open;
      }
      ref.read(flingVelocityProvider.notifier).state =
          details.velocity.pixelsPerSecond.dy / maxHeight;

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

    // final order =
    //     ref.read(ordersNotifierProvider).getOrderByIdDocument(idDocument);

    return idDocument.isNotEmpty
        ? AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Positioned(
                height: lerp(minHeight, maxHeight),
                left: minWidth * 0.7,
                right: 0,
                bottom: 0,
                child: ClipPath(
                    clipper: ZigZagClipper(),
                    child: Container(
                      width: minWidth * 0.3,
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
                              return const Text('Something went wrong');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                color: Colors.white,
                              ));
                            }

                            return LayoutBuilder(
                                builder: (context, constraints) {
                              print('height == $height');
                              print(constraints.maxHeight);
                              print(constraints.maxWidth);
                              var myWidth = constraints.maxWidth;
                              var myHeight = constraints.maxHeight;
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: lerp(0, widthPadding),
                                    vertical: lerp(6, 0)),
                                height: myHeight,
                                width: myWidth,
                                child: Stack(
                                  //<-- Add a stack
                                  children: <Widget>[
                                    animation.status ==
                                            AnimationStatus.completed
                                        ? spaceHeight
                                        : const SizedBox(),
                                    Positioned(
                                        top: lerp(0, height * 0.12),
                                        right: 0,
                                        left: 0,
                                        child: SheetHeader2(
                                          isVisible: animation.status ==
                                              AnimationStatus.completed,
                                          height: 75,
                                          width: minWidth * 0.3,
                                        )),
                                    animation.status ==
                                            AnimationStatus.completed
                                        ? spaceHeight
                                        : const SizedBox(),
                                    Positioned(
                                      top: lerp(0, height * 0.2),
                                      child: SheetHeader3(
                                          isVisible: animation.status ==
                                              AnimationStatus.completed,
                                          height: height * 0.8,
                                          width: minWidth * 0.3,
                                          animation: animation,
                                          widthPadding: widthPadding),
                                      //  Container(
                                      //   color: Colors.transparent,
                                      //   height: lerp(minHeight, height),
                                      //   width: minWidth * 0.274,
                                      //   child: DefaultTabController(
                                      //     length: 3,
                                      //     child: Column(
                                      //       children: [
                                      //         currentOrderState ==
                                      //                 OrderStateWidget.open
                                      //             ? const TabBar(
                                      //                 isScrollable: true,
                                      //                 labelColor: Colors.white,
                                      //                 dividerColor:
                                      //                     Colors.transparent,
                                      //                 padding:
                                      //                     EdgeInsets.all(10),
                                      //                 labelStyle: TextStyle(
                                      //                   fontWeight:
                                      //                       FontWeight.bold,
                                      //                   fontSize: 15,
                                      //                 ),
                                      //                 unselectedLabelColor:
                                      //                     Colors.white,
                                      //                 tabs: <Widget>[
                                      //                   Tab(
                                      //                     text: 'Carrinho',
                                      //                     iconMargin:
                                      //                         EdgeInsets.all(
                                      //                             25),
                                      //                   ),
                                      //                   Tab(
                                      //                     text: 'Resumo',
                                      //                   ),
                                      //                   Tab(
                                      //                     text: 'Detalhado',
                                      //                   ),
                                      //                 ],
                                      //                 // : <Widget>[
                                      //                 //     Tab(
                                      //                 //       icon: Icon(Icons.add_circle),
                                      //                 //     ),
                                      //                 //     Tab(
                                      //                 //       icon: Icon(Icons.check_circle),
                                      //                 //     ),
                                      //                 //     Tab(
                                      //                 //       icon: Icon(Icons.cancel_rounded),
                                      //                 //     ),
                                      //                 //   ],
                                      //                 indicator:
                                      //                     ShapeDecoration(
                                      //                         shape:
                                      //                             RoundedRectangleBorder(
                                      //                                 borderRadius:
                                      //                                     BorderRadius
                                      //                                         .all(
                                      //                           Radius.circular(
                                      //                               10),
                                      //                         )),
                                      //                         color: Colors
                                      //                             .black54),
                                      //               )
                                      //             : const SizedBox(),
                                      //         animation.status ==
                                      //                 AnimationStatus.completed
                                      //             ? const SizedBox(height: 50)
                                      //             : const SizedBox(),
                                      //         Expanded(
                                      //           child: TabBarView(
                                      //             children: [
                                      //               OrderDetails(
                                      //                 controller: animation,
                                      //                 height: height * 0.5,
                                      //                 width: minWidth * 0.29,
                                      //               ),
                                      //               const SizedBox(
                                      //                 height: 100,
                                      //                 width: 100,
                                      //               ),
                                      //               const SizedBox(
                                      //                 height: 100,
                                      //                 width: 100,
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                    Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          color: Colors.transparent,
                                          width: lerp(
                                              minWidth * 0.3, minWidth * 0.3),
                                          height: lerp(minHeight, height * 0.2),
                                          child: GestureDetector(
                                            onTap: _toggle,
                                          ),
                                        )),
                                    Positioned(
                                      top: lerp(5, 5),
                                      right: 0,
                                      left: 0,
                                      child: SheetHeader(
                                          //<-- Add a header with params
                                          width: minWidth * 0.3,
                                          height: height,
                                          fontSize: lerp(14, 24),
                                          isVisible: animation.status ==
                                              AnimationStatus.completed,
                                          clientName: snapshot.data?.clientName,
                                          idTable: snapshot.data!.idTable),
                                    ),
                                  ],
                                ),
                              );
                            });
                          }),
                    )),
              );
            })
        : const SizedBox();
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
    final itemList = ref.watch(itemListProvider);

    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: height,
        width: width,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isVisible
                    ? TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          if (itemList.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: const EdgeInsets.all(10),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      // 1.3,
                                      height: 200,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white),
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 50, 20, 20),
                                      child: const Text(
                                          "Deseja descartar itens da mesa?",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black87),
                                          textAlign: TextAlign.center),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      right: 0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                              },
                                              child: const Text(
                                                'Não',
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                ref
                                                    .read(
                                                        currentOrderStateProvider
                                                            .notifier)
                                                    .state = OrderStateWidget.close;
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Itens removidos da mesa nº $idTable com sucesso!",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity: ToastGravity.TOP,
                                                    timeInSecForIosWeb: 3,
                                                    webBgColor: '#151515',
                                                    textColor: Colors.white,
                                                    fontSize: 18.0);

                                                ref
                                                    .read(itemListProvider
                                                        .notifier)
                                                    .clearItemList();

                                                ref
                                                    .read(isAddingItemProvider
                                                        .notifier)
                                                    .toogle(false);

                                                Navigator.pop(context, false);
                                              },
                                              child: const Text(
                                                'Sim',
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            ref.read(currentOrderStateProvider.notifier).state =
                                OrderStateWidget.close;
                            ref
                                .read(isAddingItemProvider.notifier)
                                .toogle(false);
                          }
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 32,
                        ),
                      )
                    : const SizedBox(),
                Row(
                  children: [
                    Text(
                      clientName ?? "",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
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
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class SheetHeader2 extends HookConsumerWidget {
  final double height;
  final double width;
  final bool isVisible;
  final String? accountName;

  const SheetHeader2({
    super.key,
    required this.isVisible,
    required this.height,
    required this.width,
    this.accountName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return isVisible
        ? SizedBox(
            height: height,
            width: width,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.list_alt_sharp,
                          color: Colors.white,
                        ),
                        Text(
                          'Conta',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ID: 236Wo0KaJduh6vw3OZW0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        // animation.status ==
                        //         AnimationStatus
                        //             .completed
                        //     ? spaceHeight
                        //     : const SizedBox(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        : SizedBox();
  }
}

class SheetHeader3 extends HookConsumerWidget {
  final double height;
  final double width;
  final bool isVisible;
  final String? accountName;
  final Animation<double> animation;
  final double widthPadding;

  const SheetHeader3({
    super.key,
    required this.isVisible,
    required this.height,
    required this.width,
    this.accountName,
    required this.animation,
    required this.widthPadding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentOrderState = ref.watch(currentOrderStateProvider);

    print(height);
    return isVisible
        ? Container(
            color: Colors.transparent,
            height: height,
            width: width - (widthPadding * 2),
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  currentOrderState == OrderStateWidget.open
                      ? const TabBar(
                          isScrollable: true,
                          labelColor: Colors.white,
                          dividerColor: Colors.transparent,
                          padding: EdgeInsets.all(10),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          unselectedLabelColor: Colors.white,
                          tabs: <Widget>[
                            Tab(
                              text: 'Carrinho',
                              iconMargin: EdgeInsets.all(25),
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
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                              color: Colors.black54),
                        )
                      : const SizedBox(),
                  animation.status == AnimationStatus.completed
                      ? const SizedBox(height: 50)
                      : const SizedBox(),
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraints) {
                      print('height1 === $height');
                      print('height ===== ${constraints.maxHeight}');
                      return TabBarView(
                        children: [
                          OrderDetails(
                            controller: animation,
                            height: constraints.maxHeight,
                            width: width,
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
                      );
                    }),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}

class ZigZagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double factor = 8;
    Path path = Path();
    path.moveTo(factor, 0);
    path.arcToPoint(Offset(0, factor),
        radius: const Radius.circular(8), clockwise: false);
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
        radius: const Radius.circular(8), clockwise: false);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}

// class BorderPainter extends CustomPainter {
//   Color color;
//   BorderPainter({required this.color});
//   @override
//   void paint(Canvas canvas, Size size) {
//     double factor = 8;
//     Paint paint = Paint()
//       ..color = color
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1;
//     Path path = Path();
//     path.moveTo(factor, 0);
//     path.arcToPoint(Offset(0, factor),
//         radius:const Radius.circular(8), clockwise: false);
//     // path.quadraticBezierTo(factor, 0, 0, factor);
//     path.lineTo(0, size.height);
//     double x = 0;
//     double y = size.height;
//     double increment = size.width / 50;

//     while (x < size.width) {
//       if (x + increment > size.width) {
//         x += size.width - x;
//       } else {
//         x += increment;
//       }

//       y = (y == size.height) ? size.height - increment : size.height;
//       path.lineTo(x, y);
//     }
//     path.lineTo(size.width, factor);
//     path.arcToPoint(Offset(size.width - factor, 0),
//         radius: Radius.circular(8), clockwise: false);
//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
