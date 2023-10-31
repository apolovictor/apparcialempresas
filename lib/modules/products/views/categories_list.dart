import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';
import '../controller/products_notifier.dart';

GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
final storage = FirebaseStorage.instance;

class CategoriesList extends HookConsumerWidget {
  const CategoriesList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesNotifier).value;
    final filter = ref.watch(filterNotifier);

    AnimationController categoriesController =
        useAnimationController(duration: const Duration(milliseconds: 0));
    SequenceAnimation sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 50.0),
            curve: Curves.easeOut,
            from: const Duration(milliseconds: 300),
            to: const Duration(milliseconds: 600),
            tag: 'avatarSize')
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 40.0),
            curve: Curves.easeOut,
            from: const Duration(milliseconds: 500),
            to: const Duration(milliseconds: 750),
            tag: 'iconSize')
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: 12.0),
            curve: Curves.easeOut,
            from: const Duration(milliseconds: 500),
            to: const Duration(milliseconds: 750),
            tag: 'fontSize')
        .animate(categoriesController);
    categoriesController.forward();

    Future<String> downloadUrl(icon) async {
      var downloadUrl =
          storage.ref("categories_icons").child(icon).getDownloadURL();

      return downloadUrl;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: categories?.length != null
              ? AnimatedBuilder(
                  key: _listKey,
                  animation: categoriesController,
                  builder: (context, child) => AnimationLimiter(
                    child: Row(
                      children: categories!
                          .map((category) =>
                              AnimationConfiguration.staggeredList(
                                position: categories.indexWhere(
                                    (element) => element.name == category.name),
                                child: SlideAnimation(
                                  horizontalOffset:
                                      MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 50.0),
                                    child: Column(
                                      children: [
                                        MaterialButton(
                                          shape: CircleBorder(),
                                          onPressed: () {
                                            ref
                                                .read(selectedProductNotifier
                                                    .notifier)
                                                .setSelected(0);
                                            ref
                                                .read(categoryNotifier.notifier)
                                                .state = category.documentId;
                                            ref
                                                .read(filterNotifier.notifier)
                                                .state = {
                                              "category":
                                                  ref.watch(categoryNotifier),
                                              "status":
                                                  ref.watch(statusNotifier),
                                            };
                                          },
                                          child: CircleAvatar(
                                              radius: sequenceAnimation[
                                                      'avatarSize']
                                                  .value,
                                              backgroundColor: Color(int.parse(
                                                  '${category.color != null ? category.color : 0xFFF4F4F6}')),
                                              child: FutureBuilder<String>(
                                                  future: downloadUrl(
                                                      category.icon),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    } else {
                                                      if (snapshot.data !=
                                                          null) {
                                                        return SvgPicture
                                                            .network(
                                                          snapshot.data
                                                              .toString(),
                                                          color: Colors.black,
                                                          height:
                                                              sequenceAnimation[
                                                                      'iconSize']
                                                                  .value,
                                                        );
                                                      } else {
                                                        return const SizedBox();
                                                      }
                                                    }
                                                  })),
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          category.name.toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .apply(color: Colors.grey[500]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                )
              : const SizedBox(),
        ),
        AnimatedBuilder(
            animation: categoriesController,
            builder: (context, child) {
              return Row(
                children: [
                  filter['category'].isNotEmpty
                      ? Column(
                          children: [
                            MaterialButton(
                              shape: CircleBorder(),
                              onPressed: () {
                                ref.read(categoryNotifier.notifier).state = "";
                                ref.read(filterNotifier.notifier).state = {
                                  "category": ref.watch(categoryNotifier),
                                  "status": ref.watch(statusNotifier)
                                };
                              },
                              child: CircleAvatar(
                                  radius: sequenceAnimation['avatarSize'].value,
                                  backgroundColor: Colors.grey[200],
                                  child: Icon(
                                    Icons.close,
                                    size: sequenceAnimation['iconSize'].value,
                                    color: Colors.black,
                                  )),
                            ),
                            const SizedBox(height: 15),
                            Text("TODAS",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .apply(color: Colors.grey[500])),
                          ],
                        )
                      : SizedBox(),
                  Column(
                    children: [
                      MaterialButton(
                        shape: CircleBorder(),
                        onPressed: () {
                          // if (isActiveProductRegister ==
                          //     false) {
                          ref
                              .read(isCategoriesOpenedProvider.notifier)
                              .fetch(true);
                          // }
                        },
                        child: CircleAvatar(
                            radius: sequenceAnimation['avatarSize'].value,
                            backgroundColor: Colors.grey[200],
                            child: Icon(
                              Icons.add,
                              size: sequenceAnimation['iconSize'].value,
                              color: Colors.black,
                            )),
                      ),
                      const SizedBox(height: 15),
                      Text("ADD",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .apply(color: Colors.grey[500])),
                    ],
                  ),
                ],
              );
            }),
      ]),
    );
  }
}
