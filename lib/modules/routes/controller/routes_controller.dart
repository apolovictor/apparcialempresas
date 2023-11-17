import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/route_names.dart';

class SelectedRouteListProvider extends StateNotifier<int> {
  SelectedRouteListProvider() : super(0);

  setSelected(selected) => state = selected;
}

// class SizeLayoutProvider extends StateNotifier<Size> {
//   SizeLayoutProvider() : super(Size(0, 0));

//   setSize(size) => state = size;
// }

final routeListProvider =
    StateNotifierProvider<RouteListProvider, List<RouteNamesList>>((ref) {
  // !! LOCAL ONDE IRÁ RECEBER O SNAPSHOT DO FIREBASE E POPULAR A MODEL LIST COM TODAS AS EMPRESAS

  return RouteListProvider(topBarList);
});

class RouteListProvider extends StateNotifier<List<RouteNamesList>> {
  RouteListProvider([topBarList]) : super(topBarList ?? []);
}

final selectedRouteNotifier =
    StateNotifierProvider<SelectedRouteListProvider, int>(
        (ref) => SelectedRouteListProvider());
// final sizeLayoutNotifier = StateNotifierProvider<SizeLayoutProvider, Size>(
//     (ref) => SizeLayoutProvider());
