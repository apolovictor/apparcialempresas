class Product {
  String idDocumentCategory;
  String name;
  Map<String, String> price;
  String quantity;
  String? description;
  String? logo;
  int status;

  Product({
    required this.idDocumentCategory,
    required this.name,
    required this.price,
    required this.quantity,
    this.description,
    this.logo,
    required this.status,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'idDocumentCategory': idDocumentCategory,
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
      idDocumentCategory: doc.data()['idDocumentCategory'],
      name: doc.data()['name'],
      price: doc.data()['price'],
      quantity: doc.data()['quantity'],
      description: doc.data()['description'],
      logo: doc.data()['photo_url'],
      status: doc.data()['status'],
    );
  }
}
