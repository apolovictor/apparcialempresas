import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class UpdateProduct extends ChangeNotifier {
  static String idDocument = "bandiis";

  Future<bool> updateQuickProduct(
      String productId,
      String productName,
      double productPrice,
      double productPromo,
      int productQuantity,
      double productUnitPrice) async {
    final businessCollection = _firestore.collection('business');
//!!CHECAR SE A QUANTIDADE É O UNICO CAMPO ALTERADO NO PROCESSO, CASO SEJA, ALTERAR COM O FILEDVALUE.INCREMENT()

    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction
          .get(businessCollection
              .doc(idDocument)
              .collection("products")
              .doc(productId))
          .then((value) async {
        print(value.data()?['avgUnitPrice']);
        print(value.data()?['numStockIn']);

        final stockRef = businessCollection
            .doc(idDocument)
            .collection("products")
            .doc(productId)
            .collection("stockTransactions")
            .doc();

        transaction.set(stockRef, {
          'type': 'in',
          'quantity': productQuantity,
          'unitPrice': productUnitPrice,
          'date': FieldValue.serverTimestamp()
        });

        if (value.data()?['avgUnitPrice'] == null &&
            value.data()?['numStockIn'] == null) {
          transaction.update(
              businessCollection
                  .doc(idDocument)
                  .collection("products")
                  .doc(productId),
              {
                'avgUnitPrice': productUnitPrice,
                'numStockIn': 1,
                'quantity': FieldValue.increment(productQuantity),
              });

          return true;
        } else {
          print('here');
          var newNumQuantity = value.data()?['numStockIn'] + 1;
          var newAvgUnitPrice =
              ((value.data()?['avgUnitPrice'] * value.data()?['numStockIn']) +
                      (productUnitPrice)) /
                  newNumQuantity;

          transaction.update(
              businessCollection
                  .doc(idDocument)
                  .collection("products")
                  .doc(productId),
              {
                'avgUnitPrice': newAvgUnitPrice,
                'numStockIn': newNumQuantity,
                'quantity': FieldValue.increment(productQuantity),
              });

          print(newAvgUnitPrice);
          print(newNumQuantity);
          return true;
        }
      });

      return true;
    });

    // await businessCollection
    //     .doc(idDocument)
    //     .collection("products")
    //     .doc(productId)
    //     .update({
    //   'name': productName,
    //   'price': {'price': productPrice, 'promo': productPromo},
    //   'quantity': FieldValue.increment(productQuantity),
    //   'unitPrice': productUnitPrice
    // });
    return true;
  }

  Future<bool> updateStatusProduct(
    String productId,
    int status,
  ) async {
    final businessCollection = _firestore.collection('business');

    try {
      await businessCollection
          .doc(idDocument)
          .collection("products")
          .doc(productId)
          .update({'status': status});
      return true;
    } catch (e) {
      // print(e.message);
      return Future.error(e);
    }
  }
}

final updateProductProvider = Provider((ref) => UpdateProduct());
