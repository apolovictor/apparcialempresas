// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../controller/product_list.notifier.dart';
// import '../controller/products_notifier.dart';
// GlobalKey<AnimatedListState> _listKey2 = GlobalKey<AnimatedListState>();

// class ProductsList extends HookConsumerWidget {
//   const ProductsList({super.key});
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final products = ref.watch(productsNotifier).value;
//     double width = ref.watch(widthProductCardNotifier);
//     double opacity = ref.watch(opacityProductCardNotifier);
//      AnimationController categoriesController =
//         useAnimationController(duration: const Duration(milliseconds: 0));
//     return Expanded(
//                             child: Container(
//                               width: MediaQuery.of(context).size.width,
//                               child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     SingleChildScrollView(
//                                       scrollDirection: Axis.horizontal,
//                                       child: products?.length != null
//                                           ? AnimatedBuilder(
//                                               key: _listKey2,
//                                               animation: categoriesController,
//                                               builder: (context, child) =>
//                                                   AnimationLimiter(
//                                                 child: Row(
//                                                   children: products!
//                                                       .map((category) =>
//                                                           AnimationConfiguration
//                                                               .staggeredList(
//                                                             position: products
//                                                                 .indexWhere(
//                                                                     (element) =>
//                                                                         element
//                                                                             .name ==
//                                                                         category
//                                                                             .name),
//                                                             child:
//                                                                 SlideAnimation(
//                                                                     horizontalOffset:
//                                                                         MediaQuery.of(context)
//                                                                             .size
//                                                                             .width,
//                                                                     child: AnimatedBuilder(
//                                                                         animation: categoriesController,
//                                                                         builder: (context, child) {
//                                                                           return Padding(
//                                                                             padding:
//                                                                                 const EdgeInsets.only(right: 50.0),
//                                                                             child:
//                                                                                 Column(
//                                                                               children: [
//                                                                                 CircleAvatar(
//                                                                                     radius: sequenceAnimation['avatarSize'].value,
//                                                                                     backgroundColor: Color(int.parse('${category.color != null ? category.color : 0xFFF4F4F6}')),
//                                                                                     child: FutureBuilder<String>(
//                                                                                         future: downloadUrl(category.icon),
//                                                                                         builder: (context, snapshot) {
//                                                                                           // print("snapshot.data =========== ${snapshot.data}");
//                                                                                           if (snapshot.connectionState == ConnectionState.waiting) {
//                                                                                             return const Center(
//                                                                                               child: CircularProgressIndicator(),
//                                                                                             );
//                                                                                           } else {
//                                                                                             if (snapshot.data != null) {
//                                                                                               return SvgPicture.network(
//                                                                                                 snapshot.data.toString(),
//                                                                                                 color: Colors.black,
//                                                                                                 height: sequenceAnimation['iconSize'].value,
//                                                                                               );
//                                                                                             } else {
//                                                                                               return const SizedBox();
//                                                                                             }
//                                                                                           }
//                                                                                         })),
//                                                                                 const SizedBox(height: 25),
//                                                                                 Text(
//                                                                                   category.name.toUpperCase(),
//                                                                                   style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.grey[500]),
//                                                                                 ),
//                                                                               ],
//                                                                             ),
//                                                                           );
//                                                                         })),
//                                                           ))
//                                                       .toList(),
//                                                 ),
//                                               ),
//                                             )
//                                           : const SizedBox(),
//                                     ),
//                                     AnimatedBuilder(
//                                         animation: categoriesController,
//                                         builder: (context, child) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(
//                                                 top: 20.0),
//                                             child: Column(
//                                               children: [
//                                                 MaterialButton(
//                                                   shape: CircleBorder(),
//                                                   onPressed: () {
//                                                     ref
//                                                         .read(isOpenedProvider
//                                                             .notifier)
//                                                         .fetch(true);
//                                                   },
//                                                   child: CircleAvatar(
//                                                       radius: sequenceAnimation[
//                                                               'avatarSize']
//                                                           .value,
//                                                       backgroundColor:
//                                                           Colors.grey[200],
//                                                       child: Icon(
//                                                         Icons.add,
//                                                         size: sequenceAnimation[
//                                                                 'iconSize']
//                                                             .value,
//                                                         color: Colors.black,
//                                                       )),
//                                                 ),
//                                                 const SizedBox(height: 25),
//                                                 Text("ADD",
//                                                     style: Theme.of(context)
//                                                         .textTheme
//                                                         .bodyLarge!
//                                                         .apply(
//                                                             color: Colors
//                                                                 .grey[500])),
//                                               ],
//                                             ),
//                                           );
//                                         }),
//                                   ]),
//                             ),
//                           ),
    
    // Stack(
    //   children: [
    //     MouseRegion(
    //       onEnter: (value) {
    //         ref.read(widthProductCardNotifier.notifier).fetchWidth(160.0);
    //         Future.delayed(Duration(milliseconds: 175), () {
    //           ref.read(opacityProductCardNotifier.notifier).fetchOpacity(1.0);
    //         });
    //       },
    //       onExit: (value) {
    //         ref.read(widthProductCardNotifier.notifier).fetchWidth(0.0);
    //         Future.delayed(Duration(milliseconds: 175), () {
    //           ref.read(opacityProductCardNotifier.notifier).fetchOpacity(0.0);
    //         });
    //       },
    //       child: Center(
    //         child: AnimatedContainer(
    //           duration: Duration(milliseconds: 375),
    //           height: width == 0.0 ? 260.0 : 280.0,
    //           width: width == 0.0 ? 180.0 : 200.0,
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(30.0),
    //             child: Container(
    //               color: Colors.grey[300],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //     Align(
    //       alignment: Alignment(-0.115, 0.55),
    //       child: ClipRRect(
    //         borderRadius: BorderRadius.circular(20.0),
    //         child: BackdropFilter(
    //           filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
    //           child: AnimatedContainer(
    //             duration: Duration(milliseconds: 375),
    //             curve: Curves.easeOut,
    //             height: 150.0,
    //             width: width,
    //             padding: EdgeInsets.all(14.0),
    //             decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
    //             child: AnimatedOpacity(
    //               opacity: opacity,
    //               duration: Duration(milliseconds: 500),
    //               child: SingleChildScrollView(
    //                 child: Column(
    //                   children: [Text()],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     )
    //   ],
    // );
//   }
// }
