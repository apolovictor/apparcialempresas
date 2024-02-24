import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  int? avgServiceTime;
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
    this.avgServiceTime,
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
      'avgServiceTime': avgServiceTime,
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
      avgServiceTime: doc.data()!['avgServiceTime'],
      status: doc.data()!['status'],
      documentId: doc.id,
    );
  }
}

class Categories {
  int? index;
  String name;
  String? icon;
  String? color;
  String? secondaryColor;
  bool? isSelected = false;
  String documentId;

  Categories({
    required this.index,
    required this.name,
    this.icon,
    this.color,
    this.secondaryColor,
    required this.documentId,
    this.isSelected,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'index': index,
      'name': name,
      'icon': icon,
      'color': color,
      'secondaryColor': secondaryColor,
      'isSelected': isSelected,
      'documentId': documentId,
    };
  }

  static Categories fromDoc(dynamic doc) {
    return Categories(
      index: doc.data()['index'],
      name: doc.data()['name'],
      icon: doc.data()['icon'],
      color: doc.data()['color'],
      secondaryColor: doc.data()['secondaryColor'],
      documentId: doc.id,
    );
  }
}

class ProductItem {
  int? index;
  Product product;
  double offset;
  bool? isActive;

  ProductItem({
    required this.index,
    required this.product,
    required this.offset,
    this.isActive,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'index': index,
      'product': product,
      'offset': offset,
      'isActive': isActive,
    };
  }

  static ProductItem fromDoc(dynamic doc) {
    return ProductItem(
      index: doc.data()['index'],
      product: doc.data()['product'],
      offset: doc.data()['offset'].toDouble(),
      isActive: doc.data()['isActive'],
    );
  }
}

class Filter {
  String? categories;
  int? status;

  Filter({
    this.categories,
    this.status,
  });
}

class UrlProduct {
  String title;
  String url;
  String category;

  UrlProduct({
    required this.title,
    required this.url,
    required this.category,
  });
}

class OffsetProduct {
  String documentId;
  Offset offSet;

  OffsetProduct({
    required this.documentId,
    required this.offSet,
  });
}
