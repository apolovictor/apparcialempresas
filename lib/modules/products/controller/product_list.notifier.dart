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

final opacityProductCardNotifier =
    StateNotifierProvider<OpacityProductCardProvider, double>(
        (ref) => OpacityProductCardProvider());
final widthProductCardNotifier =
    StateNotifierProvider<WidthProductCardProvider, double>(
        (ref) => WidthProductCardProvider());
