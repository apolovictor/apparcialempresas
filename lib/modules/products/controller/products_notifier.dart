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

class FilteredProductProvider extends StateNotifier<List<Product>> {
  FilteredProductProvider() : super([]);

  fetchFilteredList(list) {
    state = list;
  }
}

class GlobalKeyProductProvider extends StateNotifier<List<LabeledGlobalKey>> {
  GlobalKeyProductProvider() : super([]);

  fetchGlobalKeyList(List<LabeledGlobalKey> list) {
    state = [...list];
  }
}

class OffsetKeyProductProvider extends StateNotifier<List<OffsetProduct>> {
  OffsetKeyProductProvider() : super([]);

  fetchOffsetList(OffsetProduct item) {
    state = [...state, item];
  }

  updateOffSetList(OffsetProduct item, int index) {
    state[index] = item;
  }
}

class PictureProductProvider extends StateNotifier<List<RemotePicture>> {
  PictureProductProvider() : super([]);

  // static RemotePicture imgs = const RemotePicture(
  //   imagePath: '',
  //   mapKey: '',
  //   fit: BoxFit.fill,
  // );

  fetchPictureList(img) {
    state = [...state, img];
  }
}

final idDocumentNotifier = StateNotifierProvider<IdDocumentProvider, String>(
    (ref) => IdDocumentProvider());
final pictureProductListProvider =
    StateNotifierProvider<PictureProductProvider, List<RemotePicture>>(
        (ref) => PictureProductProvider());
final filteredProductListProvider =
    StateNotifierProvider<FilteredProductProvider, List<Product>>(
        (ref) => FilteredProductProvider());
final globalKeyListProvider =
    StateNotifierProvider<GlobalKeyProductProvider, List<LabeledGlobalKey>>(
        (ref) => GlobalKeyProductProvider());
final offsetListProvider =
    StateNotifierProvider<OffsetKeyProductProvider, List<OffsetProduct>>(
        (ref) => OffsetKeyProductProvider());

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

final exampleProvider =
    StreamNotifierProvider.autoDispose<ExampleNotifier, List<Product>>(() {
  return ExampleNotifier();
});

class ExampleNotifier extends AutoDisposeStreamNotifier<List<Product>> {
  downloadUrl(product) async =>
      await storage.ref("products").child(product).getDownloadURL();

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

  updateImageToProductList(String photo, int index) async {
    return await state.map(
        data: (e) {
          e.value[index].logo = photo;
        },
        error: (e) {},
        loading: (e) {});
  }
}

// Add methods to mutate the state

// final productsProvider =
//     NotifierProvider.autoDispose<ExampleNotifier, List<Product>>(
//   ExampleNotifier.new,
// );

// class ExampleNotifier extends AutoDisposeNotifier<List<Product>> {
//   @override
//   List<Product> build() async {
//     return _businessCollection
//         .doc(ref.watch(idDocumentNotifier))
//         .collection("products")
//         .where("")
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) {
//         Product product = Product.fromDoc(doc);

//         return product;
//       }).toList();
//     });
//   }

//   // Add methods to mutate the state
// }

// class FilteredProductList extends StateNotifier {
//   FilteredProductList() : super([]);

//   getFilteredProducts(WidgetRef ref) {
//     final products = _businessCollection
//         .doc(ref.watch(idDocumentNotifier))
//         .collection("products")
//         .where("")
//         .snapshots()
//         .map((snapshot) =>
//             snapshot.docs.map((doc) => Product.fromDoc(doc)).toList());

//     final productList = products
//         .where((product) => product.where((element) =>
//             element.categories == ref.watch(filterCategoryNotifier)))
//         .toList();
//   }
// }

// class TodoList extends StateNotifier<List<Product>> {
//   TodoList() : super([]);

//   void filterByStatus(int target) {
//     state = target == 0
//         ? initialTodos
//         : initialTodos.where((element) => element.status == target).toList();
//   }
// }

// final filteredProvider =
//     StreamProvider.autoDispose<List<Product>>((ref) {

//       Map<Filter, dynamic> filter = ref.watch(filteredProductListProvider);
//     List<Product> products = ref.watch(productsNotifier).value!;

//     print(products);
//     print(filter.keys.first.categories);
//     print(filter.keys.first.status);

//     return products;
//     });

// class ProductProvider extends ChangeNotifier {
//   filteredProductList(WidgetRef ref) {
//     Map<String, dynamic> filter = ref.read(filteredProductListProvider);
//     List<Product> products = ref.watch(productsNotifier).value!;

//     print(filter.entries.length);

//     print(products);
//     // print(filter.keys.first.categories);
//     // print(filter.keys.first.status);

//     return products;
//   }
// }

// final productsFilteredProvider = Provider((ref) => ProductProvider());

// final filteredProductList =
//     StateNotifierProvider<FilterProductProvider, Map>((ref) {
//   return [];
// });

// final filteredProductList = StateNotifierProvider<List<Product>>((ref) {
//   return [];
// });

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
final isProductDetailOpenedProvider =
    StateNotifierProvider<IsCategoriesOpeneNotifier, bool>(
        (ref) => IsCategoriesOpeneNotifier());

getCategoriesController(WidgetRef ref) {
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

getQuickFieldsController(WidgetRef ref) {
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

getProductAddController(WidgetRef ref) {
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
