import 'package:apparcialempresas/modules/products/model/products_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/colors.dart';
import '../controller/product_register.dart';
import '../controller/products_notifier.dart';

class RegisterCircularSoftButton extends HookConsumerWidget {
  const RegisterCircularSoftButton({
    super.key,
    required this.radius,
    required this.avatarSize,
    required this.category,
    required this.padding,
    // required this.color,
  });

  final double radius;
  final double avatarSize;
  final Categories category;
  final double padding;
  // final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print(ref.watch(filterNotifier));

    return Stack(
      children: [
        Container(
          height: radius,
          width: radius,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(avatarSize),
            color: ref.watch(categoryProductNotifier).isNotEmpty &&
                    ref.watch(categoryProductNotifier) == category.documentId
                ? Color(int.parse(category.secondaryColor!))
                : Colors.grey,

            boxShadow: const [
              BoxShadow(
                  color: AppColors.shadowGreyColor,
                  offset: Offset(4, 4),
                  blurRadius: 2),
              BoxShadow(
                  color: Colors.white, offset: Offset(-4, -4), blurRadius: 2)
            ],
            // boxShadow: [
            //   BoxShadow(
            //       color: AppColors.shadowColor,
            //       offset: Offset(
            //           ref.watch(filterNotifier)['category'].isNotEmpty
            //               ? 1
            //               : 4,
            //           4),
            //       blurRadius: 2),
            //   BoxShadow(
            //       color: AppColors.lightShadowColor,
            //       offset: Offset(
            //           ref.watch(filterNotifier)['category'].isNotEmpty
            //               ? -1
            //               : -4,
            //           -6),
            //       blurRadius: 12),
            // ],
          ),
        ),
        Positioned.fill(
          top: 2,
          left: 2,
          right: 2,
          bottom: 2,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: ref
                        .watch(pictureCategoriesListProvider)
                        .map((e) => e.mapKey)
                        .contains(category.documentId)
                    ? ref.watch(pictureCategoriesListProvider).firstWhere(
                        (element) => element.mapKey == category.documentId)
                    : SizedBox()),
          ),
        )
      ],
    );
  }
}
