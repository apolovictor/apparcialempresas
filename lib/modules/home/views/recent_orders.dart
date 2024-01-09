import 'package:apparcialempresas/modules/home/model/orders_model.dart';
import 'package:cached_firestorage/lib.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../orders/controller/orders_notifier.dart';

class RecentOrders extends HookConsumerWidget {
  const RecentOrders({super.key, required this.recentOrders});

  final List<DashboardDetailOrders> recentOrders;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var i = 0; i < recentOrders.length; i++)
            Container(
              // margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    child: RemotePicture(
                      mapKey: recentOrders[i].productPhoto,
                      imagePath:
                          'gs://appparcial-123.appspot.com/products/${recentOrders[i].productPhoto}',
                    ),
                  ),
                  Text(
                    recentOrders[i].productName,
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(recentOrders[i].price),
                  MaterialButton(
                    onPressed: () {},
                    color: Colors.black87,
                    textColor: Colors.white,
                    child: const Text('Atendido'),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
