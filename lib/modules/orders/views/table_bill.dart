import 'package:apparcialempresas/modules/home/model/orders_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/orders_notifier.dart';
import '../widgets/add_order_separator.dart';
import '../widgets/finish_order_table.dart';

class TableBill extends HookConsumerWidget {
  const TableBill({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentIdTable = ref.watch(tableIdDocumentNotifier);
    final itemOrderList = ref
        .read(recentOrdersDashboardProvider.notifier)
        .getDetailOrdersByIdDocumentTable(documentIdTable);

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.black12,
        ),
        height: height,
        width: width,
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: StreamBuilder(
                stream: itemOrderList,
                builder: (ctx, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data != null) {
                    if (snapshot.data!.isNotEmpty) {
                      var newMap = groupBy(snapshot.data!.toList(),
                          (DashboardDetailOrders obj) => obj.productDocument);
                      getItem(List<DashboardDetailOrders> item) => Stack(
                            // getItem(List<DashboardDetailOrders> item) => Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(8),
                                width: double.infinity,
                                height: (height * 0.7) / 6,
                                decoration: BoxDecoration(
                                    color: Colors.grey[500],
                                    borderRadius: BorderRadius.circular(24),
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
                                    Expanded(
                                      child: ExpandedEventItem(
                                        height: height / 2,
                                        item: item,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );

                      groupItems() {
                        return newMap.entries.map((item) => getItem(item.value)
                            // return getItem(item);
                            // print()
                            // return getItem(item);
                            );
                      }

                      return Column(
                        children: [
                          SizedBox(
                            height: height * 0.7,
                            width: width,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Column(
                                    children: [...groupItems()],
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              width: width,
                              child: const MySeparator(color: Colors.white)),
                          Expanded(
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
                                      '${snapshot.data!.map((e) => e.price).reduce((a, b) => a + b)}',
                                      // total.toStringAsFixed(2).toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    )
                                  ],
                                ),
                                FinishOrderTabletButton(
                                  buttonName: 'Fechar Conta',
                                  listDetailOrders: snapshot.data!,
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  } else {
                    //!! Add image of empty cart list here
                    return SizedBox();
                  }
                })));
  }
}

class ExpandedEventItem extends HookConsumerWidget {
  // final double leftMargin;
  final double height;
  final List<DashboardDetailOrders> item;

  const ExpandedEventItem({
    super.key,
    required this.height,
    // required this.leftMargin,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(height);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Text(title, style: TextStyle(fontSize: 16)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              item.first.productName,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${item.first.price.toStringAsFixed(2)} x ${(item.length)} ',
              //   'R\$ ${(price * itemCart.quantity).toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Text(
              'R\$ ${(item.first.price * (item.length)).toStringAsFixed(2)}',
              //   'R\$ ${(price * itemCart.quantity).toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        )
      ],
    );
  }
}
