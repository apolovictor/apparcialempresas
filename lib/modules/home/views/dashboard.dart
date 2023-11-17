import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Dashboard extends HookConsumerWidget {
  const Dashboard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print(MediaQuery.of(context).size.width);
    return LayoutBuilder(builder: (context, constraints) {
      double height = constraints.maxHeight;
      double width = constraints.maxWidth;

      return Stack(
        children: [
          Align(
            alignment: Alignment(-1, -1),
            child: Container(
              color: Colors.black,
              height: height * 0.27,
              width: width * 0.42,
            ),
          ),
          Align(
            alignment: Alignment(0.2, -1),
            child: Container(
              color: Colors.black,
              height: height * 0.27,
              width: width * 0.275,
            ),
          ),
          Align(
            alignment: Alignment(1, -1),
            child: Container(
              color: Colors.black,
              height: height * 0.27,
              width: width * 0.275,
            ),
          ),
          Align(
            alignment: Alignment(-1, 1),
            child: Container(
              color: Colors.black,
              height: height * 0.70,
              width: width * 0.42,
            ),
          ),
          Align(
            alignment: Alignment(1, 1),
            child: Container(
              color: Colors.black,
              height: height * 0.70,
              width: width * 0.564,
            ),
          ),
        ],
      );
    });
  }
}
