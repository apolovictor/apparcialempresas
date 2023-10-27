import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/products_model.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
final _businessCollection = _firestore.collection('business');
final categoriesCollection = _firestore.collection('categories');

class BusinessProvider extends ChangeNotifier {}

class IdDocumentProvider extends StateNotifier<String> {
  IdDocumentProvider() : super(idDocument);

  static String idDocument = "bandiis";
  fetchIdDocument(String idDocument) => state = idDocument;
}

final idDocumentNotifier = StateNotifierProvider<IdDocumentProvider, String>(
    (ref) => IdDocumentProvider());

final categoriesNotifier = StreamProvider<List<Categories>>((ref) {
  return _businessCollection
      .doc(ref.watch(idDocumentNotifier))
      .collection("categories")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Categories.fromDoc(doc)).toList());
});

final productsNotifier = StreamProvider<List<Product>>((ref) {
  var products = _businessCollection
      .doc(ref.watch(idDocumentNotifier))
      .collection("products")
      .where("")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromDoc(doc)).toList());
  return products;
});

class IsCategoriesOpeneNotifier extends StateNotifier<bool> {
  IsCategoriesOpeneNotifier() : super(isOpened);

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

final isProductsOpenedProvider =
    StateNotifierProvider<IsProductsOpeneNotifier, bool>(
        (ref) => IsProductsOpeneNotifier());
final isCategoriesOpenedProvider =
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
