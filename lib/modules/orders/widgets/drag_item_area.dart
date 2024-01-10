import 'package:cached_firestorage/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../home/controller/product_notifier.dart';
import '../controller/orders_notifier.dart';
import '../model/order_model.dart';
import '../views/add_order.dart';

class DragItemArea extends HookConsumerWidget {
  const DragItemArea({
    super.key,
    required this.width,
    required this.height,
    required this.controller,
  });
  final Animation<double> controller;

  final double width;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemList = ref.watch(itemListProvider);

    double lerp(double min, double max) => ref.watch(
        lerpProvider(MyParameter(min: min, max: max, value: controller.value)));

    double itemBorderRadius = lerp(8, 24); //<-- increase item border radius

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 8.0,
        ),
        child: SizedBox(
            // height: height,
            width: width,
            child: Column(
              children: [
                for (OrderItem item in itemList)
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(8),
                        width: double.infinity,
                        height: iconEndSize + 20,
                        decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius:
                                BorderRadius.circular(itemBorderRadius),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black45,
                                  offset: Offset(4, 4),
                                  blurRadius: 2),
                            ]
                            // border: Border.all(width: 1, color: Colors.white),
                            ),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: lerp(iconStartSize,
                                      iconEndSize), //<-- Specify icon's size
                                  width: lerp(iconStartSize, iconEndSize),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(
                                          itemBorderRadius), //<-- Set the rounded corners
                                      right: Radius.circular(itemBorderRadius),
                                    ),
                                    child: RemotePicture(
                                      mapKey: item.photo_url,
                                      imagePath:
                                          'gs://appparcial-123.appspot.com/products/${item.photo_url}',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: ExpandedEventItem(
                                height: height,
                                itemName: item.productName,
                                price: double.parse(
                                    item.price.replaceAll(',', '.')),
                                quantity:
                                    item.quantity, //<-- data to be displayed
                                item: item,
                              ),
                            )
                          ],
                        ),
                      ),
                      // Positioned(
                      //     top: -10,
                      //     right: -5,
                      //     child: Container(
                      //       width: 50,
                      //       height: 50,
                      //       decoration: const BoxDecoration(
                      //           color: Colors.blueAccent,
                      //           shape: BoxShape.circle),
                      //     ))
                    ],
                  ),
              ],
            )),
      ),
    );
  }
}

class ExpandedEventItem extends HookConsumerWidget {
  // final double leftMargin;
  final double height;
  final String itemName;
  final int quantity;
  final double price;
  final OrderItem item;

  const ExpandedEventItem({
    super.key,
    required this.height,
    required this.itemName,
    required this.price,
    required this.quantity,
    // required this.leftMargin,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var itemsCart = ref.watch(itemListProvider);
    var productList = ref.watch(filteredProductDashboardProvider);

    var itemCart = itemsCart.firstWhere((e) => e == item);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Text(title, style: TextStyle(fontSize: 16)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              itemName,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                MaterialButton(
                  shape: const CircleBorder(),
                  onPressed: () {
                    if (item.quantity == 1) {
                      ref.read(itemListProvider.notifier).removeItem(item);
                    } else {
                      ref
                          .read(itemListProvider.notifier)
                          .updateItemQuantity('decrement', item);
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 18,
                        ),
                      )),
                ),
                Text(
                  '${quantity.toString()} / ${productList.firstWhere((e) => e.documentId == item.productIdDocument).quantity}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                MaterialButton(
                  shape: const CircleBorder(),
                  onPressed: () {
                    if (quantity <
                        productList
                            .firstWhere(
                                (e) => e.documentId == item.productIdDocument)
                            .quantity) {
                      ref
                          .read(itemListProvider.notifier)
                          .updateItemQuantity('increment', item);
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "Estoque do produto ${item.productName} indisponível! Adicione mais no módulo de produtos!",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 4,
                          webBgColor: '#151515',
                          textColor: Colors.white,
                          fontSize: 18.0);
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      )),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'R\$ ${(price * itemCart.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
