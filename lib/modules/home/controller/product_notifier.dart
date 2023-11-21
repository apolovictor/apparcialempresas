import 'package:cached_firestorage/lib.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloudFirestore;

import '../../products/model/products_model.dart';

cloudFirestore.FirebaseFirestore _firestore =
    cloudFirestore.FirebaseFirestore.instance;

final _businessCollection = _firestore.collection('business');
var filterNotifier = StateProvider((_) => "");

class IdDocumentProvider extends StateNotifier<String> {
  IdDocumentProvider() : super(idDocument);

  static String idDocument = "bandiis";
  fetchIdDocument(String idDocument) => state = idDocument;
}

final categoriesDashboardNotifier = StreamProvider<List<Categories>>((ref) {
  return _businessCollection
      .doc(ref.watch(idDocumentNotifier))
      .collection("categories")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Categories.fromDoc(doc)).toList());
});

class CategoryProductDashboardController extends StateNotifier<String> {
  CategoryProductDashboardController() : super(categoryProduct);
  static String categoryProduct = "";

  fetchCategoryProduct(String categoryProduct) {
    state = categoryProduct;
    return state;
  }

  clear() {
    state = "";
  }
}

class PictureCategoriesProvider extends StateNotifier<List<RemotePicture>> {
  PictureCategoriesProvider() : super([]);

  fetchCategoriesList(RemotePicture img, int length) {
    if (state.length < length) {
      state = [...state, img];
    }
  }
}

class IsShowContainerProvider extends StateNotifier<bool> {
  IsShowContainerProvider() : super(closeTopContainer);

  static bool closeTopContainer = false;
  isShowContainer(bool closeTopContainer) => state = closeTopContainer;
}

// class ProductDashboardProvider extends ChangeNotifier {
//   final filteredProductsProvider = Provider.autoDispose
//       .family<List<Product>, List<Product>>((ref, products) {
//     String filter = ref.watch(filterNotifier);
//     print(filter);
//     return filter.isNotEmpty
//         ? products.where((product) => product.categories == filter).toList()
//         : products;
//   });
// }

// final filteredProductDashboardProvider =
//     FutureProvider.family<List<Product>, List<Product>>((ref, products) {
//   var filter = ref.watch(filterNotifier);
//   return filter.isNotEmpty
//       ? products.where((product) => product.categories == filter).toList()
//       : products;
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

class TopContainerValueProvider extends StateNotifier<double> {
  TopContainerValueProvider() : super(value);

  static double value = 0.0;
  fetchValue(double value) => state = value;
}

class ProductDashboardProvider extends StateNotifier<List<Product>> {
  ProductDashboardProvider() : super([]);

  filteredList(List<Product> products, String filter) {
    state = filter.isEmpty
        ? products
        : products.where((product) => product.categories == filter).toList();
  }

  clear() {
    state.clear();
  }
}

class AnimationPageController extends StateNotifier<ScrollController> {
  AnimationPageController() : super(controller);
  static ScrollController controller = ScrollController();
}

final filteredProductDashboardProvider =
    StateNotifierProvider<ProductDashboardProvider, List<Product>>(
        (ref) => ProductDashboardProvider());
final pictureProductListProvider =
    StateNotifierProvider<PictureProductProvider, List<RemotePicture>>(
        (ref) => PictureProductProvider());
final categoryProductDashboardNotifier =
    StateNotifierProvider<CategoryProductDashboardController, String>(
        (ref) => CategoryProductDashboardController());
final pictureCategoriesListProvider =
    StateNotifierProvider<PictureCategoriesProvider, List<RemotePicture>>(
        (ref) => PictureCategoriesProvider());
final topContainerProvider =
    StateNotifierProvider<TopContainerValueProvider, double>(
        (ref) => TopContainerValueProvider());
final scrollControllerProvider =
    StateNotifierProvider<AnimationPageController, ScrollController>(
        (ref) => AnimationPageController());

final productDashboardProvider =
    StreamNotifierProvider<ProductNotifier, List<Product>>(
        () => ProductNotifier());

final idDocumentNotifier = StateNotifierProvider<IdDocumentProvider, String>(
    (ref) => IdDocumentProvider());

final isShowContainerNotifier =
    StateNotifierProvider<IsShowContainerProvider, bool>(
        (ref) => IsShowContainerProvider());
