import 'package:apparcialempresas/modules/home/views/tables_active_list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/tables_notifier.dart';
import 'tables_list.dart';

class TablesDashboard extends HookConsumerWidget {
  const TablesDashboard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tables = ref.read(tablesNotifierProvider);

    print(tables.tableChangeNotifier.name);

    ref.watch(tables.tableChangeNotifier).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(err.toString())),
        data: (data) {
          if (data != null) {
            data.forEach((e) {
              print(e!.idTable);
            });
          }
        });

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
                    "Mesas",
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
                      color: Colors.grey[100],
                      child: TablesListActive(),
                    )),
                    Expanded(child: TablesList())
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
