import 'package:cached_firestorage/lib.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloudFirestore;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/products_model.dart';
import 'product_list.notifier.dart';

part 'products_notifier.g.dart';

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

final productProvider =
    StreamNotifierProvider<ProductNotifier, List<Product>>(() {
  return ProductNotifier();
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

@Riverpod(keepAlive: false)
class PictureProductList extends _$PictureProductList {
  @override
  List<RemotePicture> build() => state = [];

  add(RemotePicture img) async {
    if (!state.any((e) => e.mapKey == img.mapKey)) {
      state = [...state, img];
    }
    return state;
  }
}

@Riverpod(keepAlive: true)
class PictureProductListAndroid extends _$PictureProductListAndroid {
  @override
  List<Stream<FileResponse>> build() => state = [];

//    Stream<FileResponse>  getImageFile(String url, {
//     String key,
//     Map<String, String> headers,
//     bool withProgress,
//     int maxHeight,  // This is extra
//     int maxWidth,   // This is extra as well
// })

  add(String imgId, int length) async {
    // final storage = FirebaseStorage.instance;
    // var storageReference = storage.ref('products/$imgId');

    Stream<FileResponse>? fileStream;

    fileStream = DefaultCacheManager().getFileStream(
      'https://storage.googleapis.com/appparcial-123.appspot.com/products/$imgId',
      key: imgId,
    );

    if (state.length < length) {
      state = [...state, fileStream];
    }
    return state;
  }

  Stream<FileResponse> downLoadFile(String imgId) {
    var result = DefaultCacheManager().getImageFile(
      'https://storage.googleapis.com/appparcial-123.appspot.com/products/$imgId',
    );
    return result;
  }
}

@Riverpod(keepAlive: true)
class PictureCategoryList extends _$PictureCategoryList {
  @override
  List<RemotePicture> build() => state = [];

  add(RemotePicture img, int length) async {
    if (state.length < length) {
      state = [...state, img];
    }
    return state;
  }
}

@Riverpod(keepAlive: true)
class PictureCategoriesListAndroid extends _$PictureCategoriesListAndroid {
  @override
  List<NetworkImage> build() => state = [];

  add(String imgId, int length) async {
    // final storage = FirebaseStorage.instance;
    // var storageReference = storage.ref('products/$imgId');

    var imgNetworkWidget = NetworkImage(
      "https://storage.googleapis.com/appparcial-123.appspot.com/categories_icons/$imgId.png",
    );

    if (state.length < length) {
      state = [...state, imgNetworkWidget];
    }
    return state;
  }

  donwloadFile(String imgId) =>
      DefaultCacheManager().getFileStream(imgId, withProgress: true);
}

final idDocumentNotifier = StateNotifierProvider<IdDocumentProvider, String>(
    (ref) => IdDocumentProvider());
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

class ProductNotifier extends StreamNotifier<List<Product>> {
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

final productsStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) => _businessCollection
            .doc(ref.watch(idDocumentNotifier))
            .collection("products")

            // .where('status', isEqualTo: ref.watch(statusNotifier))
            .snapshots()
            .map((snapshot) {
          return snapshot.docs.map((doc) {
            Product product = Product.fromDoc(doc);

            return product;
          }).toList();
        }));

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

class ProductUnitPriceController extends StateNotifier<TextEditingController> {
  ProductUnitPriceController() : super(productUnitPrice);
  static TextEditingController productUnitPrice = TextEditingController();

  fetchProductUnitPrice(TextEditingController productUnitPrice) {
    state = productUnitPrice;
    return state;
  }

  clear() {
    state.clear();
  }
}

class AddProductNameController extends StateNotifier<TextEditingController> {
  AddProductNameController() : super(productName);
  static TextEditingController productName = TextEditingController();

  fetchProductName(TextEditingController productName) {
    state = productName;
    return state;
  }

  clear() {
    state.clear();
  }
}

class AddProductPriceController extends StateNotifier<TextEditingController> {
  AddProductPriceController() : super(productPrice);
  static TextEditingController productPrice = TextEditingController();

  fetchProductPrice(TextEditingController productPrice) {
    state = productPrice;
    return state;
  }

  clear() {
    state.clear();
  }
}

class AddProductPromoController extends StateNotifier<TextEditingController> {
  AddProductPromoController() : super(productPromo);
  static TextEditingController productPromo = TextEditingController();

  fetchProductPromo(TextEditingController productPromo) {
    state = productPromo;
    return state;
  }

  clear() {
    state.clear();
  }
}

class AddProductQuantityController
    extends StateNotifier<TextEditingController> {
  AddProductQuantityController() : super(productQuantity);
  static TextEditingController productQuantity = TextEditingController();

  fetchProductQuantity(TextEditingController productQuantity) {
    state = productQuantity;
    return state;
  }

  clear() {
    state.clear();
  }
}

class AddProductUnityPriceController
    extends StateNotifier<TextEditingController> {
  AddProductUnityPriceController() : super(productUnityPrice);
  static TextEditingController productUnityPrice = TextEditingController();

  fetchProductUnityPrice(TextEditingController productUnityPrice) {
    state = productUnityPrice;
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
final productUnitPriceProvider =
    StateNotifierProvider<ProductUnitPriceController, TextEditingController>(
        (ref) => ProductUnitPriceController());
final addProductNameProvider =
    StateNotifierProvider<AddProductNameController, TextEditingController>(
        (ref) => AddProductNameController());
final addProductPriceProvider =
    StateNotifierProvider<AddProductPriceController, TextEditingController>(
        (ref) => AddProductPriceController());
final addProductPromoProvider =
    StateNotifierProvider<AddProductPromoController, TextEditingController>(
        (ref) => AddProductPromoController());
final addProductQuantityProvider =
    StateNotifierProvider<AddProductQuantityController, TextEditingController>(
        (ref) => AddProductQuantityController());
final addProductUnityPriceProvider = StateNotifierProvider<
    AddProductUnityPriceController,
    TextEditingController>((ref) => AddProductUnityPriceController());
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
