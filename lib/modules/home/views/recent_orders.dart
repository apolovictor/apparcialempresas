import 'dart:async';

import 'package:botecaria/modules/home/model/orders_model.dart';
import 'package:botecaria/services/date_services.dart';
import 'package:cached_firestorage/lib.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../cache/model/products_cache_model.dart';
import '../../../cache/services.dart';
import '../../orders/controller/orders_notifier.dart';

class RecentOrders extends StatefulHookConsumerWidget {
  const RecentOrders({super.key, required this.recentOrders});

  final List<DashboardDetailOrders> recentOrders;

  @override
  ConsumerState<RecentOrders> createState() => RecentOrdersState();
}

class RecentOrdersState extends ConsumerState<RecentOrders> {
  @override
  Widget build(BuildContext context) {
    var cacheProducts = ProductInServices().getAllProduct();

    double widthValue = 0.0;

    print(
        "cacheProducts === ${cacheProducts.map((ProductInServiceModel e) => e.serviceStartedIn)}");
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var i = 0; i < widget.recentOrders.length; i++)
            Builder(builder: (context) {
              return LayoutBuilder(builder: (context, constraints) {
                DateTime startAt = cacheProducts.any(
                        (ProductInServiceModel e) =>
                            e.key == widget.recentOrders[i].id)
                    ? cacheProducts
                        .firstWhere((ProductInServiceModel e) =>
                            e.key == widget.recentOrders[i].id)
                        .serviceStartedIn
                    : timeStampToDate(widget.recentOrders[i].createdAt);
                int avgServiceTime = cacheProducts.any(
                        (ProductInServiceModel e) =>
                            e.key == widget.recentOrders[i].id)
                    ? cacheProducts
                        .firstWhere((ProductInServiceModel e) =>
                            e.key == widget.recentOrders[i].id)
                        .avgServiceTime
                    : widget.recentOrders[i].avgServiceTime;

                var now = DateTime.now();
                final difference = now.difference(startAt).inSeconds;
                // print(difference);
                // print("constraints.maxWidth == ${constraints.maxWidth}");
                return Container(
                    // margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      color: Colors.black12,
                      width: double.infinity,
                      child: PeriodicTimerWidget(
                          startAt: startAt,
                          currentTime: difference,
                          avgServiceTime: avgServiceTime,
                          width: constraints.maxWidth,
                          recentOrder: widget.recentOrders[i]),
                    ));

                // Container(
                //   height: 50,
                //   width: 50,
                //   child: RemotePicture(
                //     mapKey: recentOrders[i].productPhoto,
                //     imagePath:
                //         'gs://appparcial-123.appspot.com/products/${recentOrders[i].productPhoto}',
                //   ),
                // ),
              });
            }),
        ],
      ),
    );
  }
}

class PeriodicTimerWidget extends StatefulWidget {
  PeriodicTimerWidget({
    super.key,
    required this.startAt,
    required this.currentTime,
    required this.avgServiceTime,
    required this.width,
    required this.recentOrder,
  });

  final DateTime startAt;
  int currentTime;
  final int avgServiceTime;
  final double width;
  final DashboardDetailOrders recentOrder;

  @override
  State<PeriodicTimerWidget> createState() => _PeriodicTimerWidgetState();
}

class _PeriodicTimerWidgetState extends State<PeriodicTimerWidget> {
  Timer? _periodicTimer;
  @override
  void initState() {
    super.initState();
    const oneSecond = Duration(milliseconds: 500);
    _periodicTimer = Timer.periodic(oneSecond, (Timer timer) {
      setState(() {
        widget.currentTime++;
      });
    });
  }

  @override
  void dispose() {
    _periodicTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     "widget.currentTime == ${widget.currentTime / widget.avgServiceTime}");

    //!! activate the shake function in the container to obtain atention of the user
    if (widget.currentTime / widget.avgServiceTime >= 1) {
      setState(() {
        _periodicTimer?.cancel();
      });
    } else {
      setState(() {});
    }

    Color color = const Color(0xff1c2a7f);
    Color color2 = const Color(0xffffffff);
    Widget content() {
      return IgnorePointer(
        ignoring: false,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
                height: 75,
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    )),
                child: ContentWidget(
                    color: color2, recentOrder: widget.recentOrder)),
            ClipRect(
              clipper: RectangleClipper(
                offset:
                    (widget.currentTime / widget.avgServiceTime) * widget.width,
              ),
              child: Container(
                height: 75,
                decoration: BoxDecoration(
                    color: color2,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    )),
                child: ContentWidget(
                    color: color, recentOrder: widget.recentOrder),
              ),
            )
          ],
        ),
      );
    }

    return content();
  }
}

class ContentWidget extends HookConsumerWidget {
  ContentWidget({required this.recentOrder, required this.color});
  final Color color;
  final DashboardDetailOrders recentOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder<String>(
            future: ref
                .read(recentOrdersDashboardProvider.notifier)
                .getTableByOrderIdDocument(recentOrder.orderDocument),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }

              return snapshot.data != null
                  ? CircleAvatar(
                      maxRadius: 30,
                      backgroundColor: Colors.black87,
                      child: Center(
                          child: Text(
                        snapshot.data!,
                        style: TextStyle(fontSize: 18, color: color),
                      )),
                    )
                  : const SizedBox();
            }),
        Text(
          recentOrder.productName,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: color),
        ),
        Text(
          'R\$ ${recentOrder.price.toStringAsFixed(2)}',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: color),
        ),
        IgnorePointer(
          ignoring: false,
          child: MaterialButton(
            onPressed: () {
              ref
                  .read(recentOrdersDashboardProvider.notifier)
                  .updateRecentOrder(recentOrder.id,
                      recentOrder.productDocument, recentOrder.avgUnitPrice);

              Fluttertoast.showToast(
                msg: "${recentOrder.productName} atendido com sucesso!",
                webPosition: "center",
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 3,
                webBgColor: '#151515',
                textColor: Colors.white,
              );
            },
            color: Colors.black87,
            textColor: Colors.white,
            child: const Text('Atendido'),
          ),
        )
      ],
    );
  }
}

//

class RectangleClipper extends CustomClipper<Rect> {
  final double offset;
  RectangleClipper({required this.offset});

  @override
  Rect getClip(Size size) {
    Rect rect = Rect.fromLTRB(offset, 0.0, size.width, size.height);
    return rect;
  }

  @override
  bool shouldReclip(RectangleClipper oldClipper) => true;
}
