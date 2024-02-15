import 'package:botecaria/modules/routes/widgets/top_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/routes_controller.dart';

class TopBar extends HookConsumerWidget {
  const TopBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FilterChip(
          label: const CircleAvatar(
            child: Icon(Icons.account_circle),
          ),
          onSelected: (value) {},
          side: const BorderSide(color: Colors.transparent),
          backgroundColor: Colors.transparent,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(10),
          // ),
        ),
      ],
    );
  }
}
