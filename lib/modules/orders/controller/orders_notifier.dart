import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:equatable/equatable.dart';

class MyParameter extends Equatable {
  MyParameter({
    required this.min,
    required this.max,
    required this.value,
  });

  final double min;
  final double max;
  final double value;

  @override
  List<Object> get props => [min, max, value];
}

class AnimationItemsController extends StateNotifier<AnimationController> {
  AnimationItemsController() : super(controller);
  static AnimationController controller = useAnimationController(
    duration: const Duration(milliseconds: 600),
  );

  fling(bool isOpen) {
    print('here');
    print(isOpen);
    state.fling(velocity: isOpen ? -2 : 2);
    return state;
  }
}

class IsOpenController extends StateNotifier<bool> {
  IsOpenController() : super(isOpen);
  static bool isOpen = false;

  toogle(bool isOpen) {
    state = !isOpen;
  }
}

final lerpProvider = Provider.family<double, MyParameter>((ref, myParameter) {
  return lerpDouble(myParameter.min, myParameter.max, myParameter.value)!;
});

final isOpenProvider =
    StateNotifierProvider<IsOpenController, bool>((ref) => IsOpenController());

final animationItemsProvider =
    StateNotifierProvider<AnimationItemsController, AnimationController>(
        (ref) => AnimationItemsController());
