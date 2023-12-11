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

    Widget _buildIcon(OrderItem event) {
      int index = itemList.indexOf(event); //<-- Get index of the event
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
            mapKey: event.photo_url,
            imagePath:
                'gs://appparcial-123.appspot.com/products/${event.photo_url}',
          ),
        ),
      );
    }

    Widget _buildFullItem(OrderItem event) {
      int index = itemList.indexOf(event);
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
        itemName: event.productName, //<-- data to be displayed
        quantity: event.quantity, //<-- data to be displayed
      );
    }

    print(itemList.length);

    return SingleChildScrollView(
      child: SizedBox(
        height: height * 0.35,
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

class ExpandedEventItem extends StatelessWidget {
  final double topMargin;
  final double leftMargin;
  final double height;
  final bool isVisible;
  final double borderRadius;
  final String itemName;
  final int quantity;

  const ExpandedEventItem({
    super.key,
    required this.topMargin,
    required this.height,
    required this.isVisible,
    required this.borderRadius,
    required this.itemName,
    required this.quantity,
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
            color: Colors.transparent,
          ),
          padding: EdgeInsets.only(left: height).add(const EdgeInsets.all(8)),
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
              itemName,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              quantity.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
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
              quantity.toString(),
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 16,
              ),
            )
          ],
        )
      ],
    );
  }
}
