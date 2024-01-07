import 'dart:math' as math;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:equatable/equatable.dart';

import '../model/order_model.dart';

var tableIdDocumentNotifier = StateProvider((_) => '');

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class RegisterOrder extends ChangeNotifier {
  static String idDocument = "bandiis";

  Future<bool> registerOrder(int idTable, String clientName) async {
    final businessCollection = _firestore.collection('business');

    final date = DateTime.now();

    final order = AddOrder(
        '', clientName, idTable, '0', FieldValue.serverTimestamp(), '');

    try {
      await businessCollection.doc(idDocument).collection("orders").add({
        'idTable': idTable,
        'clientName': clientName,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 1
      }).then((value) {
        print(value.id);
        businessCollection
            .doc(idDocument)
            .collection("orders")
            .doc(value.id)
            .update({'idDocument': value.id});

        businessCollection
            .doc(idDocument)
            .collection("tables")
            .doc(idTable.toString())
            .update({'idDocument': value.id});
      });

      return true;
    } catch (e) {
      // print(e.message);
      return Future.error(e);
    }
  }
}

final registerOrderProvider = Provider((ref) => RegisterOrder());

class OrdersNotifier extends ChangeNotifier {
  final businessCollection = _firestore.collection('business');

  // final orderNotifier = StreamProvider.autoDispose<ActiveOrder>((ref) {
  //   var idDocument = ref.watch(tableIdDocumentNotifier);
  //   print(idDocument);
  //   var result = _firestore
  //       .collection('business')
  //       .doc('bandiis')
  //       .collection('orders')
  //       .where('idDocument', isEqualTo: idDocument)
  //       .snapshots()
  //       .map((doc) => ActiveOrder.fromDoc(doc));

  //   // print(result.map((e) => e.clientName));
  //   print(result.first);
  //   print('result ========= $result');
  //   return result;
  // });

  Stream<QuerySnapshot> getOrderByIdDocument(idDocument) => businessCollection
      .doc('bandiis')
      .collection('orders')
      // .doc(idDocument)
      .where('idDocument', isEqualTo: idDocument)
      .snapshots();
}

final ordersNotifierProvider = Provider((ref) => OrdersNotifier());

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

class IsAddingItemController extends StateNotifier<bool> {
  IsAddingItemController() : super(isAddingItem);
  static bool isAddingItem = false;

  toogle(bool isAddingItem) {
    state = isAddingItem;
  }
}

class ItemListController extends StateNotifier<List<OrderItem>> {
  ItemListController() : super(itemList);
  static List<OrderItem> itemList = [];

  setItem(OrderItem item) {
    state = [...state, item];
  }

  updateItem(int index, OrderItem item) {
    state = [
      ...state.map(
        (e) => e.idDocument == item.idDocument
            ? e.copyWith(quantity: e.quantity + 1)
            : e,
      ),
    ];
  }

  updateItemQuantity(String checkQuantity, OrderItem item) {
    state = [
      ...state.map(
        (e) => e.idDocument == item.idDocument && checkQuantity == 'increment'
            ? e.copyWith(quantity: e.quantity + 1)
            : e.idDocument == item.idDocument && checkQuantity == 'decrement'
                ? e.copyWith(quantity: e.quantity - 1)
                : e,
      ),
    ];
  }

  removeItem(OrderItem item) {
    state = [
      ...state.where((e) => e.idDocument != item.idDocument),
    ];
  }

  void clearItemList() {
    state.clear();
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
  static AddOrder order =
      AddOrder('', '', 0, '', FieldValue.serverTimestamp(), Timestamp(0, 0));

  addOrder(AddOrder order) {
    state = order;
  }
}

final lerpProvider = Provider.family<double, MyParameter>((ref, myParameter) {
  return lerpDouble(myParameter.min, myParameter.max, myParameter.value)!;
});

final isOpenProvider =
    StateNotifierProvider<IsOpenController, bool>((ref) => IsOpenController());
final isAddingItemProvider =
    StateNotifierProvider<IsAddingItemController, bool>(
        (ref) => IsAddingItemController());
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
final itemListProvider =
    StateNotifierProvider<ItemListController, List<OrderItem>>(
        (ref) => ItemListController());

AnimationController buttonProductAddController(WidgetRef ref) {
  final controller =
      useAnimationController(duration: const Duration(milliseconds: 500));
  final isOpened = ref.watch(isOpenProvider);

  final currentOrderState = ref.watch(currentOrderStateProvider);
  bool isAddingItem = ref.watch(isAddingItemProvider);
  controller.forward();
  if (isAddingItem) {
    controller.reverse();
  }
  if (currentOrderState == OrderStateWidget.close) {
    controller.reverse();
  }
  // if (isOpened) {
  //   // Future.delayed(const Duration(milliseconds: 100), () {
  //   // });
  // } else {
  //   controller.reverse();
  // }

  return controller;
}

AnimationController dragItemAreaController(WidgetRef ref) {
  final controller =
      useAnimationController(duration: const Duration(milliseconds: 500));
  bool isAddingItem = ref.watch(isAddingItemProvider);
  if (isAddingItem) {
    controller.forward();
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
      // if (controller.isAnimating ||
      //     controller.status == AnimationStatus.completed) {
      //   break;
      // }
      // print(flingVelocity);
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
