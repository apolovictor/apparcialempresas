import 'package:cached_firestorage/lib.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloudFirestore;
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/products_model.dart';
import 'product_list.notifier.dart';

cloudFirestore.FirebaseFirestore _firestore =
    cloudFirestore.FirebaseFirestore.instance;
final _businessCollection = _firestore.collection('business');
final categoriesCollection = _firestore.collection('categories');
var filterNotifier = StateProvider((_) => <String, dynamic>{
      "category": "",
      "status": 0,
    });

var categoryNotifier = StateProvider((_) => "");
var statusNotifier = StateProvider((_) => 1);

class IdDocumentProvider extends StateNotifier<String> {
  IdDocumentProvider() : super(idDocument);

  static String idDocument = "bandiis";
  fetchIdDocument(String idDocument) => state = idDocument;
}

class FilterProductProvider extends StateNotifier<Map<String, dynamic>> {
  FilterProductProvider() : super({});

  static Map<String, dynamic> filter = {
    "categories": "",
    "status": 0,
  };
  fetchFilter(Map<String, dynamic> filter) => state = filter;
}

final exampleProvider =
    StreamNotifierProvider<ExampleNotifier, List<Product>>(() {
  return ExampleNotifier();
});

class FilteredProductProvider extends StateNotifier<List<Product>> {
  FilteredProductProvider() : super([]);

  fetchFilteredList(list) {
    state = list;
  }

  clear() {
    state.clear();
  }
}

final filteredProductsProvider =
    FutureProvider.family<List<Product>, List<Product>>((ref, products) {
  var filter = ref.watch(filterNotifier);
  return filter['category'].isNotEmpty
      ? products
          .where((product) => product.categories == filter['category'])
          .toList()
      : products;
});

class PictureProductProvider extends StateNotifier<List<RemotePicture>> {
  PictureProductProvider() : super([]);

  fetchPictureList(RemotePicture img, int length) {
    if (state.length < length) {
      state = [...state, img];
    }
  }

  void clear() {
    state.clear();
  }
}

class PictureCategoriesProvider extends StateNotifier<List<RemotePicture>> {
  PictureCategoriesProvider() : super([]);

  fetchCategoriesList(RemotePicture img, int length) {
    if (state.length < length) {
      state = [...state, img];
    }
    // print('length ======== $length');
    // print('state.length ======== ${state.length}');
    // state.forEach((e) {
    //   print(e.mapKey);
    // });
  }
}

final idDocumentNotifier = StateNotifierProvider<IdDocumentProvider, String>(
    (ref) => IdDocumentProvider());
final pictureProductListProvider =
    StateNotifierProvider<PictureProductProvider, List<RemotePicture>>(
        (ref) => PictureProductProvider());
final pictureCategoriesListProvider =
    StateNotifierProvider<PictureCategoriesProvider, List<RemotePicture>>(
        (ref) => PictureCategoriesProvider());
final filteredProductListProvider =
    StateNotifierProvider<FilteredProductProvider, List<Product>>(
        (ref) => FilteredProductProvider());

final categoriesNotifier = StreamProvider<List<Categories>>((ref) {
  return _businessCollection
      .doc(ref.watch(idDocumentNotifier))
      .collection("categories")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Categories.fromDoc(doc)).toList());
});

// final productsNotifier = StreamProvider<List<Product>>((ref) {
//   final products = _businessCollection
//       .doc(ref.watch(idDocumentNotifier))
//       .collection("products")
//       .where("")
//       .snapshots()
//       .map((snapshot) {
//     return snapshot.docs.map((doc) {
//       Product product = Product.fromDoc(doc);

//       return product;
//     }).toList();
//   });

//   return products;
// });

class ExampleNotifier extends StreamNotifier<List<Product>> {
  // downloadUrl(product) async =>
  //     await storage.ref("products").child(product).getDownloadURL();

  @override
  Stream<List<Product>> build() {
    return _businessCollection
        .doc(ref.watch(idDocumentNotifier))
        .collection("products")

        // .where('status', isEqualTo: ref.watch(statusNotifier))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Product product = Product.fromDoc(doc);

        return product;
      }).toList();
    });
  }

  updateImageToProductList(String photo, int index) {
    return state.map(
        data: (e) {
          e.value[index].logo = photo;
        },
        error: (e) {},
        loading: (e) {});
  }
}

class IsCategoriesOpeneNotifier extends StateNotifier<bool> {
  IsCategoriesOpeneNotifier() : super(isOpened);

  static bool isOpened = false;

  fetch(bool isOpened) {
    state = isOpened;
  }
}

class IsProductDetailOpeneNotifier extends StateNotifier<bool> {
  IsProductDetailOpeneNotifier() : super(isOpened);

  static bool isOpened = false;

  fetch(bool isOpened) {
    state = isOpened;
  }
}

class IsProductsOpeneNotifier extends StateNotifier<bool> {
  IsProductsOpeneNotifier() : super(isOpened);

  static bool isOpened = false;

  fetch(bool isOpened) {
    state = isOpened;
  }
}

class IsCProductDetailOpeneNotifier extends StateNotifier<bool> {
  IsCProductDetailOpeneNotifier() : super(isOpened);

  static bool isOpened = false;

  fetch(bool isOpened) {
    state = isOpened;
  }
}

class ProductNameController extends StateNotifier<TextEditingController> {
  ProductNameController() : super(productName);
  static TextEditingController productName = TextEditingController();

  fetchProductName(TextEditingController productName) {
    state = productName;
    return state;
  }

  clear() {
    state.clear();
  }
}

class ProductPriceController extends StateNotifier<TextEditingController> {
  ProductPriceController() : super(productPrice);
  static TextEditingController productPrice = TextEditingController();

  fetchProductPrice(TextEditingController productPrice) {
    state = productPrice;
    return state;
  }

  clear() {
    state.clear();
  }
}

class ProductPromoController extends StateNotifier<TextEditingController> {
  ProductPromoController() : super(productPromo);
  static TextEditingController productPromo = TextEditingController();

  fetchProductPromo(TextEditingController productPromo) {
    state = productPromo;
    return state;
  }

  clear() {
    state.clear();
  }
}

class ProductQuantityController extends StateNotifier<TextEditingController> {
  ProductQuantityController() : super(productQuantity);
  static TextEditingController productQuantity = TextEditingController();

  fetchProductQuantity(TextEditingController productQuantity) {
    state = productQuantity;
    return state;
  }

  clear() {
    state.clear();
  }
}

final productNameProvider =
    StateNotifierProvider<ProductNameController, TextEditingController>(
        (ref) => ProductNameController());
final productPriceProvider =
    StateNotifierProvider<ProductPriceController, TextEditingController>(
        (ref) => ProductPriceController());
final productPromoProvider =
    StateNotifierProvider<ProductPromoController, TextEditingController>(
        (ref) => ProductPromoController());
final productQuantityProvider =
    StateNotifierProvider<ProductQuantityController, TextEditingController>(
        (ref) => ProductQuantityController());
final isProductsOpenedProvider =
    StateNotifierProvider<IsCProductDetailOpeneNotifier, bool>(
        (ref) => IsCProductDetailOpeneNotifier());

final isCategoriesOpenedProvider =
    StateNotifierProvider<IsCategoriesOpeneNotifier, bool>(
        (ref) => IsCategoriesOpeneNotifier());

AnimationController getCategoriesController(WidgetRef ref) {
  final isOpened = ref.watch(isCategoriesOpenedProvider);

  final controller =
      useAnimationController(duration: const Duration(milliseconds: 375));

  if (isOpened) {
    controller.forward();
  } else {
    controller.reverse();
  }

  return controller;
}

AnimationController getQuickFieldsController(WidgetRef ref) {
  final controller =
      useAnimationController(duration: const Duration(milliseconds: 500));
  final isOpened = ref.watch(isActiveEditNotifier);

  if (isOpened) {
    // Future.delayed(const Duration(milliseconds: 100), () {
    controller.forward();
    // });
  } else {
    controller.reverse();
  }

  return controller;
}

AnimationController getProductAddController(WidgetRef ref) {
  final controller =
      useAnimationController(duration: const Duration(milliseconds: 500));
  final isOpened = ref.watch(isProductsOpenedProvider);

  if (isOpened) {
    // Future.delayed(const Duration(milliseconds: 100), () {
    controller.forward();
    // });
  } else {
    controller.reverse();
  }

  return controller;
}
