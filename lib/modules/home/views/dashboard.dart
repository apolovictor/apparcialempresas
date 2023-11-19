import 'package:apparcialempresas/modules/home/views/overview.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'product.dart';

class Dashboard extends HookConsumerWidget {
  const Dashboard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      double height = constraints.maxHeight;
      double width = constraints.maxWidth;

      return Stack(
        children: [
          Align(
            alignment: const Alignment(-1, -1),
            child: Container(
              color: Colors.grey[100],
              height: height * 0.27,
              width: width * 0.42,
              child: const Overview(),
            ),
          ),
          Align(
            alignment: const Alignment(0.2, -1),
            child: Container(
              color: Colors.grey[100],
              height: height * 0.27,
              width: width * 0.275,
            ),
          ),
          Align(
            alignment: const Alignment(1, -1),
            child: Container(
              color: Colors.grey[100],
              height: height * 0.27,
              width: width * 0.275,
            ),
          ),
          Align(
            alignment: const Alignment(-1, 1),
            child: Container(
              color: Colors.grey[100],
              height: height * 0.70,
              width: width * 0.42,
              child: const DashboardProduct(),
            ),
          ),
          Align(
            alignment: const Alignment(1, 1),
            child: Container(
              color: Colors.grey[100],
              height: height * 0.70,
              width: width * 0.564,
            ),
          ),
        ],
      );
    });
  }
}
