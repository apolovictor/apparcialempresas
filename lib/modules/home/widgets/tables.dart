import 'package:apparcialempresas/modules/home/model/tables_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/colors.dart';

class NeumorphismTable extends HookConsumerWidget {
  const NeumorphismTable({
    super.key,
    required this.radius,
    required this.avatarSize,
    required this.table,
    required this.padding,
    this.total,
  });

  final double radius;
  final double avatarSize;
  final DashboardTables table;
  final double padding;
  final double? total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(avatarSize),
      ),
      child: Card(
        shape: const CircleBorder(),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              table.idTable.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            Text(
              total != null ? 'R\$ $total' : '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
