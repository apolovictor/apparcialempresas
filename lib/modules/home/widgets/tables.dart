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
  final String? total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(avatarSize),
      ),
      child: Card(
        shape: CircleBorder(),
        elevation: 5,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                table.idTable.toString(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Text(
                total ?? '',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class NeumorphismTable extends StatefulHookConsumerWidget {
//   const NeumorphismTable({super.key, required this.child});

//   final Widget child;

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _NeumorphismTableState();
// }

// class _NeumorphismTableState extends ConsumerState<NeumorphismTable> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // padding: const EdgeInsets.all(75),
//       height: 160,
//       width: 160,
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(75),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.grey[500]!,
//               blurRadius: 24,
//               offset: const Offset(6, 6),
//               spreadRadius: 1),
//           const BoxShadow(
//               color: Colors.white,
//               blurRadius: 24,
//               offset: Offset(-6, -6),
//               spreadRadius: 1),
//         ],
//       ),
//       child: widget.child,
//     );
//   }
// }
