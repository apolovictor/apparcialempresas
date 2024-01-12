import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../home/model/orders_model.dart';
import '../controller/orders_notifier.dart';

class FinishOrderTabletButton extends HookConsumerWidget {
  FinishOrderTabletButton({
    super.key,
    required this.buttonName,
    required this.listDetailOrders,
  });

  final String buttonName;
  final List<DashboardDetailOrders> listDetailOrders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemList = ref.watch(itemListProvider);
    final idDocumentTable = ref.watch(tableIdDocumentNotifier);

    final order = ref
        .read(recentOrdersDashboardProvider.notifier)
        .getOrderByIdDocumentTable(idDocumentTable);

    // if (order != null) {
    //   print(order.first);
    // }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ElevatedButton(
          onPressed: () {
            if (listDetailOrders.where((e) => e.status == 1).isNotEmpty) {
              Fluttertoast.showToast(
                  msg:
                      "Existem items em aberto. Feche-os antes de finalizar a conta!",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 3,
                  webBgColor: '#151515',
                  textColor: Colors.white,
                  fontSize: 18.0);
              return;
            } else {
              order.first.then((value) {
                print(value.idTable);
                ref
                    .read(recentOrdersDashboardProvider.notifier)
                    .finishOrder(value.idTable, listDetailOrders);
              });
              Fluttertoast.showToast(
                  msg: "Conta finalizada com sucesso!",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 4,
                  webBgColor: '#151515',
                  textColor: Colors.white,
                  fontSize: 18.0);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,

            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),

            minimumSize: Size(constraints.maxWidth, 60), // Make it responsive
            // padding: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.zero,
            textStyle: const TextStyle(fontSize: 14),
          ),
          child: Text(
            buttonName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
