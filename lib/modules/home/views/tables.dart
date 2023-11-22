import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TablesDashboard extends HookConsumerWidget {
  const TablesDashboard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  child: Container(
                color: Colors.grey[100],
              ))
            ],
          ),
        );
      }),
    );
  }
}
