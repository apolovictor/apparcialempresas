import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class UpdateProduct extends ChangeNotifier {
  static String idDocument = "bandiis";

  Future<bool> updateQuickProduct(String productId, String productName,
      String productPrice, String productPromo, String productQuantity) async {
    final businessCollection = _firestore.collection('business');

    try {
      await businessCollection
          .doc(idDocument)
          .collection("products")
          .doc(productId)
          .update({
        'name': productName,
        'price': {'price': productPrice, 'promo': productPromo},
        'quantity': productQuantity
      });
      return true;
    } catch (e) {
      // print(e.message);
      return Future.error(e);
    }
  }
}

final updateProductProvider = Provider((ref) => UpdateProduct());
