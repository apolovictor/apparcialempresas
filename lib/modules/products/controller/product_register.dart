import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class RegisterProduct extends ChangeNotifier {
  static String idDocument = "bandiis";

  Future<bool> registerProduct(String productName,
      Map<String, String> productPrice, String productQuantity) async {
    final businessCollection = _firestore.collection('business');

    try {
      // await businessCollection.doc(idDocument).collection("products").add({
      //   'name': productName,
      //   'price': {'price': productPrice, 'promo': productPromo},
      //   'quantity': productQuantity
      // });

      return true;
    } catch (e) {
      // print(e.message);
      return Future.error(e);
    }
  }
}

class CategoryProductController extends StateNotifier<String> {
  CategoryProductController() : super(categoryProduct);
  static String categoryProduct = "";

  fetchCategoryProduct(String categoryProduct) {
    state = categoryProduct;
    return state;
  }
}

class ImgXFileNotifier extends StateNotifier<XFile> {
  ImgXFileNotifier() : super(imgFile);

  static XFile imgFile = XFile("");

  void setImgFile(XFile imgFile) {
    state = imgFile;
  }

  void clear() {
    imgFile = XFile(
      "",
      mimeType: "",
      name: "",
      length: 0,
      bytes: Uint8List.fromList([]),
    );

    state = imgFile;
  }
}

class ImgConvertedNotifier extends StateNotifier<MemoryImage> {
  ImgConvertedNotifier() : super(imgFile);

  static MemoryImage imgFile = MemoryImage(Uint8List.fromList([]));

  void setImgFile(MemoryImage imgFile) {
    state = imgFile;
  }

  // void clear() {
  //   imgFile = MemoryImage(
  //     "",
  //     mimeType: "",
  //     name: "",
  //     length: 0,
  //     bytes: Uint8List.fromList([]),
  //   );

  //   state = imgFile;
  // }
}

final categoryProductNotifier =
    StateNotifierProvider<CategoryProductController, String>(
        (ref) => CategoryProductController());
final imgFileProvider =
    StateNotifierProvider<ImgXFileNotifier, XFile>((ref) => ImgXFileNotifier());
final imgConvertedProvider =
    StateNotifierProvider<ImgConvertedNotifier, MemoryImage>(
        (ref) => ImgConvertedNotifier());
final egisterProductProvider = Provider((ref) => RegisterProduct());
