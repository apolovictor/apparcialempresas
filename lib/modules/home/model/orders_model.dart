import 'package:apparcialempresas/modules/products/model/products_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardOrders {
  final int orderDocument;
  final String? documentId;
  final int? openingClose;
  final int status;

  DashboardOrders(
    this.orderDocument,
    this.documentId,
    this.openingClose,
    this.status,
  );

  static DashboardOrders fromDoc(dynamic doc) {
    return DashboardOrders(
      doc!['orderDocument'],
      doc['productDocument'],
      doc['openingClose'],
      doc['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderDocument': orderDocument,
      'idDocument': documentId,
      'openingClose': openingClose,
      'status': status,
    };
  }
}

class DashboardDetailOrders {
  final String orderDocument;
  final String productDocument;
  final String productName;
  final String productPhoto;
  final String productCategory;
  final double price;
  final Timestamp createdAt;
  final dynamic? finishedAt;
  final int status;
  final String id;

  DashboardDetailOrders({
    required this.orderDocument,
    required this.productDocument,
    required this.productName,
    required this.productPhoto,
    required this.productCategory,
    required this.price,
    required this.createdAt,
    required this.finishedAt,
    required this.status,
    required this.id,
  });

  static DashboardDetailOrders fromDoc(dynamic doc) {
    return DashboardDetailOrders(
      orderDocument: doc.data()['orderDocument'],
      productDocument: doc.data()['productDocument'],
      productName: doc.data()['productName'],
      productPhoto: doc.data()['productPhoto'],
      productCategory: doc.data()['productCategory'],
      price: doc.data()['price'],
      createdAt: doc.data()['createdAt'],
      finishedAt: doc.data()['finishedAt'],
      status: doc.data()['status'],
      id: doc.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderDocument': orderDocument,
      'productDocument': productDocument,
      'productName': productName,
      'productPhoto': productPhoto,
      'productCategory': productCategory,
      'price': price,
      'createdAt': createdAt,
      'finishedAt': finishedAt,
      'status': status,
    };
  }
}
