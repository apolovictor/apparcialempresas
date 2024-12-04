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

class Product {
  String categories;
  String primaryColor;
  String secondaryColor;
  String name;
  Price price;
  int quantity;
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
      quantity: doc.data()!['quantity'],
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
  double unitPrice; // Now nullable
  DateTime? date; // Already nullable
  int quantity; // Now nullable
  String? idDocument; // Now nullable

  Cogs({
    required this.unitPrice, // Nullable
    this.date, // Nullable
    required this.quantity, // Nullable
    this.idDocument, // Nullable
  });

  static Cogs fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Cogs(
      unitPrice: doc.get('unitPrice') != null
          ? (doc.get('unitPrice') as num).toDouble()
          : 0, // Safe conversion
      date: doc.get('date') != null
          ? timeStampToDate(doc.get('date') as Timestamp)
          : null, //Safe conversion for date
      quantity: doc.get('quantity') != null
          ? doc.get('quantity') as int
          : 0, //Safe conversion
      idDocument: doc.get('idDocument') != null
          ? doc.get('idDocument') as String
          : null, // Safe conversion
    );
  }
}

class ProductsSold {
  String productName;
  String productDocument;
  String productCategory;
  double price;
  DateTime? date;

  ProductsSold({
    required this.productName,
    required this.productDocument,
    required this.productCategory,
    required this.price,
    required this.date,
  });

  static ProductsSold fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ProductsSold(
      productName: doc['productName'],
      productDocument: doc['productDocument'],
      productCategory: doc['productCategory'],
      price: doc['price']!.toDouble(),
      date: timeStampToDate(doc['finishedAt']),
    );
  }
}

class CategoriesReportModel {
  final double total;
  final String productCategory;
  final Color color;
  CategoriesReportModel({
    required this.total,
    required this.productCategory,
    required this.color,
  });
}
