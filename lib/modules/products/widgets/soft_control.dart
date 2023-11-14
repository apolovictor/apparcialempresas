import 'package:apparcialempresas/modules/products/model/products_model.dart';
import 'package:cached_firestorage/lib.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/colors.dart';
import '../controller/products_notifier.dart';

class CircularSoftButton extends HookConsumerWidget {
  const CircularSoftButton({
    super.key,
    required this.radius,
    required this.avatarSize,
    required this.category,
  });

  final double radius;
  final double avatarSize;
  final Categories category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(ref.watch(filterNotifier));
    return Stack(
      children: [
        Container(
          height: radius,
          width: radius,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(avatarSize),
              gradient: LinearGradient(colors: [
                Color(int.parse(category.secondaryColor!)),
                Color(int.parse(category.color!))
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadowColor,
                    offset: Offset(
                        ref.watch(filterNotifier)['category'].isNotEmpty
                            ? 1
                            : 4,
                        4),
                    blurRadius: 2),
                BoxShadow(
                    color: AppColors.lightShadowColor,
                    offset: Offset(
                        ref.watch(filterNotifier)['category'].isNotEmpty
                            ? -1
                            : -4,
                        -6),
                    blurRadius: 12),
              ]),
        ),
        Positioned.fill(
          top: 2,
          left: 2,
          right: 2,
          bottom: 2,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
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
