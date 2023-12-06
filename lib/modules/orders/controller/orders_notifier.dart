import 'dart:math' as math;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:equatable/equatable.dart';

import '../model/order_model.dart';

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
    // print('here');
    // print(isOpen);
    state.fling(velocity: isOpen ? -2 : 2);
    return state;
  }
}

class IsOpenController extends StateNotifier<bool> {
  IsOpenController() : super(isOpen);
  static bool isOpen = false;

  toogle(bool isOpen) {
    state = isOpen;
  }
}

class IsOldOpenController extends StateNotifier<bool> {
  IsOldOpenController() : super(isOldOpen);
  static bool isOldOpen = false;

  toogle(bool isOldOpen) {
    state = isOldOpen;
  }
}

class WidgetAnimationController extends StateNotifier<AnimationController> {
  WidgetAnimationController() : super(controller);
  static AnimationController controller =
      useAnimationController(duration: const Duration(milliseconds: 500));

  toogle(bool isOpen) {
    state.fling(velocity: isOpen ? -2 : 2);
    return state;
  }
}

class DragUpdate extends StateNotifier<double> {
  DragUpdate() : super(dragUpate);
  static double dragUpate = 0.0;

  setDrag(double dragUpate) {
    state = dragUpate;
  }
}

class AddOrderController extends StateNotifier<AddOrder> {
  AddOrderController() : super(order);
  static AddOrder order = AddOrder('', '', '', [], 0, Timestamp(0, 0));

  addOrder(AddOrder order) {
    state = order;
  }
}

final lerpProvider = Provider.family<double, MyParameter>((ref, myParameter) {
  return lerpDouble(myParameter.min, myParameter.max, myParameter.value)!;
});

final isOpenProvider =
    StateNotifierProvider<IsOpenController, bool>((ref) => IsOpenController());
final isOldOpenProvider = StateNotifierProvider<IsOldOpenController, bool>(
    (ref) => IsOldOpenController());
final dragUpdateProvider =
    StateNotifierProvider<DragUpdate, double>((ref) => DragUpdate());
final controllerProvider =
    StateNotifierProvider<WidgetAnimationController, AnimationController>(
        (ref) => WidgetAnimationController());
final addOrderProvider = StateNotifierProvider<AddOrderController, AddOrder>(
    (ref) => AddOrderController());

final animationItemsProvider =
    StateNotifierProvider<AnimationItemsController, AnimationController>(
        (ref) => AnimationItemsController());

AnimationController buttonProductAddController(WidgetRef ref) {
  final controller =
      useAnimationController(duration: const Duration(milliseconds: 500));
  final isOpened = ref.watch(isOpenProvider);

  if (isOpened) {
    // Future.delayed(const Duration(milliseconds: 100), () {
    controller.forward();
    // });
  } else {
    controller.reverse();
  }

  return controller;
}

AnimationController orderWidgetController(WidgetRef ref) {
  final controller =
      useAnimationController(duration: const Duration(milliseconds: 500));
  // final isOpened = ref.watch(isOpenProvider);

  final orderStateWidget = ref.watch(currentOrderStateProvider);
  final dragValue = ref.watch(dragValueProvider);
  final flingVelocity = ref.watch(flingVelocityProvider);

  switch (orderStateWidget) {
    case OrderStateWidget.onResume:
      controller.fling(velocity: -2);
      return controller;
    case OrderStateWidget.open:
      controller.fling(velocity: 2);
    case OrderStateWidget.close:
      controller.fling(velocity: -2);
      break;
    case OrderStateWidget.dragUpdate:
      controller.value = dragValue;
    case OrderStateWidget.dragEnd:
      if (controller.isAnimating ||
          controller.status == AnimationStatus.completed) {
        break;
      }
      if (flingVelocity < 0.0) {
        controller.fling(
            velocity:
                math.max(2.0, -flingVelocity)); //<-- either continue it upwards
      } else if (flingVelocity > 0.0) {
        controller.fling(
            velocity:
                math.min(-2.0, -flingVelocity)); //<-- or continue it downwards
      } else {
        controller.fling(
            velocity: controller.value < 0.5
                ? -2.0
                : 2.0); //<-- or just continue to whichever edge is closer
      }
    // controller.value = dragValue;

    default:
      throw Exception();
  }

  return controller;
}

enum OrderStateWidget { close, open, dragUpdate, dragEnd, onResume }

final currentOrderStateProvider =
    StateProvider((ref) => OrderStateWidget.close);

final dragValueProvider = StateProvider((ref) => 0.0);
final flingVelocityProvider = StateProvider((ref) => 0.0);

final orderStateListProvider = Provider<List<OrderStateWidget>>((ref) {
  return OrderStateWidget.values;
});
