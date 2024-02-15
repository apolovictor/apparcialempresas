import 'package:botecaria/modules/home/model/orders_model.dart';
import 'package:cached_firestorage/lib.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                  FutureBuilder<String>(
                      future: ref
                          .read(recentOrdersDashboardProvider.notifier)
                          .getTableByOrderIdDocument(
                              recentOrders[i].orderDocument),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
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
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                )),
                              )
                            : const SizedBox();
                      }),
                  // Container(
                  //   height: 50,
                  //   width: 50,
                  //   child: RemotePicture(
                  //     mapKey: recentOrders[i].productPhoto,
                  //     imagePath:
                  //         'gs://appparcial-123.appspot.com/products/${recentOrders[i].productPhoto}',
                  //   ),
                  // ),
                  Text(
                    recentOrders[i].productName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'R\$ ${recentOrders[i].price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  MaterialButton(
                    onPressed: () {
                      ref
                          .read(recentOrdersDashboardProvider.notifier)
                          .updateRecentOrder(
                              recentOrders[i].id,
                              recentOrders[i].productDocument,
                              recentOrders[i].avgUnitPrice);

                      Fluttertoast.showToast(
                        msg:
                            "${recentOrders[i].productName} atendido com sucesso!",
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
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
