import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/orders_notifier.dart';
import '../widgets/register_button.dart';
import '../widgets/add_order_separator.dart';
import '../widgets/drag_item_area.dart';
import '../widgets/cart_button.dart';

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
    // print(ref.watch(currentOrderStateProvider) == OrderStateWidget.open);

    AnimationController dragAreaController = dragItemAreaController(ref);
    final Animation<double> animation = Tween(begin: .0, end: width).animate(
        CurvedAnimation(parent: dragAreaController, curve: Curves.ease));

    var itemList = ref.watch(itemListProvider);

    double total = 0;
    itemList.map((e) {
      return e.price * e.quantity;
    });
    for (var itemCart in itemList) {
      total = itemCart.price * itemCart.quantity + total;
      // total = total + total;
    }
    // final Animation<double> widgetAnimation = Tween(begin: .0, end: 1.0)
    //     .animate(CurvedAnimation(
    //         parent: orderWidgetController(ref), curve: Curves.ease));

    return SingleChildScrollView(
      child: Container(
        color: Colors.black12,
        height: height,
        width: width,
        child: AnimatedBuilder(
            animation: dragAreaController,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  controller.status == AnimationStatus.completed
                      ? SingleChildScrollView(
                          child: SizedBox(
                            height: height * 0.75,
                            width: width,
                            child: Stack(
                              children: [
                                // Expanded(
                                //   child:
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white70.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(24)),
                                  height: height * 0.75,
                                  width: animation.value,
                                ),
                                // ),
                                itemList.isEmpty
                                    ? const Center(
                                        child: AddCartButton(
                                          buttonName: 'Adicionar Produtos',
                                        ),
                                      )
                                    : dragAreaController.isCompleted
                                        ? DragItemArea(
                                            width: animation.value,
                                            height: height,
                                            controller: controller,
                                          )
                                        : const SizedBox(),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  controller.status == AnimationStatus.completed
                      ? SizedBox(
                          width: width,
                          child: const MySeparator(color: Colors.white))
                      : const SizedBox(),
                  dragAreaController.isCompleted
                      ? Container(
                          height: height * 0.19,
                          width: width,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  Text(
                                    total.toStringAsFixed(2).toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )
                                ],
                              ),
                              itemList.isNotEmpty
                                  ? SizedBox(
                                      width: animation.value,
                                      child: AddOrdertButton(
                                        buttonName: 'Fechar Pedido',
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              );
            }),
      ),
    );
  }
}
