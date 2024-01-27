import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardOrders {
  final String idDocumentOrder;
  final String? clientName;
  final int idTable;
  final Timestamp createdAt;
  final dynamic finishedAt;
  final int status;

  DashboardOrders({
    required this.idDocumentOrder,
    this.clientName,
    required this.idTable,
    required this.createdAt,
    required this.finishedAt,
    required this.status,
  });

  static DashboardOrders fromDoc(dynamic doc) {
    return DashboardOrders(
      idDocumentOrder: doc.data()['idDocument'],
      clientName: doc.data()['clientName'],
      idTable: doc.data()['idTable'],
      createdAt: doc.data()['createdAt'],
      finishedAt: doc.data()['finishedAt'],
      status: doc.data()['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idDocument': idDocumentOrder,
      'clientName': clientName,
      'idTable': idTable,
      'createdAt': createdAt,
      'finishedAt': finishedAt,
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
  final double avgUnitPrice;
  final Timestamp createdAt;
  final dynamic finishedAt;
  final int status;
  final String id;

  DashboardDetailOrders({
    required this.orderDocument,
    required this.productDocument,
    required this.productName,
    required this.productPhoto,
    required this.productCategory,
    required this.price,
    required this.avgUnitPrice,
    required this.createdAt,
    this.finishedAt,
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
      avgUnitPrice: doc.data()['avgUnitPrice'],
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
      'avgUnitPrice': avgUnitPrice,
      'createdAt': createdAt,
      'finishedAt': finishedAt,
      'status': status,
    };
  }
}
