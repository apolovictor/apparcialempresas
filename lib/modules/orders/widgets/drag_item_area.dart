import 'package:cached_firestorage/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/orders_notifier.dart';
import '../model/order_model.dart';
import '../views/add_order.dart';

class DragItemArea extends HookConsumerWidget {
  const DragItemArea({
    super.key,
    required this.width,
    required this.height,
    required this.controller,
    required this.dragAreaController,
  });
  final Animation<double> controller;
  final Animation<double> dragAreaController;

  final double width;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemList = ref.watch(itemListProvider);
    double lerp(double min, double max) => ref.watch(
        lerpProvider(MyParameter(min: min, max: max, value: controller.value)));

    double itemBorderRadius = lerp(8, 24); //<-- increase item border radius

    Widget _buildIcon(OrderItem item) {
      int index = itemList.indexOf(item); //<-- Get index of the item
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
          child: RemotePicture(
            mapKey: item.photo_url,
            imagePath:
                'gs://appparcial-123.appspot.com/products/${item.photo_url}',
          ),
        ),
      );
    }

    Widget _buildFullItem(OrderItem item) {
      int index = itemList.indexOf(item);
      return ExpandedEventItem(
        topMargin: lerp(
            iconStartMarginTop,
            height *
                0.2 *
                (index / 1.8)), //<--provide margins and height same as for icon
        leftMargin: lerp(index * (iconsHorizontalSpacing + iconStartSize), 0),
        height: lerp(iconStartSize, iconEndSize + 15),
        isVisible:
            controller.status == AnimationStatus.completed, //<--set visibility
        borderRadius: itemBorderRadius, //<-- pass border radius
        itemName: item.productName, //<-- data to be displayed
        price: double.parse(item.price.replaceAll(',', '.')),
        quantity: item.quantity, //<-- data to be displayed
        item: item,
      );
    }

    return SingleChildScrollView(
      child: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            for (OrderItem event in itemList)
              _buildFullItem(event), //<-- Add icons to the stack
            for (OrderItem event in itemList)
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

class ExpandedEventItem extends HookConsumerWidget {
  final double topMargin;
  final double leftMargin;
  final double height;
  final bool isVisible;
  final double borderRadius;
  final String itemName;
  final int quantity;
  final double price;
  final OrderItem item;

  const ExpandedEventItem({
    super.key,
    required this.topMargin,
    required this.height,
    required this.isVisible,
    required this.borderRadius,
    required this.itemName,
    required this.price,
    required this.quantity,
    required this.leftMargin,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var itemsCart = ref.watch(itemListProvider);

    var itemCart = itemsCart.firstWhere((e) => e == item);

    print(itemCart.productName);

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
            color: Colors.transparent,
          ),
          padding: EdgeInsets.only(left: height).add(const EdgeInsets.all(8)),
          child: Column(
            children: <Widget>[
              // Text(title, style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      itemName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      MaterialButton(
                        shape: const CircleBorder(),
                        onPressed: () {
                          if (item.quantity == 1) {
                            print('here');
                            ref
                                .read(itemListProvider.notifier)
                                .removeItem(item);
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
                        quantity.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      MaterialButton(
                        shape: const CircleBorder(),
                        onPressed: () {
                          ref
                              .read(itemListProvider.notifier)
                              .updateItemQuantity('increment', item);
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
                        '${price * itemCart.quantity}',
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
          ),
        ),
      ),
    );
  }
}
