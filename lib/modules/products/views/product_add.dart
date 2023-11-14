import 'dart:ui';

import 'package:apparcialempresas/modules/products/views/categories_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';
import '../controller/products_notifier.dart';
import '../model/products_model.dart';
import '../widgets/register_button.dart';
import '../widgets/register_fields.dart';

class ProductAdd extends HookConsumerWidget {
  const ProductAdd({
    super.key,
    required this.width,
    required this.height,
    required this.constraints,
  });

  final double width;
  final double height;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isActiveProductRegister = ref.watch(isProductsOpenedProvider);
    final categories = ref.watch(categoriesNotifier).value;
    final TextEditingController productNameController = TextEditingController();

    AnimationController registerController =
        useAnimationController(duration: const Duration(milliseconds: 0));
    SequenceAnimation sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 35.0),
            curve: Curves.easeOut,
            from: const Duration(milliseconds: 450),
            to: const Duration(milliseconds: 650),
            tag: 'avatarSize')
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 25.0),
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
        .animate(registerController);

    final Animation<double> addProductAnimation = Tween(begin: .0, end: 1.0)
        .animate(CurvedAnimation(
            parent: getProductAddController(ref), curve: Curves.ease));

            
    useValueChanged(ref.watch(isProductsOpenedProvider), (_, __) async {
      registerController.forward();
    });

    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 375),
          width: isActiveProductRegister ? width * 0.3 : 0,
          height: isActiveProductRegister ? constraints.maxHeight : 0,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            gradient: LinearGradient(
              colors: [
                Colors.black45,
                Colors.black54,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, right: 18.0, top: 18.0, bottom: 48),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 375),
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          gradient: LinearGradient(
                              colors: [
                                Colors.grey[200]!.withOpacity(0.05),
                                Colors.white.withOpacity(0.7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                          border: Border.all(width: 2, color: Colors.white12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      // registerController
                                      //     .reverse();

                                      ref
                                          .read(
                                              isProductsOpenedProvider.notifier)
                                          .fetch(false);
                                    },
                                  ),
                                ),
                                const Text(
                                  "Cadastrar Produto",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 50),
                                categories != null
                                    ? SizedBox(
                                        width: width * 0.3,
                                        child: LayoutBuilder(
                                            builder: (context, constraints) {
                                          return ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minWidth: constraints.maxWidth,
                                              ),
                                              child: IntrinsicWidth(
                                                child: Container(
                                                    width: width * 0.3,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: AnimatedBuilder(
                                                          animation:
                                                              registerController,
                                                          builder:
                                                              (context,
                                                                      child) =>
                                                                  Wrap(
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    spacing: 10,
                                                                    children: [
                                                                      for (var i =
                                                                              0;
                                                                          i < categories.length;
                                                                          i++)
                                                                        AnimationLimiter(
                                                                          key: GlobalKey<AnimatedListState>(
                                                                              debugLabel: i.toString()),
                                                                          child: AnimationConfiguration.staggeredList(
                                                                              position: i,
                                                                              child: SlideAnimation(
                                                                                  horizontalOffset: width * 0.3,
                                                                                  child: FadeTransition(
                                                                                    opacity: registerController,
                                                                                    child: SizeTransition(
                                                                                      sizeFactor: registerController,
                                                                                      child: Column(
                                                                                        children: [
                                                                                          MaterialButton(
                                                                                            shape: CircleBorder(),
                                                                                            onPressed: () {
                                                                                              ref.read(selectedProductNotifier.notifier).setSelected(0);
                                                                                              ref.read(categoryNotifier.notifier).state = categories[i].documentId;
                                                                                              ref.read(filterNotifier.notifier).state = {
                                                                                                "category": ref.watch(categoryNotifier),
                                                                                                "status": ref.watch(statusNotifier),
                                                                                              };
                                                                                            },
                                                                                            child: CircleAvatar(
                                                                                                radius: sequenceAnimation['avatarSize'].value,
                                                                                                backgroundColor: Color(int.parse('${categories[i].color != null ? categories[i].color : 0xFFF4F4F6}')),
                                                                                                child: FutureBuilder<String>(
                                                                                                    future: downloadUrl(categories[i].icon),
                                                                                                    builder: (context, snapshot) {
                                                                                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                                        return const Center(
                                                                                                          child: CircularProgressIndicator(),
                                                                                                        );
                                                                                                      } else {
                                                                                                        if (snapshot.data != null) {
                                                                                                          return SvgPicture.network(
                                                                                                            snapshot.data.toString(),
                                                                                                            color: Colors.black,
                                                                                                            height: sequenceAnimation['iconSize'].value,
                                                                                                          );
                                                                                                        } else {
                                                                                                          return const SizedBox();
                                                                                                        }
                                                                                                      }
                                                                                                    })),
                                                                                          ),
                                                                                          const SizedBox(height: 15),
                                                                                          Text(
                                                                                            categories[i].name.toUpperCase(),
                                                                                            style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.white),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ))),
                                                                        )
                                                                    ],
                                                                  )),
                                                    )),
                                              ));
                                        }),
                                      )
                                    : SizedBox(),
                                SizedBox(height: 50),
                                registerFieldWidget(
                                    productNameController, "Nome", context),
                                SizedBox(height: 50),
                                registerFieldWidget(
                                    productNameController, "Preço", context),
                                SizedBox(height: 50),
                                registerFieldWidget(productNameController,
                                    "Quantidade", context),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            height: 80,
            width: isActiveProductRegister ? width * 0.3 : 0,
            child: RegisterButton(
                buttonName: "Cadastrar",
                animation: addProductAnimation,
                product: Product(
                    categories: "categories",
                    primaryColor: "primaryColor",
                    secondaryColor: "secondaryColor",
                    name: "name",
                    price: {},
                    quantity: "quantity",
                    status: 1)),
          ),
        ),
      ],
    );
  }
}
