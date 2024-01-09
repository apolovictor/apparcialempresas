import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/orders_notifier.dart';

class AddCartButton extends HookConsumerWidget {
  const AddCartButton({
    super.key,
    required this.buttonName,
  });

  final String buttonName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Animation<double> animation = Tween(begin: .0, end: 1.0).animate(
        CurvedAnimation(
            parent: buttonProductAddController(ref), curve: Curves.ease));
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
      child: ScaleTransition(
        scale: animation,
        child: ElevatedButton(
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
              ref.read(isAddingItemProvider.notifier).toogle(true);
            }),
      ),
    );
  }
}
