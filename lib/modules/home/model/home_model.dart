class Business {
  String name;
  String cnpj;
  String ceo;
  String email;
  String logo;

  Business({
    required this.name,
    required this.cnpj,
    required this.ceo,
    required this.email,
    required this.logo,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'name': name,
      'cnpj': cnpj,
      'ceo': ceo,
      'email': email,
      'photo_url': logo,
    };
  }

  static Business fromDoc(dynamic doc) {
    return Business(
      name: doc.data()['name'],
      cnpj: doc.data()['cnpj'],
      ceo: doc.data()['ceo'],
      email: doc.data()['email'],
      logo: doc.data()['photo_url'],
    );
  }
}
