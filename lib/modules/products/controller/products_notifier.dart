import 'package:cloud_firestore/cloud_firestore.dart' as cloudFirestore;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/products_model.dart';

cloudFirestore.FirebaseFirestore _firestore =
    cloudFirestore.FirebaseFirestore.instance;
final _businessCollection = _firestore.collection('business');
final categoriesCollection = _firestore.collection('categories');
var filterNotifier = StateProvider((_) => <String, dynamic>{
      "category": "",
      "status": 0,
    });

var categoryNotifier = StateProvider((_) => "");
var statusNotifier = StateProvider((_) => 0);

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
    print("list ========== $list");
    state = list;
  }
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

final productsNotifier = StreamProvider<List<Product>>((ref) {
  // print(filter);
  final products = _businessCollection
      .doc(ref.watch(idDocumentNotifier))
      .collection("products")
      .where("")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromDoc(doc)).toList());
  return products;
});

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
