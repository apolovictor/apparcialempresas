import 'package:apparcialempresas/modules/home/model/orders_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/orders_notifier.dart';
import '../widgets/add_order_separator.dart';

class DetailTableBill extends HookConsumerWidget {
  const DetailTableBill({super.key, required this.height, required this.width});

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
                    generateItems() {}
                    return Column(
                      children: [
                        SizedBox(
                          height: height * 0.7,
                          width: width,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    for (DashboardDetailOrders item
                                        in snapshot.data!)
                                      Stack(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            padding: const EdgeInsets.all(8),
                                            width: double.infinity,
                                            height: (height * 0.7) / 5,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[500],
                                                borderRadius:
                                                    BorderRadius.circular(24),
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
                                                    item: item,
                                                  ),
                                                )
                                              ],
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
                              // FinishOrderTabletButton(
                              //   buttonName: 'Fechar Pedido',
                              //   listDetailOrders: snapshot.data!,
                              // ),
                            ],
                          ),
                        )
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                })));
  }
}

class ExpandedEventItem extends HookConsumerWidget {
  // final double leftMargin;
  final DashboardDetailOrders item;

  const ExpandedEventItem({
    super.key,
    // required this.leftMargin,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Text(title, style: TextStyle(fontSize: 16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.productName,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'R\$ ${item.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Início',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Text(
              '${item.createdAt.toDate()}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Atendido',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Text(
              '${item.finishedAt.toString().isNotEmpty ? item.finishedAt.toDate() : ''}',
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
