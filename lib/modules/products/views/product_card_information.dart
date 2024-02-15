import 'package:botecaria/modules/products/model/products_model.dart';
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
  final Price price;
  final double quantity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    getInformationByIcon(Icon icon) {
      switch (icon.icon) {
        case Icons.attach_money_rounded:
          return price.price.toStringAsFixed(2).toString();
        case Icons.local_fire_department:
          return quantity.toString();
        case Icons.star:
          return "4.7";
        default:
          "";
      }
    }

    return Center(
        child: Stack(
      children: [
        SizedBox(
          height: 75,
          width: 75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              icon.icon == Icons.attach_money_rounded
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon.icon,
                        ),
                        icon,
                        icon
                      ],
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
    ));
  }
}
