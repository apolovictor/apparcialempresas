import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';

class BasicInformations extends HookConsumerWidget {
  const BasicInformations({
    super.key,
    required this.index,
    required this.icon,
    required this.price,
    required this.quantity,
  });
  final int index;
  final Icon icon;
  final Map price;
  final int quantity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selected = ref.watch(selectedProductNotifier);

    getInformationByIcon(Icon icon) {
      switch (icon.icon) {
        case Icons.attach_money_rounded:
          return price['price'];
        case Icons.security_update_warning:
          return quantity;
        case Icons.star:
          return "4.8";
        default:
          "";
      }
    }

    return Center(
        child: SizedBox(
      child: Stack(
        children: [
          icon.icon == Icons.attach_money_rounded
              ? Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    color: Colors.black,
                    height: 1,
                    width: selected == index ? 0 : 75,
                    duration: const Duration(milliseconds: 300),
                  ),
                )
              : const SizedBox(),
          icon.icon == Icons.attach_money_rounded
              ? Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    height: selected == index ? 75 : 0,
                    width: 1,
                    color: Colors.black,
                    duration: const Duration(milliseconds: 300),
                  ))
              : const SizedBox(),
          icon.icon == Icons.attach_money_rounded
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: AnimatedContainer(
                    height: selected == index ? 75 : 0,
                    width: 1,
                    color: Colors.black,
                    duration: const Duration(milliseconds: 300),
                  ))
              : const SizedBox(),
          icon.icon == Icons.attach_money_rounded
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  child: AnimatedContainer(
                    height: 1,
                    width: selected == index ? 1 : 75,
                    color: Colors.black,
                    duration: const Duration(milliseconds: 300),
                  ))
              : const SizedBox(),
          SizedBox(
            height: 75,
            width: 75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                icon.icon == Icons.attach_money_rounded
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [icon, icon, icon],
                      )
                    : icon,
                Text(getInformationByIcon(icon) ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(color: Colors.black87))
              ],
            ),
          )
        ],
      ),
    ));
  }
}
