import 'package:apparcialempresas/modules/products/model/products_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_list.notifier.dart';
import '../controller/products_notifier.dart';
import 'product_list.dart';

GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
final storage = FirebaseStorage.instance;

class ProductScreen extends HookConsumerWidget {
  const ProductScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool displayMobileLayout = MediaQuery.of(context).size.width < 600;
    double width = MediaQuery.of(context).size.width;
    int productSelected = ref.watch(selectedProductNotifier);
    final products = ref.watch(productsNotifier).value;

    Future<String> downloadUrl(icon) async {
      var downloadUrl =
          storage.ref("categories_icons").child(icon).getDownloadURL();

      return downloadUrl;
    }

    bool isActiveEdit = ref.watch(isActiveEditNotifier);
    bool isActiveProductRegister = ref.watch(isProductsOpenedProvider);

    final categories = ref.watch(categoriesNotifier).value;

    final Animation<double> containerScaleTweenAnimation =
        Tween(begin: .0, end: MediaQuery.of(context).size.width * 0.3).animate(
            CurvedAnimation(
                parent: getCategoriesController(ref), curve: Curves.ease));

    final Animation<double> containerAlignTweenAnimation =
        Tween(begin: 0.0, end: -1.0).animate(CurvedAnimation(
            parent: getCategoriesController(ref), curve: Curves.ease));

    final Animation<double> containerBorderRadiusAnimation =
        Tween(begin: 100.0, end: 15.0).animate(CurvedAnimation(
            parent: getCategoriesController(ref), curve: Curves.ease));

    AnimationController categoriesController =
        useAnimationController(duration: const Duration(milliseconds: 0));
    SequenceAnimation sequenceAnimation;

    sequenceAnimation = SequenceAnimationBuilder()
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 375),
                  width: isActiveEdit || isActiveProductRegister
                      ? width * 0.7
                      : width,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 0,
                        left: !displayMobileLayout
                            ? MediaQuery.of(context).size.width * 0.05
                            : 15,
                        right: !displayMobileLayout
                            ? MediaQuery.of(context).size.width * 0.05
                            : 15,
                        bottom: 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: !displayMobileLayout ? 5 : 2,
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Row(children: [
                                    Text(
                                      ' Categorias ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge,
                                    ),
                                  ]),
                                  const SizedBox(height: 20),
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: categories?.length != null
                                                  ? AnimatedBuilder(
                                                      key: _listKey,
                                                      animation:
                                                          categoriesController,
                                                      builder:
                                                          (context, child) =>
                                                              AnimationLimiter(
                                                        child: Row(
                                                          children: categories!
                                                              .map((category) =>
                                                                  AnimationConfiguration
                                                                      .staggeredList(
                                                                    position: categories.indexWhere((element) =>
                                                                        element
                                                                            .name ==
                                                                        category
                                                                            .name),
                                                                    child:
                                                                        SlideAnimation(
                                                                      horizontalOffset: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                50.0),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            CircleAvatar(
                                                                                radius: sequenceAnimation['avatarSize'].value,
                                                                                backgroundColor: Color(int.parse('${category.color != null ? category.color : 0xFFF4F4F6}')),
                                                                                child: FutureBuilder<String>(
                                                                                    future: downloadUrl(category.icon),
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
                                                                            const SizedBox(height: 15),
                                                                            Text(
                                                                              category.name.toUpperCase(),
                                                                              style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.grey[500]),
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
                                                  return Column(
                                                    children: [
                                                      MaterialButton(
                                                        shape: CircleBorder(),
                                                        onPressed: () {
                                                          // if (isActiveProductRegister ==
                                                          //     false) {
                                                          ref
                                                              .read(
                                                                  isCategoriesOpenedProvider
                                                                      .notifier)
                                                              .fetch(true);
                                                          // }
                                                        },
                                                        child: CircleAvatar(
                                                            radius: sequenceAnimation[
                                                                    'avatarSize']
                                                                .value,
                                                            backgroundColor:
                                                                Colors
                                                                    .grey[200],
                                                            child: Icon(
                                                              Icons.add,
                                                              size: sequenceAnimation[
                                                                      'iconSize']
                                                                  .value,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                      ),
                                                      const SizedBox(
                                                          height: 15),
                                                      Text("ADD",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyLarge!
                                                              .apply(
                                                                  color: Colors
                                                                          .grey[
                                                                      500])),
                                                    ],
                                                  );
                                                }),
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: !displayMobileLayout ? 0 : 10,
                          ),
                          Expanded(
                            flex: !displayMobileLayout ? 12 : 4,
                            child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            ' Meus Produtos',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge,
                                          ),
                                          Row(
                                            children: [
                                              FilterChip(
                                                onSelected: (value) {
                                                  if (isActiveEdit == true) {
                                                    ref
                                                        .read(
                                                            isActiveEditNotifier
                                                                .notifier)
                                                        .setIsActiveEdit(false);
                                                    Future.delayed(
                                                        Duration(
                                                            milliseconds: 400),
                                                        () {
                                                      ref
                                                          .read(
                                                              isProductsOpenedProvider
                                                                  .notifier)
                                                          .fetch(true);
                                                    });
                                                  } else {
                                                    ref
                                                        .read(
                                                            isProductsOpenedProvider
                                                                .notifier)
                                                        .fetch(true);
                                                  }
                                                },
                                                side: BorderSide(
                                                    color: Colors.transparent),
                                                backgroundColor:
                                                    Colors.grey[200],
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                label: Container(
                                                    child: Text(
                                                        "Adicionar Produto",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .apply(
                                                                color: Colors
                                                                    .black87))),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      ref.watch(productsNotifier).value != null
                                          ? ProductsList(
                                              products: ref
                                                  .watch(productsNotifier)
                                                  .value!)
                                          : SizedBox(),
                                    ])),
                          )
                        ]),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 375),
                  width: isActiveProductRegister ? width * 0.3 : 0,
                  height: isActiveProductRegister ? constraints.maxHeight : 0,
                  color: Colors.black12,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                            ),
                            onPressed: () {
                              ref
                                  .read(isProductsOpenedProvider.notifier)
                                  .fetch(false);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 375),
                  width:
                      (isActiveEdit && productSelected > -1) ? width * 0.3 : 0,
                  height: constraints.maxHeight,
                  color: (products != null && productSelected > -1)
                      ? Color(int.parse(products[productSelected].color))
                      : Colors.transparent,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment(-1.1, -1),
                                child: InkWell(
                                  onTap: () {
                                    ref
                                        .read(isActiveEditNotifier.notifier)
                                        .setIsActiveEdit(false);
                                  },
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: constraints.maxHeight,
                                child: AnimatedAlign(
                                  duration: const Duration(milliseconds: 375),
                                  alignment: Alignment(
                                      -1.2,
                                      constraints.maxWidth == width * 0.3
                                          ? 0
                                          : -1),
                                  child: Container(
                                    height: 75.0,
                                    width: 75.0,
                                    decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    child: InkWell(
                                      onTap: () {
                                        print(true);
                                      },
                                      child: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: AnimatedBuilder(
                animation: containerScaleTweenAnimation,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment(containerAlignTweenAnimation.value,
                        containerAlignTweenAnimation.value),
                    child: Container(
                      height: containerScaleTweenAnimation.value,
                      width: containerScaleTweenAnimation.value,
                      padding: const EdgeInsets.all(8.0),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(
                              containerBorderRadiusAnimation.value)),
                      child: child,
                    ),
                  );
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                          ),
                          onPressed: () {
                            ref
                                .read(isCategoriesOpenedProvider.notifier)
                                .fetch(false);
                          },
                        ),
                      ),
                      // Row(
                      //   children: [],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
