import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String idDocument;
  final String productName;
  final String photo_url;
  final String price;
  final int quantity;

  Product(this.idDocument, this.productName, this.photo_url, this.price,
      this.quantity);
}

class AddOrder {
  final String idDocument;
  final String clientName;
  final int idTable;
  final String total;
  final FieldValue startDate;
  final dynamic finishDate;

  AddOrder(this.idDocument, this.clientName, this.idTable, this.total,
      this.startDate, this.finishDate);
}

class ActiveOrder {
  final String idDocument;
  final int idTable;
  final String? clientName;
  final String? total;
  final Timestamp createdAt;
  final dynamic endAt;
  final int status;

  ActiveOrder(
      {required this.idDocument,
      this.clientName,
      required this.idTable,
      this.total,
      required this.createdAt,
      this.endAt,
      required this.status});

  Map<String, dynamic> toMap() {
    return {
      'idDocument': idDocument,
      'idTable': idTable,
      'clientName': clientName,
      'total': total,
      'createdAt': createdAt,
      'endAt': endAt,
      'status': status,
    };
  }

  static ActiveOrder fromDoc(dynamic doc) {
    return ActiveOrder(
        idDocument: doc.data()['idDocument'],
        idTable: doc.data()!['idTable'],
        clientName: doc.data()!['clientName'],
        total: doc.data()['total'],
        createdAt: doc.data()['createdAt'],
        status: doc.data()['status'],
        endAt: doc.data()['endAt']);
  }
}
