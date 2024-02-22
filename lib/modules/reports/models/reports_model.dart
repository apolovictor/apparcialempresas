import 'package:botecaria/services/date_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalesModel {
  final DateTime dateTime;
  final double total;

  SalesModel({required this.dateTime, required this.total});
}

class SalesReport {
  final double total;
  final Timestamp date;

  SalesReport({required this.total, required this.date});

  static SalesReport fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return SalesReport(
      total: doc.data()!['total'].toDouble(),
      date: doc.data()!['finishedAt'],
    );
  }
}

final dataset = [
  Data("JAN", 1500, 1000, 800, 0),
  Data("FEB", 500, 800, 1000, 1000),
  Data("MAR", 1000, 2800, 700, 500),
  Data("APR", 1500, 2400, 300, 500),
  Data("MAY", 1200, 2000, 800, 400),
  Data("JUN", 2500, 500, 400, 600),
  Data("JUL", 1500, 1000, 600, 300),
  Data("AUG", 500, 2000, 300, 300),
];

class Data {
  final String monthName;
  final double food;
  final double medical;
  final double travel;
  final double others;

  Data(
    this.monthName,
    this.food,
    this.medical,
    this.travel,
    this.others,
  );

  Map<dynamic, dynamic> toMap() {
    return {
      'productName': monthName,
      'productCmv': food,
      'productCurrentStock': medical,
      'productSales': travel,
      'productFutureSales': others,
    };
  }
}

class Product {
  String categories;
  String primaryColor;
  String secondaryColor;
  String name;
  Price price;
  double quantity;
  double? avgUnitPrice;
  String? description;
  String? logo;
  int status;
  String? documentId;

  Product({
    required this.categories,
    required this.primaryColor,
    required this.secondaryColor,
    required this.name,
    required this.price,
    required this.quantity,
    this.avgUnitPrice,
    this.description,
    this.logo,
    required this.status,
    this.documentId,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'categories': categories,
      'color': primaryColor,
      'secondaryColor': secondaryColor,
      'name': name,
      'price': price,
      'quantity': quantity,
      'avgUnitPrice': avgUnitPrice,
      'description': description,
      'photo_url': logo,
      'status': status,
      'documentId': documentId,
    };
  }

  static Product fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Product(
      categories: doc.data()!['categories'],
      primaryColor: doc.data()!['color'],
      secondaryColor: doc.data()!['secondaryColor'],
      name: doc.data()!['name'],
      price: Price.fromDoc(doc.data()!['price']),
      quantity: doc.data()!['quantity'].toDouble(),
      avgUnitPrice: doc.data()!['avgUnitPrice'].toDouble(),
      description: doc.data()!['description'],
      logo: doc.data()!['photo_url'],
      status: doc.data()!['status'],
      documentId: doc.id,
    );
  }
}

class Price {
  double price;
  double? promo;

  Price({
    required this.price,
    this.promo,
  });

  static Price fromDoc(Map<String, dynamic> doc) {
    return Price(
      price: doc['price']!.toDouble(),
      promo: doc['promo'].toDouble(),
    );
  }
}

class Cogs {
  double unitPrice;
  DateTime? date;
  int quantity;
  String idDocument;

  Cogs({
    required this.unitPrice,
    required this.date,
    required this.quantity,
    required this.idDocument,
  });

  static Cogs fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Cogs(
      unitPrice: doc['unitPrice']!.toDouble(),
      date: timeStampToDate(doc['date']),
      quantity: doc['quantity'],
      idDocument: doc['idDocument'],
    );
  }
}

class ProductsSold {
  String productName;
  String productDocument;
  double price;
  DateTime? date;

  ProductsSold({
    required this.productName,
    required this.productDocument,
    required this.price,
    required this.date,
  });

  static ProductsSold fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ProductsSold(
      productName: doc['productName'],
      productDocument: doc['productDocument'],
      price: doc['price']!.toDouble(),
      date: timeStampToDate(doc['finishedAt']),
    );
  }
}
