class Product {
  String categories;
  String name;
  Map<String, dynamic> price;
  String quantity;
  String? description;
  String? logo;
  int status;

  Product({
    required this.categories,
    required this.name,
    required this.price,
    required this.quantity,
    this.description,
    this.logo,
    required this.status,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'categories': categories,
      'name': name,
      'price': price,
      'quantity': quantity,
      'description': description,
      'photo_url': logo,
      'status': status,
    };
  }

  static Product fromDoc(dynamic doc) {
    return Product(
      categories: doc.data()['categories'],
      name: doc.data()['name'],
      price: doc.data()['price'],
      quantity: doc.data()['quantity'],
      description: doc.data()['description'],
      logo: doc.data()['photo_url'],
      status: doc.data()['status'],
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
