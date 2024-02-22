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
