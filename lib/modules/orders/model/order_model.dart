import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productIdDocument;
  final String productCategory;
  final String productName;
  final String photo_url;
  final String price;
  final int quantity;
  final bool isUnavailble;
  OrderItem({
    required this.productIdDocument,
    required this.productCategory,
    required this.productName,
    required this.photo_url,
    required this.price,
    required this.quantity,
    required this.isUnavailble,
  });

  OrderItem copyWith({
    String? productIdDocument,
    String? productCategory,
    String? productName,
    String? photo_url,
    String? price,
    int? quantity,
    bool? isUnavailble,
  }) {
    return OrderItem(
      productIdDocument: productIdDocument ?? this.productIdDocument,
      productCategory: productCategory ?? this.productCategory,
      productName: productName ?? this.productName,
      photo_url: photo_url ?? this.photo_url,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      isUnavailble: isUnavailble ?? this.isUnavailble,
    );
  }

  static OrderItem fromDoc(dynamic doc) {
    return OrderItem(
      productIdDocument: doc.data()['productIdDocument'],
      productCategory: doc.data()['productCategory'],
      productName: doc.data()['productName'],
      photo_url: doc.data()['photo_url'],
      price: doc.data()['price'],
      quantity: doc.data()['quantity'],
      isUnavailble: doc.data()['isUnavailble'],
    );
  }
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
