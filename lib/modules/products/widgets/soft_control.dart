import 'package:botecaria/modules/products/model/products_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
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
    required this.padding,
  });

  final double radius;
  final double avatarSize;
  final Categories category;
  final double padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<dynamic> cacheCategoryPic = kIsWeb
        ? ref.watch(pictureCategoryListProvider)
        : ref.watch(pictureCategoriesListAndroidProvider);
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
            padding: EdgeInsets.all(padding),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: kIsWeb
                    ? cacheCategoryPic
                            .map(<RemotePicture>(e) => e.mapKey)
                            .contains(category.documentId)
                        ? cacheCategoryPic.firstWhere(
                            (element) => element.mapKey == category.documentId)
                        : const SizedBox()
                    : cacheCategoryPic
                            .map(<NetworkImage>(e) => e.url.split('/').last)
                            .contains('${category.documentId}.png')
                        ? Image(
                            image: CachedNetworkImageProvider(cacheCategoryPic
                                .firstWhere(<NetworkImage>(e) =>
                                    e.url.split('/').last ==
                                    '${category.documentId}.png')
                                .url))
                        : const SizedBox()),
          ),
        )
      ],
    );
  }
}
