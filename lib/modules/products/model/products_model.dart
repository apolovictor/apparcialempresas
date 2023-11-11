import 'package:flutter/material.dart';

class Product {
  String categories;
  String primaryColor;
  String secondaryColor;
  String name;
  Map<String, dynamic> price;
  String quantity;
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
      'description': description,
      'photo_url': logo,
      'status': status,
      'documentId': documentId,
    };
  }

  static Product fromDoc(dynamic doc) {
    return Product(
      categories: doc.data()['categories'],
      primaryColor: doc.data()['color'],
      secondaryColor: doc.data()['secondaryColor'],
      name: doc.data()['name'],
      price: doc.data()['price'],
      quantity: doc.data()['quantity'],
      description: doc.data()['description'],
      logo: doc.data()['photo_url'],
      status: doc.data()['status'],
      documentId: doc.id,
    );
  }
}

class Categories {
  int? index;
  String name;
  String? color;
  String? icon;
  bool? isSelected = false;
  String documentId;

  Categories({
    required this.index,
    required this.name,
    this.icon,
    this.color,
    required this.documentId,
    this.isSelected,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'index': index,
      'name': name,
      'icon': icon,
      'color': color,
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
      offset: doc.data()['offset'],
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
