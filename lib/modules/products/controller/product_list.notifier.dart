import 'package:apparcialempresas/modules/products/model/products_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

class ProductItemProvider extends StateNotifier<List<ProductItem>> {
  ProductItemProvider() : super([]);

  setProduct(ProductItem item) {
    // state.clear();
    // print(item.index);
    // print(item.offset);
    state.add(item);
    // print(state.map((e) => e.index));
    // print(state.map((e) => e.offset));
  }

  // state.clear();
  updateOffset(int index, ProductItem productItem) {
    // print(productItem.offset);
    // print(state.map((e) => e.index));
    // print(state.map((e) => e.offset));
    // state.removeAt(index);
    state[index] = productItem;
  }
}

final isActiveEditNotifier = StateNotifierProvider<IsQuickEditProvider, bool>(
    (ref) => IsQuickEditProvider());
final productItemNotifier =
    StateNotifierProvider<ProductItemProvider, List<ProductItem>>(
        (ref) => ProductItemProvider());
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
