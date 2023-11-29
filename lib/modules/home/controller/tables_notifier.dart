import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/home_model.dart';
import '../model/tables_model.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
final _businessCollection = _firestore.collection('business');
String idDocument = "bandiis";

class TablesNotifier extends ChangeNotifier {
  // Stream get allTables =>
  //     _firestore.collection("tables").orderBy('idTable').snapshots();
  final tableChangeNotifier =
      StreamProvider.autoDispose<List<DashboardTables?>?>((ref) {
    final stream = _businessCollection
        .doc(idDocument)
        .collection('tables')
        .orderBy('idTable')
        .snapshots();

    return stream.map((snapshot) => snapshot.docs
        .map((doc) => DashboardTables.fromDoc(doc.data()))
        .toList());
  });
  final tableActiveNotifier =
      StreamProvider.autoDispose<List<DashboardTables?>?>((ref) {
    final stream = _businessCollection
        .doc(idDocument)
        .collection('tables')
        .where('status', isNotEqualTo: 1)
        .snapshots();

    return stream.map((snapshot) => snapshot.docs
        .map((doc) => DashboardTables.fromDoc(doc.data()))
        .toList());
  });
}

final tablesNotifierProvider = Provider((ref) => TablesNotifier());

class DragTableController extends StateNotifier<DashboardTables> {
  DragTableController() : super(dragTable);
  static DashboardTables dragTable = DashboardTables(0, '', 0, 0);

  fetchdragTable(DashboardTables dragTable) {
    state = dragTable;
    return state;
  }

  Future<bool> bookingOrderedByDraggable(DashboardTables table) async {
    try {
      await _businessCollection
          .doc(idDocument)
          .collection('tables')
          .doc(table.idTable.toString())
          .update({'status': 2, 'openingClosing': 1});

      return true;
    } catch (e) {
      // print(e.message);
      return Future.error(e);
    }
  }

  clear() {
    state = DashboardTables(0, '', 0, 0);
  }
}

final dragTableNotifier =
    StateNotifierProvider<DragTableController, DashboardTables>(
        (ref) => DragTableController());
