import 'dart:ui';

import 'package:cached_firestorage/lib.dart';
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
import 'categories_list.dart';
import 'product_list.dart';
import 'product_quick_edit.dart';

GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

class ProductScreen extends HookConsumerWidget {
  ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool displayMobileLayout = MediaQuery.of(context).size.width < 600;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int productSelected = ref.watch(selectedProductNotifier);
    final filter = ref.watch(filterNotifier);

    List<Product> filteredProducts = ref.watch(filteredProductListProvider);
    List<Product>? products = ref.watch(exampleProvider).value;
    final categories = ref.watch(categoriesNotifier).value;

    bool isActiveEdit = ref.watch(isActiveEditNotifier);
    bool isActiveProductRegister = ref.watch(isProductsOpenedProvider);

    

    // if (filter['category'].isNotEmpty) {
    //   print(filteredProducts.length);
    // } else {
    //   if (products != null) {
    //     print("products ========== ${products.length}");
    //   }
    // }
    final Animation<double> containerAddProductAnimation =
        Tween(begin: .0, end: width * 0.3).animate(CurvedAnimation(
            parent: getProductAddController(ref), curve: Curves.ease));
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

    final TextEditingController productNameController = TextEditingController();

    final Animation<double> containerScaleTweenAnimation =
        Tween(begin: .0, end: MediaQuery.of(context).size.width * 0.3).animate(
            CurvedAnimation(
                parent: getCategoriesController(ref), curve: Curves.ease));

    final Animation<double> animation = Tween(begin: .0, end: 1.0).animate(
        CurvedAnimation(
            parent: getQuickFieldsController(ref), curve: Curves.ease));
    final Animation<double> addProductAnimation = Tween(begin: .0, end: 1.0)
        .animate(CurvedAnimation(
            parent: getProductAddController(ref), curve: Curves.ease));

    final Animation<double> containerAlignTweenAnimation =
        Tween(begin: 0.0, end: -1.0).animate(CurvedAnimation(
            parent: getCategoriesController(ref), curve: Curves.ease));

    final Animation<double> containerBorderRadiusAnimation =
        Tween(begin: 100.0, end: 15.0).animate(CurvedAnimation(
            parent: getCategoriesController(ref), curve: Curves.ease));

    // getChip(Product tagTable, int index) {
    //   return Container(
    //     // width: 200,
    //     // height: 200,
    //     child: productSelected > -1
    //         ? ref.watch(pictureProductListProvider).firstWhere(
    //             (element) => element.mapKey == products![productSelected].logo)
    //         : const SizedBox(),
    //   );
    // }

    // generateTags() {
    //   return products!
    //       .asMap()
    //       .entries
    //       .map((tag) => getChip(tag.value, tag.key))
    //       .toList();
    // }

    // getProductAddController(ref).addStatusListener((status) {
    //   // print(status);
    //   // print(
    //   //     "containerAddProductAnimation ===== ${containerAddProductAnimation.value}");

    //   if (status == AnimationStatus.completed) {
    //     // if (containerAddProductAnimation.value == (width * 0.3)) {
    //     registerController.forward();
    //   }
    // });

    useValueChanged(ref.watch(isProductsOpenedProvider), (_, __) async {
      registerController.forward();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: products != null || filteredProducts.isNotEmpty
          ? LayoutBuilder(builder: (context, constraints) {
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
                                  flex: height < 806 ? 2 : 3,
                                  child: Container(
                                    color: Colors.black54,
                                    child: Center(
                                      child: Text(
                                        "TOP",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .apply(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: !displayMobileLayout && height > 805
                                      ? 5
                                      : height < 806 && !displayMobileLayout
                                          ? 6
                                          : 2,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Row(children: [
                                          Text(
                                            ' Categorias ',
                                            style: height < 806
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium
                                                : Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge,
                                          ),
                                        ]),
                                        const SizedBox(height: 20),
                                        const Expanded(child: CategoriesList()),
                                      ],
                                    ),
                                  ),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  ' Meus Produtos',
                                                  style: height < 800
                                                      ? Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .headlineLarge,
                                                ),
                                                Row(
                                                  children: [
                                                    FilterChip(
                                                      onSelected: (value) {
                                                        if (isActiveEdit ==
                                                            true) {
                                                          ref
                                                              .read(
                                                                  isActiveEditNotifier
                                                                      .notifier)
                                                              .setIsActiveEdit(
                                                                  false);
                                                          Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      400), () {
                                                            ref
                                                                .read(isProductsOpenedProvider
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
                                                      side: const BorderSide(
                                                          color: Colors
                                                              .transparent),
                                                      backgroundColor:
                                                          Colors.grey[200],
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      label: SizedBox(
                                                          child: Text(
                                                              "Adicionar Produto",
                                                              style: Theme.of(
                                                                      context)
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
                                            ProductsList(),
                                          ])),
                                )
                              ]),
                        ),
                      ),

                      /// Add Product Widget
                      Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 375),
                            width: isActiveProductRegister ? width * 0.3 : 0,
                            height: isActiveProductRegister
                                ? constraints.maxHeight
                                : 0,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
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
                                    left: 18.0,
                                    right: 18.0,
                                    top: 18.0,
                                    bottom: 48),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 20, sigmaY: 20),
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 375),
                                          height: height,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.3),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.grey[200]!
                                                      .withOpacity(0.05),
                                                  Colors.white.withOpacity(0.7),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter),
                                            border: Border.all(
                                                width: 2,
                                                color: Colors.white12),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
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
                                                                isProductsOpenedProvider
                                                                    .notifier)
                                                            .fetch(false);
                                                      },
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Cadastrar Produto",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  const SizedBox(height: 50),
                                                  categories != null
                                                      ? SizedBox(
                                                          width: width * 0.3,
                                                          child: LayoutBuilder(
                                                              builder: (context,
                                                                  constraints) {
                                                            return ConstrainedBox(
                                                                constraints:
                                                                    BoxConstraints(
                                                                  minWidth:
                                                                      constraints
                                                                          .maxWidth,
                                                                ),
                                                                child:
                                                                    IntrinsicWidth(
                                                                  child:
                                                                      Container(
                                                                          width: width *
                                                                              0.3,
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child: AnimatedBuilder(
                                                                                animation: registerController,
                                                                                builder: (context, child) => Wrap(
                                                                                      direction: Axis.horizontal,
                                                                                      spacing: 10,
                                                                                      children: [
                                                                                        for (var i = 0; i < categories.length; i++)
                                                                                          AnimationLimiter(
                                                                                            key: GlobalKey<AnimatedListState>(debugLabel: i.toString()),
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

                                                                  // AnimationLimiter(
                                                                  //     child: SizedBox(
                                                                  //         child: ListView.builder(
                                                                  //             scrollDirection: Axis.horizontal,
                                                                  //             itemCount: categories.length,
                                                                  //             itemBuilder: (BuildContext context, int index) {
                                                                  //               return AnimationConfiguration.staggeredList(
                                                                  //                 position: index,
                                                                  //                 duration: const Duration(milliseconds: 375),
                                                                  //                 child: SlideAnimation(
                                                                  //                   horizontalOffset: width * 0.3,
                                                                  //                   child: FadeInAnimation(
                                                                  //                     child: Column(
                                                                  //                       children: [
                                                                  //                         MaterialButton(
                                                                  //                           shape: CircleBorder(),
                                                                  //                           onPressed: () {
                                                                  //                             ref.read(selectedProductNotifier.notifier).setSelected(0);
                                                                  //                             ref.read(categoryNotifier.notifier).state = categories[index].documentId;
                                                                  //                             ref.read(filterNotifier.notifier).state = {
                                                                  //                               "category": ref.watch(categoryNotifier),
                                                                  //                               "status": ref.watch(statusNotifier),
                                                                  //                             };
                                                                  //                           },
                                                                  //                           child: CircleAvatar(
                                                                  //                               radius: sequenceAnimation['avatarSize'].value,
                                                                  //                               backgroundColor: Color(int.parse('${categories[index].color != null ? categories[index].color : 0xFFF4F4F6}')),
                                                                  //                               child: FutureBuilder<String>(
                                                                  //                                   future: downloadUrl(categories[index].icon),
                                                                  //                                   builder: (context, snapshot) {
                                                                  //                                     if (snapshot.connectionState == ConnectionState.waiting) {
                                                                  //                                       return const Center(
                                                                  //                                         child: CircularProgressIndicator(),
                                                                  //                                       );
                                                                  //                                     } else {
                                                                  //                                       if (snapshot.data != null) {
                                                                  //                                         return SvgPicture.network(
                                                                  //                                           snapshot.data.toString(),
                                                                  //                                           color: Colors.black,
                                                                  //                                           height: sequenceAnimation['iconSize'].value,
                                                                  //                                         );
                                                                  //                                       } else {
                                                                  //                                         return const SizedBox();
                                                                  //                                       }
                                                                  //                                     }
                                                                  //                                   })),
                                                                  //                         ),
                                                                  //                         const SizedBox(height: 15),
                                                                  //                         Text(
                                                                  //                           categories[index].name.toUpperCase(),
                                                                  //                           style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.grey[500]),
                                                                  //                         ),
                                                                  //                       ],
                                                                  //                     ),
                                                                  //                     // categories
                                                                  //                     //                                                           .map((category) => AnimationConfiguration.staggeredList(
                                                                  //                     //                                                                 position: categories.indexWhere((element) => element.name == category.name),
                                                                  //                     //                                                                 // duration: const Duration(milliseconds: 675),
                                                                  //                     //                                                                 child: SlideAnimation(
                                                                  //                     //                                                                   horizontalOffset: width,
                                                                  //                     //                                                                   child: Column(
                                                                  //                     //                                                                     children: [
                                                                  //                     //                                                                       MaterialButton(
                                                                  //                     //                                                                         shape: CircleBorder(),
                                                                  //                     //                                                                         onPressed: () {
                                                                  //                     //                                                                           ref.read(selectedProductNotifier.notifier).setSelected(0);
                                                                  //                     //                                                                           ref.read(categoryNotifier.notifier).state = category.documentId;
                                                                  //                     //                                                                           ref.read(filterNotifier.notifier).state = {
                                                                  //                     //                                                                             "category": ref.watch(categoryNotifier),
                                                                  //                     //                                                                             "status": ref.watch(statusNotifier),
                                                                  //                     //                                                                           };
                                                                  //                     //                                                                         },
                                                                  //                     //                                                                         child: CircleAvatar(
                                                                  //                     //                                                                             radius: sequenceAnimation['avatarSize'].value,
                                                                  //                     //                                                                             backgroundColor: Color(int.parse('${category.color != null ? category.color : 0xFFF4F4F6}')),
                                                                  //                     //                                                                             child: FutureBuilder<String>(
                                                                  //                     //                                                                                 future: downloadUrl(category.icon),
                                                                  //                     //                                                                                 builder: (context, snapshot) {
                                                                  //                     //                                                                                   if (snapshot.connectionState == ConnectionState.waiting) {
                                                                  //                     //                                                                                     return const Center(
                                                                  //                     //                                                                                       child: CircularProgressIndicator(),
                                                                  //                     //                                                                                     );
                                                                  //                     //                                                                                   } else {
                                                                  //                     //                                                                                     if (snapshot.data != null) {
                                                                  //                     //                                                                                       return SvgPicture.network(
                                                                  //                     //                                                                                         snapshot.data.toString(),
                                                                  //                     //                                                                                         color: Colors.black,
                                                                  //                     //                                                                                         height: sequenceAnimation['iconSize'].value,
                                                                  //                     //                                                                                       );
                                                                  //                     //                                                                                     } else {
                                                                  //                     //                                                                                       return const SizedBox();
                                                                  //                     //                                                                                     }
                                                                  //                     //                                                                                   }
                                                                  //                     //                                                                                 })),
                                                                  //                     //                                                                       ),
                                                                  //                     //                                                                       const SizedBox(height: 15),
                                                                  //                     //                                                                       Text(
                                                                  //                     //                                                                         category.name.toUpperCase(),
                                                                  //                     //                                                                         style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.grey[500]),
                                                                  //                     //                                                                       ),
                                                                  //                     //                                                                     ],
                                                                  //                     //                                                                   ),
                                                                  //                     //                                                                 ),
                                                                  //                     //                                                               ))
                                                                  //                     //                                                           .toList(),,
                                                                  //                   ),
                                                                  //                 ),
                                                                  //               );
                                                                  // })
                                                                ));
                                                          }),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(height: 50),
                                                  registerFieldWidget(
                                                      productNameController,
                                                      "Nome",
                                                      context),
                                                  SizedBox(height: 50),
                                                  registerFieldWidget(
                                                      productNameController,
                                                      "Preço",
                                                      context),
                                                  SizedBox(height: 50),
                                                  registerFieldWidget(
                                                      productNameController,
                                                      "Quantidade",
                                                      context),
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
                      ),

                      /// Edit Product Widget
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 375),
                        width: (isActiveEdit && productSelected > -1)
                            ? width * 0.3
                            : 0,
                        height: MediaQuery.of(context).size.height,
                        color: productSelected > -1
                            ? filter['category'].isNotEmpty &&
                                    filteredProducts.isNotEmpty
                                ? Color(int.parse(
                                    filteredProducts[productSelected]
                                        .primaryColor))
                                : products!.isNotEmpty
                                    ? Color(int.parse(
                                        products[productSelected].primaryColor))
                                    : Colors.transparent
                            : Colors.transparent,
                        child: LayoutBuilder(builder: (context, constraints) {
                          return ProducQuickEdit(
                              key: key,
                              height: height,
                              width: width,
                              animation: animation,
                              constraints: constraints);
                        }),
                      ),
                    ],
                  ),

                  /// Add Category Widget
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: AnimatedBuilder(
                      animation: containerScaleTweenAnimation,
                      builder: (context, child) {
                        return Align(
                          alignment: Alignment(
                              containerAlignTweenAnimation.value,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            })
          : SizedBox(),
    );
  }
}
