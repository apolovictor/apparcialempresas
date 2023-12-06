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
  final String idTable;
  final List<Product> productsList;
  final int quantity;
  final Timestamp startDate;

  AddOrder(this.idDocument, this.clientName, this.idTable, this.productsList,
      this.quantity, this.startDate);
}
