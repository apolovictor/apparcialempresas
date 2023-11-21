import 'package:apparcialempresas/modules/products/model/products_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/colors.dart';
import '../controller/product_notifier.dart';

class DashboardSoftButton extends HookConsumerWidget {
  const DashboardSoftButton({
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
    return Stack(
      children: [
        Container(
          height: radius,
          width: radius,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(avatarSize),
            color: ref.watch(categoryProductDashboardNotifier).isNotEmpty &&
                    ref.watch(categoryProductDashboardNotifier) ==
                        category.documentId
                ? Color(int.parse(category.secondaryColor!))
                : AppColors.lightShadowColor,
            boxShadow: const [
              BoxShadow(
                  color: AppColors.shadowGreyColor,
                  offset: Offset(4, 4),
                  blurRadius: 2),
              BoxShadow(
                  color: Colors.white, offset: Offset(-4, -4), blurRadius: 2)
            ],
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
                    : const SizedBox()),
          ),
        )
      ],
    );
  }
}
