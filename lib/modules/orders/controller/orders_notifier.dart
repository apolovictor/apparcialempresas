import 'dart:math' as math;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:equatable/equatable.dart';

import '../../home/controller/product_notifier.dart';
import '../../home/model/orders_model.dart';
import '../../home/model/tables_model.dart';
import '../model/order_model.dart';

var tableIdDocumentNotifier = StateProvider((_) => '');

FirebaseFirestore _firestore = FirebaseFirestore.instance;

final _businessCollection = _firestore.collection('business');

class RegisterOrder extends ChangeNotifier {
  static String idDocument = "bandiis";

  Future<bool> registerOrder(int idTable, String clientName) async {
    final businessCollection = _firestore.collection('business');

    final order = AddOrder(
        '', clientName, idTable, '0', FieldValue.serverTimestamp(), '');
    var date1 = DateTime.now().microsecondsSinceEpoch;
    var date2 = DateTime(2154, 2, 1).microsecondsSinceEpoch;
    var result = date2 - date1;
    final docRef = businessCollection
        .doc(idDocument)
        .collection("orders")
        .doc(result.toString());

    try {
      await docRef.set({
        'idTable': idTable,
        'clientName': clientName,
        'idDocument': result.toString(),
        'createdAt': FieldValue.serverTimestamp(),
        'status': 1
      });
      businessCollection
          .doc(idDocument)
          .collection("tables")
          .doc(idTable.toString())
          .update({'idDocument': result.toString()});

      return true;
    } catch (e) {
      // print(e.message);
      return Future.error(e);
    }
  }

  registerItemOrder(String idDocumentTable, List<OrderItem> itemList) async {
    final businessCollection = _firestore.collection('business');

    checkUpdateStock(
        int quantity, String productIdDocument, int i, OrderItem item) async {
      return await FirebaseFirestore.instance
          .runTransaction((transaction) async {
        var documentSnapshot = await transaction.get(businessCollection
            .doc(idDocument)
            .collection("products")
            .doc(productIdDocument));
        if (quantity <= documentSnapshot.data()!['quantity']) {
          transaction.update(
              businessCollection
                  .doc(idDocument)
                  .collection("products")
                  .doc(productIdDocument),
              <String, dynamic>{'quantity': FieldValue.increment(-quantity)});

          for (var j = 0; j < quantity; j++) {
            var date1 = DateTime.now().microsecondsSinceEpoch;
            var date2 = DateTime(2154, 2, 1).microsecondsSinceEpoch;
            var result = date2 - date1;
            print('i ==== $i');
            print("item === ${item.productName}");

            final docRef = businessCollection
                .doc(idDocument)
                .collection("detailOrders")
                .doc('$result-${item.productName}-$j');
            transaction.set(docRef, {
              'orderDocument': idDocumentTable,
              'productDocument': item.productIdDocument,
              'productCategory': item.productCategory,
              'productName': item.productName,
              'productPhoto': item.photo_url,
              'price': item.price,
              'avgUnitPrice': item.avgUnitPrice,
              'createdAt': FieldValue.serverTimestamp(),
              'finishedAt': '',
              'status': 1
            });
          }
          return true;
        } else {
          return documentSnapshot.data();
        }
      });
    }

    // var newMap = groupBy(itemList, (OrderItem obj) => obj.productIdDocument);
    // print(itemList.length);
    for (var i = 0; i < itemList.length; i++) {
      // print("item.productIdDocument  === ${itemList[i].productIdDocument}");
      var docRef = businessCollection
          .doc(idDocument)
          .collection("products")
          .doc(itemList[i].productIdDocument);

      var result = checkUpdateStock(
          itemList.firstWhere((e) => e.productIdDocument == docRef.id).quantity,
          docRef.id,
          i,
          itemList[i]);

      result.then((value) {
        print(value);
      });
    }
  }
}

final registerOrderProvider = Provider((ref) => RegisterOrder());

class OrdersNotifier extends ChangeNotifier {
  final businessCollection = _firestore.collection('business');

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
        (e) => e.productIdDocument == item.productIdDocument
            ? e.copyWith(quantity: e.quantity + 1)
            : e,
      ),
    ];
  }

  updateUnitPriceOfItem(int index, OrderItem item) {
    state = [
      ...state.map(
        (e) => e.productIdDocument == item.productIdDocument
            ? e.copyWith(avgUnitPrice: e.avgUnitPrice)
            : e,
      ),
    ];
  }

  updateItemQuantity(String checkQuantity, OrderItem item) {
    state = [
      ...state.map(
        (e) => e.productIdDocument == item.productIdDocument &&
                checkQuantity == 'increment'
            ? e.copyWith(quantity: e.quantity + 1)
            : e.productIdDocument == item.productIdDocument &&
                    checkQuantity == 'decrement'
                ? e.copyWith(quantity: e.quantity - 1)
                : e,
      ),
    ];
  }

  removeItem(OrderItem item) {
    state = [
      ...state.where((e) => e.productIdDocument != item.productIdDocument),
    ];
  }

  clearItemList() {
    state.clear();

    state = [];
    return state;
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

final recentOrdersNotifier = StreamProvider<List<DashboardOrders>>((ref) {
  return _businessCollection
      .doc(ref.watch(idDocumentNotifier))
      .collection("detailOrders")
      .where('status', isEqualTo: 1)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => DashboardOrders.fromDoc(doc)).toList());
});

class RecentOrdersNotifier extends StreamNotifier<List<DashboardDetailOrders>> {
  // downloadUrl(product) async =>
  //     await storage.ref("products").child(product).getDownloadURL();

  @override
  Stream<List<DashboardDetailOrders>> build() {
    return _businessCollection
        .doc(ref.watch(idDocumentNotifier))
        .collection("detailOrders")
        .where('status', isEqualTo: 1)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        DashboardDetailOrders recentOrders = DashboardDetailOrders.fromDoc(doc);

        return recentOrders;
      }).toList();
    });
  }

  Stream<DashboardOrders> getOrderByIdDocumentTable(String orderDocument) {
    return _businessCollection
        .doc(ref.watch(idDocumentNotifier))
        .collection("orders")
        .where('idDocument', isEqualTo: orderDocument)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        DashboardOrders detailOrdersTableBill = DashboardOrders.fromDoc(doc);
        return detailOrdersTableBill;
      }).first;
    });
  }

  Stream<List<DashboardDetailOrders>> getDetailOrdersByIdDocumentTable(
      String orderDocument) {
    return _businessCollection
        .doc(ref.watch(idDocumentNotifier))
        .collection("detailOrders")
        .where('orderDocument', isEqualTo: orderDocument)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        DashboardDetailOrders detailOrdersTableBill =
            DashboardDetailOrders.fromDoc(doc);

        return detailOrdersTableBill;
      }).toList();
    });
  }

  getTableByOrderIdDocument(String orderDocument) {
    var docRef = _businessCollection
        .doc(ref.watch(idDocumentNotifier))
        .collection("tables")
        .where('idDocument', isEqualTo: orderDocument)
        .snapshots();

    //   .map((snapshot) {
    // return snapshot.docs.map((doc) => snapshot.docs.first.id

    return docRef.first.then((value) => value.docs.first.id);
    // });
  }

  Future<bool> updateRecentOrder(String orderIdDocument, String productDocument,
      double avgUnitPrice) async {
    final businessCollection = _firestore.collection('business');
    String idDocument = "bandiis";
    var now = DateTime.now();

    var lastMidnight = DateTime(now.year, now.month, now.day);

    try {
      businessCollection
          .doc(idDocument)
          .collection("products")
          .doc(productDocument)
          .collection('stockTransactions')
          .where('date', isGreaterThanOrEqualTo: lastMidnight)
          .where('type', isEqualTo: 'out')
          .limit(1)
          .get()
          .then((value) {
        print(value.docs.isEmpty);

        if (value.docs.isEmpty) {
          businessCollection
              .doc(idDocument)
              .collection("products")
              .doc(productDocument)
              .collection('stockTransactions')
              .add({
            'date': FieldValue.serverTimestamp(),
            'type': 'out',
            'quantity': 1,
            'unitPrice': avgUnitPrice
          });
        } else {
          print(avgUnitPrice);
          businessCollection
              .doc(idDocument)
              .collection("products")
              .doc(productDocument)
              .collection('stockTransactions')
              .doc(value.docs.first.id)
              .update({
            'quantity': FieldValue.increment(1),
            'unitPrice': avgUnitPrice
          });
        }
      });

      await businessCollection
          .doc(ref.watch(idDocumentNotifier))
          .collection("detailOrders")
          .doc(orderIdDocument)
          .update({'status': 2, 'finishedAt': FieldValue.serverTimestamp()});

      return true;
    } catch (e) {
      // print(e.message);
      return Future.error(e);
    }
  }

  Future<bool> finishOrder(
      int idTable, List<DashboardDetailOrders> listDetailOrders) async {
    final businessCollection = _firestore.collection('business');
    var idDocument = ref.watch(idDocumentNotifier);
    final String idDocumentOrder = ref.watch(tableIdDocumentNotifier);
    double totalOrder =
        listDetailOrders.map((e) => e.price).reduce((a, b) => a + b);

    try {
      WriteBatch batch = _firestore.batch();
      final docRefOrders = businessCollection
          .doc(idDocument)
          .collection("orders")
          .doc(idDocumentOrder);
      final docRefTables = businessCollection
          .doc(idDocument)
          .collection("tables")
          .doc(idTable.toString());
      final docRefdetailOrders = businessCollection
          .doc(idDocument)
          .collection("detailOrders")
          .doc(idTable.toString());

      batch.update(docRefOrders, {
        'status': 2,
        'total': totalOrder,
        'finishedAt': FieldValue.serverTimestamp()
      });
      batch.update(docRefTables, {'idDocument': '', 'status': 1});

      for (var item in listDetailOrders) {
        item.status == 2
            ? batch.update(
                businessCollection
                    .doc(idDocument)
                    .collection("detailOrders")
                    .doc(item.id),
                {'status': 4, 'finishedAt': FieldValue.serverTimestamp()})
            : batch.update(
                businessCollection
                    .doc(idDocument)
                    .collection("detailOrders")
                    .doc(item.id),
                {'status': 5, 'finishedAt': FieldValue.serverTimestamp()});
      }

      batch.commit();

      ref.read(isAddingItemProvider.notifier).toogle(false);
      ref.read(itemListProvider.notifier).clearItemList();
      ref.read(currentOrderStateProvider.notifier).state =
          OrderStateWidget.close;
      return true;
    } catch (e) {
      // print(e.message);
      return Future.error(e);
    }
  }
}

final recentOrdersDashboardProvider =
    StreamNotifierProvider<RecentOrdersNotifier, List<DashboardDetailOrders>>(
        () => RecentOrdersNotifier());
