import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../orders/controller/orders_notifier.dart';
import 'recent_orders.dart';

class DashboardOrderedList extends HookConsumerWidget {
  const DashboardOrderedList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentOrders = ref.watch(recentOrdersDashboardProvider).value;

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          height: double.infinity,
          child: Column(
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Pedidos Recentes",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20)),
                      child: recentOrders != null
                          ? RecentOrders(recentOrders: recentOrders)
                          : const SizedBox(),
                    )),
                    // const Expanded(child: TablesList())
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
