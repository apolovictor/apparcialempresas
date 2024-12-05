import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../products/controller/products_notifier.dart';
import '../../products/model/products_model.dart';
import '../controller/product_notifier.dart';
import '../widgets/categories_button.dart';

class CategoriesScroller extends HookConsumerWidget {
  const CategoriesScroller({super.key, required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesNotifier).value;

    AnimationController productController =
        useAnimationController(duration: const Duration(milliseconds: 0));
    SequenceAnimation sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 50.0),
            curve: Curves.easeOut,
            from: const Duration(milliseconds: 450),
            to: const Duration(milliseconds: 650),
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
        .animate(productController);

    productController.forward();

    return categories != null
        ? LayoutBuilder(builder: (context, constraints) {
            double width = constraints.maxWidth;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AnimatedBuilder(
                  animation: productController,
                  builder: (context, child) => Wrap(
                        alignment: WrapAlignment.start,
                        direction: Axis.horizontal,
                        spacing: 10,
                        children: [
                          ref.watch(categoryProductDashboardNotifier).isNotEmpty
                              ? Column(
                                  children: [
                                    MaterialButton(
                                      shape: const CircleBorder(),
                                      onPressed: () {
                                        ref
                                            .read(
                                                filteredProductDashboardProvider
                                                    .notifier)
                                            .filteredList(products, '');
                                        ref
                                            .read(
                                                categoryProductDashboardNotifier
                                                    .notifier)
                                            .clear();
                                      },
                                      child: CircleAvatar(
                                          radius: 35,
                                          backgroundColor: Colors.grey[200],
                                          child: Icon(
                                            Icons.close,
                                            size: sequenceAnimation['iconSize']
                                                .value,
                                            color: Colors.black,
                                          )),
                                    ),
                                    const SizedBox(height: 5),
                                    Text("TODAS",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .apply(
                                                color: Colors.grey[500],
                                                fontSizeFactor: 0.75)),
                                  ],
                                )
                              : const SizedBox(),
                          for (var i = 0; i < categories.length; i++)
                            AnimationLimiter(
                              key: GlobalKey<AnimatedListState>(
                                  debugLabel: i.toString()),
                              child: AnimationConfiguration.staggeredList(
                                  position: i,
                                  child: SlideAnimation(
                                      horizontalOffset: width,
                                      child: FadeTransition(
                                        opacity: productController,
                                        child: SizeTransition(
                                          sizeFactor: productController,
                                          child: Column(
                                            children: [
                                              MaterialButton(
                                                shape: const CircleBorder(),
                                                height: 50,
                                                onPressed: () {
                                                  ref
                                                      .read(
                                                          categoryProductDashboardNotifier
                                                              .notifier)
                                                      .fetchCategoryProduct(
                                                          categories[i]
                                                              .documentId);
                                                  ref
                                                      .read(
                                                          filterDashboardNotifier
                                                              .notifier)
                                                      .state = categories[
                                                          i]
                                                      .documentId;
                                                  ref
                                                      .read(
                                                          filteredProductDashboardProvider
                                                              .notifier)
                                                      .filteredList(
                                                          products,
                                                          categories[i]
                                                              .documentId);
                                                },
                                                child: DashboardSoftButton(
                                                  radius: sequenceAnimation[
                                                              'avatarSize']
                                                          .value +
                                                      20,
                                                  avatarSize: sequenceAnimation[
                                                              'iconSize']
                                                          .value +
                                                      10,
                                                  category: categories[i],
                                                  padding: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                categories[i]
                                                    .name
                                                    .toUpperCase(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .apply(
                                                        color: Colors.grey[500],
                                                        fontSizeFactor: 0.75),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ))),
                            ),
                        ],
                      )),
            );
          })
        : const SizedBox();
  }
}
