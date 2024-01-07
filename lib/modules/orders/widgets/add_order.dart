import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/orders_notifier.dart';

class AddOrdertButton extends HookConsumerWidget {
  AddOrdertButton({
    super.key,
    required this.buttonName,
  });

  final String buttonName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemList = ref.watch(itemListProvider);
    final idDocumentTable = ref.watch(tableIdDocumentNotifier);

    final Animation<double> animation = Tween(begin: .0, end: 1.0).animate(
        CurvedAnimation(
            parent: buttonProductAddController(ref), curve: Curves.ease));
    return
        // ScaleTransition(
        //   scale: animation,
        //   child:
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                backgroundColor: Colors.black87,
                minimumSize: const Size.fromHeight(60)),
            child: Text(
              buttonName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              if (itemList.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Adicione um item a lista!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 3,
                    webBgColor: '#151515',
                    textColor: Colors.white,
                    fontSize: 18.0);
                return;
              }
              ref
                  .read(registerOrderProvider)
                  .registerItemOrder(idDocumentTable, itemList);
              ref.read(itemListProvider.notifier).clearItemList();
              ref.read(currentOrderStateProvider.notifier).state =
                  OrderStateWidget.close;
              ref.read(isAddingItemProvider.notifier).toogle(false);
            }
            // ),
            );
  }
}
