import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/home_model.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
final _businessCollection = _firestore.collection('business');

class BusinessProvider extends ChangeNotifier {
  Future<Business> getBusiness(String documentId) async {
    try {
      return await _businessCollection
          .doc(documentId)
          .get()
          .then((value) async => Business.fromDoc(value));
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e);
    }
  }
}

final businessNotifier = Provider((ref) => BusinessProvider());

final responseProvider = FutureProvider.autoDispose
    .family<Business, String>((ref, documentId) async {
  try {
    return await _businessCollection
        .doc(documentId)
        .get()
        .then((value) async => Business.fromDoc(value));
  } catch (e) {
    debugPrint(e.toString());
    return Future.error(e);
  }
});
