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

  // Future<bool> registerProduct(
  //   String productName,
  //   Map<String, double> productPrice,
  //   int productQuantity,
  //   String color,
  //   String secondaryColor,
  //   String category,
  //   double unityPrice,
  //   Uint8List imgBytes, // Accept Uint8List directly
  // ) async {
  //   print("unityPrice === $unityPrice");
  //   final businessCollection = _firestore.collection('business');

  //   try {
  //     final batch = FirebaseFirestore.instance.batch();

  //     final result =
  //         await businessCollection.doc(idDocument).collection("products").add({
  //       'name': productName,
  //       'categories': category,
  //       'price': productPrice,
  //       'avgUnitPrice': unityPrice,
  //       'quantity': productQuantity,
  //       'color': color,
  //       'secondaryColor': secondaryColor,
  //       'createdAt': FieldValue.serverTimestamp(),
  //       'status': 1
  //     }).then((product) async {
  //       var storageReference = storage.ref('products/${product.id}');
  //       await storageReference
  //           .putData(imgBytes, SettableMetadata(contentType: 'image/png'))
  //           .then((updateProduct) async {
  //         var imageProduct = await updateProduct.ref.getMetadata();

  //         print('imageProduct.name ===== ${imageProduct.name}   ');
  //         if (imageProduct.name.isNotEmpty) {
  //           await businessCollection
  //               .doc(idDocument)
  //               .collection("products")
  //               .doc(product.id)
  //               .update(<String, String>{'photo_url': imageProduct.name});
  //         }
  //         return product;
  //       });
  //       // String imageUri = await result.ref.getDownloadURL();
  //     });

  //     final stockRef = businessCollection
  //         .doc(idDocument)
  //         .collection("products")
  //         .doc(result.id)
  //         .collection("stockTransactions")
  //         .doc();

  //     batch.set(stockRef, {
  //       'type': 'in',
  //       'quantity': productQuantity,
  //       'unitPrice': unityPrice,
  //       'date': FieldValue.serverTimestamp()
  //     });

  //     return true;
  //   } catch (e) {
  //     // print(e.message);
  //     return Future.error(e);
  //   }
  // }

  Future<bool> registerProduct(
    String productName,
    Map<String, double> productPrice,
    int productQuantity,
    String color,
    String secondaryColor,
    String category,
    double unityPrice, // This parameter seems unused. Consider removing it.
    Uint8List imgBytes,
  ) async {
    final businessCollection = _firestore.collection('business');

    try {
      final batch = _firestore.batch(); // Create the batch

      // Step 1 & 3 Combined: Add product with placeholder for photo_url
      final productRef = businessCollection
          .doc(idDocument)
          .collection("products")
          .doc(); // Create doc ref first
      batch.set(productRef, {
        'name': productName,
        'categories': category,
        'price': productPrice,
        'avgUnitPrice': unityPrice,
        'quantity': productQuantity,
        'color': color,
        'secondaryColor': secondaryColor,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 1,
        'photo_url': '', // Placeholder, we'll update it later
      });

      // Step 2 and update 3 : Upload image and update the product document
      final storageRef = storage.ref('products/${productRef.id}');
      final uploadTask = storageRef.putData(
          imgBytes, SettableMetadata(contentType: 'image/png'));
      final snapshot = await uploadTask;
      final downloadURL = await snapshot.ref.getMetadata();
      batch.update(productRef, {'photo_url': downloadURL.name});

      // Step 3: Create stock transaction subcollection (using the now available productRef.id)
      final stockRef = productRef
          .collection("stockTransactions")
          .doc(); // Use productRef to create subcollection ref
      batch.set(stockRef, {
        'type': 'in',
        'quantity': productQuantity,
        'unitPrice': unityPrice,
        'date': FieldValue.serverTimestamp(),
      });

      await batch.commit(); // Commit the batch
      return true;
    } catch (e) {
      print('Error registering product: $e'); // Log the error for debugging
      return false;
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
