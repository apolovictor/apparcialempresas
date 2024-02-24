import 'package:botecaria/modules/products/model/products_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/products_cache_model.dart';

class ProductInServices {
  final keyBox = Hive.box<ProductInServiceModel>('productsInService');

  addProduct(String idDocument, ProductInServiceModel productInService) {
    keyBox.put(idDocument, productInService);
  }

  getProduct(String idDocument) {
    return keyBox.get(idDocument);
  }

  getAllProduct() {
    var result = keyBox.values;

    return result;
  }

  deleteProduct(String idDocument) {
    keyBox.delete(idDocument);
  }

  deleteAllProduct() {
    keyBox.clear();
  }
}
