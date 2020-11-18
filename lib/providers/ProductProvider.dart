import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductProvider extends ChangeNotifier {
  CollectionReference productsCollection =
      FirebaseFirestore.instance.collection("products");
  List<File> imagesToAdd = [];
  List<dynamic> imagesToDelete = [];
  List<Map<String, dynamic>> allImages = [];
  bool continueEditingMode = false;

  void addToAllImages(Map<String, dynamic> imgsData) {
    allImages.insert(0, imgsData);
    notifyListeners();
  }

  continueEditingModeSet(bool mode) {
    continueEditingMode = mode;
    notifyListeners();
  }

  void removeFromAllImages(bool file, String imgPath) {
    if (file) {
      allImages.removeWhere((img) => (img['path'] as File).path == imgPath);
    } else {
      allImages.removeWhere((img) => img["path"] == imgPath);
    }
    notifyListeners();
  }

//   void removeFromProductImages(File img) async {
// // TODO: mistake here fix it
//     (productData["images"] as List).removeWhere((element) {
//       String ref = "";
//       FirebaseStorage.instance.getReferenceFromUrl(element).then((value) {
//         print("@@@@@@@@");
//         print(element);
//         print(getImageNameFromImageFile(img));
//         print(value.path);
//         print("@@@@@@@@");
//         ref = value.path.split("/").last;
//       });
//       return ref == getImageNameFromImageFile(img);
//     });
//     notifyListeners();
//   }

  Map<String, dynamic> productData = {
    "name": "",
    "quantity": "",
    "unit": "",
    "amount": "",
    "bulkPrices": "",
    "section": "",
    "category": "",
    "desc": "",
    "images": [],
  };

  Map<String, dynamic> get formValues {
    return productData;
  }

  Future<Map<String, dynamic>> prefillFormValues(prodId) async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("products")
        .doc(prodId)
        .get();
    Map<String, dynamic> data = snapshot.data();
    int imagesLength = data["images"] == null || data["images"] == ""
        ? 0
        : data["images"].length;
    for (var i = 0; i < imagesLength; i++) {
      allImages.insert(0, {"path": data["images"][i], "file": false});
    }
    productData = data;
    notifyListeners();
    return data;
  }

  void addToAddImgsList(File img) {
    imagesToAdd.insert(0, img);
    notifyListeners();
  }

  void delFromAddImgsList(File imageToRemove) {
    imagesToAdd.removeWhere((img) => img.path == imageToRemove.path);
    notifyListeners();
  }

  void addToDelImgsList(String img) {
    imagesToDelete.add(img as dynamic);
    notifyListeners();
  }

  String getImageNameFromImageFile(File fileName) {
    return fileName.path.split("/").last;
  }

  Future<void> updateProduct(String productId) async {
    for (var i = 0; i < (productData['images'] as List).length; i++) {
      for (var j = 0; j < imagesToDelete.length; j++) {
        if (productData['images'][i] == imagesToDelete[j]) {
          (productData['images'] as List).removeAt(i);
        }
      }
    }
    await deleteImagesFromFirebase();
    await addImagesToFirebase();
    await productsCollection
        .doc(productId)
        .update(productData)
        .then((value) {})
        .catchError((err) => print(err));
  }

  // add images to firebase
  Future addImagesToFirebase() async {
    for (var i = 0; i < imagesToAdd.length; i++) {
      dynamic imageUrl = await addImageToFirebase(imagesToAdd[i]);
      (productData['images'] as List).insert(0, imageUrl);
    }
  }

  // delete images to firebase
  Future<void> deleteImagesFromFirebase() async {
    try {
      for (var i = 0; i < imagesToDelete.length; i++) {
        productsCollection
            .where("images", arrayContainsAny: [imagesToDelete[i]])
            .get()
            .then((value) {
              if (value.docs.length == 1 || value.docs.length < 1) {
                deleteImageFromFirebase(imagesToDelete[i]);
              }
              (productData["images"] as List)
                  .removeWhere((element) => element == imagesToDelete[i]);
              notifyListeners();
            });
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> addNewProduct() async {
    await addImagesToFirebase();
    await productsCollection
        .add(productData)
        .then((value) => print(value))
        .catchError((e) => print(e));
  }

  void setProductValues(Map<String, dynamic> data) {
    productData.forEach((
      key,
      value,
    ) {
      data.forEach((key2, value2) {
        if (key == key2) {
          productData[key] = value2;
        }
      });
      notifyListeners();
      print("@@@@@@@@@@@@ productData images @@@@@@@@@@@@@@@@@@");
      print(productData["images"]);
      print("@@@@@@@@@@@@ productData images end @@@@@@@@@@@@@@@@@@");
    });
  }

  deleteImageFromFirebase(String imageUrl) async {
    try {
      final ref = await FirebaseStorage.instance.getReferenceFromUrl(imageUrl);
      await ref.delete();
    } catch (e) {
      print("error");
    }
  }

  Future<dynamic> addImageToFirebase(File media) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("images/products/")
        .child("${getImageNameFromImageFile(media)}");
    await ref.putFile(media).onComplete;
    final url = await ref.getDownloadURL();
    return url;
  }

  void clearAll() {
    imagesToAdd = [];
    imagesToDelete = [];
    allImages = [];
    productData = {
      "name": "",
      "quantity": "",
      "unit": "",
      "amount": "",
      "bulkPrices": "",
      "section": "",
      "category": "",
      "desc": "",
      "images": [],
    };
    notifyListeners();
    print("i am called --- clear all function");
  }
}
