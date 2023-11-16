import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;

class RegisterProduct extends ChangeNotifier {
  static String idDocument = "bandiis";

  Future<bool> registerProduct(
      String productName,
      Map<String, String> productPrice,
      String productQuantity,
      String color,
      String secondaryColor,
      String category,
      MemoryImage imgProduct,
      WidgetRef ref) async {
    final businessCollection = _firestore.collection('business');

    try {
      // print(productName);
      // print(productPrice);
      // print(productQuantity);
      // print(color);
      // print(secondaryColor);
      // print(category);

      await businessCollection.doc(idDocument).collection("products").add({
        'name': productName,
        'categories': category,
        'price': productPrice,
        'quantity': productQuantity,
        'color': color,
        'secondaryColor': secondaryColor,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 1
      }).then((product) async {
        var storageReference = storage.ref('products/${product.id}');
        TaskSnapshot result = await storageReference.putData(
            imgProduct.bytes, SettableMetadata(contentType: 'image/png'));
        // String imageUri = await result.ref.getDownloadURL();
        var imageProduct = await result.ref.getMetadata();
        if (imageProduct.name.isNotEmpty) {
          print("hereee");
          ref
              .read(lastProductNotifier.notifier)
              .lastProductingImg(imageProduct.name);
          await businessCollection
              .doc(idDocument)
              .collection("products")
              .doc(product.id)
              .update(<String, String>{'photo_url': imageProduct.name});
        }
      });

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

  clear() {
    state = "";
  }
}

class IsReloadingImgController extends StateNotifier<bool> {
  IsReloadingImgController() : super(isReload);
  static bool isReload = false;

  isReloadingImg(bool isReload) {
    state = isReload;
    return state;
  }
}

class LastProductIdController extends StateNotifier<String> {
  LastProductIdController() : super(lastProduct);
  static String lastProduct = "";

  lastProductingImg(String lastProduct) {
    state = lastProduct;
    return state;
  }

  void clearLastProduct() {
    state = "";
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

  void clear() {
    state = MemoryImage(Uint8List.fromList([]));
  }
}

final categoryProductNotifier =
    StateNotifierProvider<CategoryProductController, String>(
        (ref) => CategoryProductController());
final isReloagingImgNotifier =
    StateNotifierProvider<IsReloadingImgController, bool>(
        (ref) => IsReloadingImgController());
final lastProductNotifier =
    StateNotifierProvider<LastProductIdController, String>(
        (ref) => LastProductIdController());
final imgFileProvider =
    StateNotifierProvider<ImgXFileNotifier, XFile>((ref) => ImgXFileNotifier());
final imgConvertedProvider =
    StateNotifierProvider<ImgConvertedNotifier, MemoryImage>(
        (ref) => ImgConvertedNotifier());
final registerProductProvider = Provider((ref) => RegisterProduct());
