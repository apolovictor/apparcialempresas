import 'dart:ui';

import 'package:apparcialempresas/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../routes/controller/routes_controller.dart';
import '../controller/product_register.dart';
import '../controller/products_notifier.dart';
import '../services/services.dart';
import '../widgets/register_button.dart';
import '../widgets/register_fields.dart';
import '../widgets/register_soft_control.dart';

class ProductAdd extends HookConsumerWidget {
  const ProductAdd({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isActiveProductRegister = ref.watch(isProductsOpenedProvider);
    final categories = ref.watch(categoriesNotifier).value;
    final TextEditingController productNameController =
        ref.watch(productNameProvider);

    final TextEditingController productPriceController =
        ref.watch(productPriceProvider);
    final TextEditingController productQuantityController =
        ref.watch(productQuantityProvider);
    final imgConverted = ref.watch(imgConvertedProvider);

    productNameController.addListener(() {
      ref
          .read(productNameProvider.notifier)
          .fetchProductName(productNameController);
    });
    productPriceController.addListener(() {
      ref
          .read(productPriceProvider.notifier)
          .fetchProductPrice(productPriceController);
    });
    productQuantityController.addListener(() {
      ref
          .read(productQuantityProvider.notifier)
          .fetchProductQuantity(productQuantityController);
    });

    AnimationController registerController =
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
        .animate(registerController);

    final Animation<double> addProductAnimation = Tween(begin: .0, end: 1.0)
        .animate(CurvedAnimation(
            parent: getProductAddController(ref), curve: Curves.ease));

    useValueChanged(ref.watch(isProductsOpenedProvider), (_, __) async {
      registerController.forward();
    });

    Future getGalleryImage(
        double maxWidth, double maxHeight, WidgetRef ref) async {
      final ImagePicker picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: maxWidth,
          maxHeight: maxHeight);
      if (pickedFile != null) {
        ref.read(imgFileProvider.notifier).setImgFile(pickedFile);
        ref
            .read(imgConvertedProvider.notifier)
            .setImgFile(await convertXFileToMemoryImage(pickedFile));
      }
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 375),
          width: isActiveProductRegister ? width * 0.3 : 0,
          height: isActiveProductRegister ? height : 0,
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
                clipBehavior: Clip.none,
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
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          // registerController
                                          //     .reverse();

                                          ref
                                              .read(isProductsOpenedProvider
                                                  .notifier)
                                              .fetch(false);
                                        },
                                      ),
                                      const Center(
                                        child: Text(
                                          "Cadastrar Produto",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Container(
                                  height: isActiveProductRegister
                                      ? width * 0.3 - 75
                                      : 0,
                                  width: isActiveProductRegister
                                      ? width * 0.3 - 75
                                      : 0,
                                  decoration: BoxDecoration(
                                      // gradient: LinearGradient(
                                      //     colors: [Colors.white, Colors.grey],
                                      //     begin: Alignment.topLeft,
                                      //     end: Alignment.bottomRight),
                                      color: Colors.grey,
                                      borderRadius:
                                          BorderRadius.circular(width * 0.3),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: AppColors.shadowGreyColor,
                                            offset: Offset(4, 4),
                                            blurRadius: 2),
                                        BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(-4, -4),
                                            blurRadius: 2)
                                      ]),
                                  child: MaterialButton(
                                    shape: CircleBorder(),
                                    onPressed: () async {
                                      await getGalleryImage(
                                        200,
                                        200,
                                        ref,
                                      );
                                    },
                                    child: Center(
                                      child: imgConverted.bytes.isNotEmpty
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: imgConverted,
                                                      fit: BoxFit.fill)),
                                            )

                                          //  ClipRRect(
                                          //     clipBehavior: C,
                                          //     child: CircleAvatar(
                                          //         radius: width * 0.3 - 75,
                                          //         backgroundImage:
                                          //             imgConverted),
                                          //   )
                                          : Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: width * 0.3 / 4,
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                categories != null
                                    ? SizedBox(
                                        width: width * 0.3,
                                        child:
                                            // print(constraints.maxHeight);
                                            SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: AnimatedBuilder(
                                              animation: registerController,
                                              builder: (context, child) => Wrap(
                                                    direction: Axis.horizontal,
                                                    spacing: 10,
                                                    children: [
                                                      for (var i = 0;
                                                          i < categories.length;
                                                          i++)
                                                        AnimationLimiter(
                                                          key: GlobalKey<
                                                                  AnimatedListState>(
                                                              debugLabel:
                                                                  i.toString()),
                                                          child: AnimationConfiguration
                                                              .staggeredList(
                                                                  position: i,
                                                                  child:
                                                                      SlideAnimation(
                                                                          horizontalOffset: width *
                                                                              0.3,
                                                                          child:
                                                                              FadeTransition(
                                                                            opacity:
                                                                                registerController,
                                                                            child:
                                                                                SizeTransition(
                                                                              sizeFactor: registerController,
                                                                              child: Column(
                                                                                children: [
                                                                                  MaterialButton(
                                                                                    shape: CircleBorder(),
                                                                                    height: 100,
                                                                                    onPressed: () {
                                                                                      // print(categories[i].documentId);
                                                                                      ref.read(categoryProductNotifier.notifier).fetchCategoryProduct(categories[i].documentId);
                                                                                      // ref.read(selectedProductNotifier.notifier).setSelected(0);
                                                                                      // ref.read(categoryNotifier.notifier).state = categories[i].documentId;
                                                                                      // ref.read(filterNotifier.notifier).state = {
                                                                                      //   "category": ref.watch(categoryNotifier),
                                                                                      //   "status": ref.watch(statusNotifier),
                                                                                      // };
                                                                                    },
                                                                                    child: RegisterCircularSoftButton(
                                                                                      radius: sequenceAnimation['avatarSize'].value + 20,
                                                                                      avatarSize: sequenceAnimation['iconSize'].value + 10,
                                                                                      category: categories[i],
                                                                                      padding: 15,
                                                                                      // color: ,
                                                                                    ),
                                                                                    //  CircleAvatar(
                                                                                    //     radius: sequenceAnimation['avatarSize'].value,
                                                                                    //     backgroundColor: Color(int.parse('${categories[i].color != null ? categories[i].color : 0xFFF4F4F6}')),
                                                                                    //     child: FutureBuilder<String>(
                                                                                    //         future: downloadUrl(categories[i].icon),
                                                                                    //         builder: (context, snapshot) {
                                                                                    //           if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                    //             return const Center(
                                                                                    //               child: CircularProgressIndicator(),
                                                                                    //             );
                                                                                    //           } else {
                                                                                    //             if (snapshot.data != null) {
                                                                                    //               return SvgPicture.network(
                                                                                    //                 snapshot.data.toString(),
                                                                                    //                 color: Colors.black,
                                                                                    //                 height: sequenceAnimation['iconSize'].value,
                                                                                    //               );
                                                                                    //             } else {
                                                                                    //               return const SizedBox();
                                                                                    //             }
                                                                                    //           }
                                                                                    //         })),
                                                                                  ),
                                                                                  const SizedBox(height: 15),
                                                                                  Text(
                                                                                    categories[i].name.toUpperCase(),
                                                                                    style: Theme.of(context).textTheme.bodyLarge!.apply(
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ))),
                                                        )
                                                    ],
                                                  )),
                                        ),
                                      )
                                    : const SizedBox(),
                                const SizedBox(height: 50),
                                registerFieldWidget(
                                    productNameController, "Nome", context),
                                const SizedBox(height: 50),
                                registerFieldWidget(
                                    productPriceController, "Preço", context),
                                const SizedBox(height: 50),
                                registerFieldWidget(productQuantityController,
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

              // productQuantity: productQuantityController.text,
              // product: Product(
              //     categories: "categories",
              //     primaryColor: "primaryColor",
              //     secondaryColor: "secondaryColor",
              //     price: {},
              //     quantity: "quantity",
              //     status: 1)
            ),
          ),
        ),
      ],
    );
  }
}
