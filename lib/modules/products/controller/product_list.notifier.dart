import 'package:apparcialempresas/modules/products/model/products_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final storage = FirebaseStorage.instance;

class WidthProductCardProvider extends StateNotifier<double> {
  WidthProductCardProvider() : super(width);

  static double width = 0.0;
  fetchWidth(double width) => state = width;
}

class OpacityProductCardProvider extends StateNotifier<double> {
  OpacityProductCardProvider() : super(opacity);

  static double opacity = 0.0;
  fetchOpacity(double opacity) => state = opacity;
}

class ScrollListProvider extends StateNotifier<ScrollController> {
  ScrollListProvider() : super(scrollController);

  static ScrollController scrollController = ScrollController();
}

final scrollListNotifier = ProviderFamily(
    (ref, int arg) => FixedExtentScrollController(initialItem: arg));

final selectedItemNotifier = ProviderFamily((_, int arg) => arg);

class SelectedProductListProvider extends StateNotifier<int> {
  SelectedProductListProvider() : super(-1);

  setSelected(selected) => state = selected;
}

class OffsetProductListProvider extends StateNotifier<Offset> {
  OffsetProductListProvider() : super(offset);

  static Offset offset = const Offset(0, 0);

  setOffset(offset) => state = offset;
}

class IsActiveProvider extends StateNotifier<bool> {
  IsActiveProvider() : super(isActive);

  static bool isActive = false;

  setIsActive(isActive) => state = isActive;
}

class IsQuickEditProvider extends StateNotifier<bool> {
  IsQuickEditProvider() : super(isActiveEdit);

  static bool isActiveEdit = false;

  setIsActiveEdit(isActiveEdit) => state = isActiveEdit;
}

class ProductListSize extends StateNotifier<double> {
  ProductListSize() : super(size);

  static double size = 0.0;

  setSize(size) => state = size;
}

class ImageProductProvider extends StateNotifier<String> {
  ImageProductProvider() : super("");

  downloadUrl(product) async {
    var downloadUrl =
        await storage.ref("products").child(product).getDownloadURL();

    state = downloadUrl;
  }
}

final imgProvider = FutureProvider<String>((ref) async {
  if (ref.state.isRefreshing) {}

  return "";
});

final imageProductNotifier =
    StateNotifierProvider<ImageProductProvider, String>(
        (ref) => ImageProductProvider());
final isActiveEditNotifier = StateNotifierProvider<IsQuickEditProvider, bool>(
    (ref) => IsQuickEditProvider());

final isActiveNotifier =
    StateNotifierProvider<IsActiveProvider, bool>((ref) => IsActiveProvider());
final productListSizeNotifier =
    StateNotifierProvider<ProductListSize, double>((ref) => ProductListSize());
final offsetProductNotifier =
    StateNotifierProvider<OffsetProductListProvider, Offset>(
        (ref) => OffsetProductListProvider());
final selectedProductNotifier =
    StateNotifierProvider<SelectedProductListProvider, int>(
        (ref) => SelectedProductListProvider());
final scrollControllerNotifier =
    StateNotifierProvider<ScrollListProvider, ScrollController>(
        (ref) => ScrollListProvider());
final opacityProductCardNotifier =
    StateNotifierProvider<OpacityProductCardProvider, double>(
        (ref) => OpacityProductCardProvider());
final widthProductCardNotifier =
    StateNotifierProvider<WidthProductCardProvider, double>(
        (ref) => WidthProductCardProvider());
final indexProvider = Provider<int>((_) {
  return 0;
});
