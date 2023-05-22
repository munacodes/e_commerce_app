import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/model/modelExports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  List<Product> feature = [];
  Product? featureData;
  List<CartModel> cartModelList = [];
  CartModel? cartModel;
  List<CartModel> checkOutModelList = [];
  CartModel? checkOutModel;
  List<CartModel>? myCheckOut;
  List<UserModel> userModeList = [];
  UserModel? userModel;

  Future<void> getUserData() async {
    List<UserModel> newList = [];
    User currentUser = FirebaseAuth.instance.currentUser!;
    QuerySnapshot userSnapShot =
        await FirebaseFirestore.instance.collection('Users').get();
    userSnapShot.docs.forEach(
      (element) {
        if (currentUser.uid == element['UserId']) {
          userModel = UserModel(
            userEmail: element['UserEmail'],
            userGender: element['UserGender'],
            userName: element['UserName'],
            userPhoneNumber: element['Phone Number'],
          );
          newList.add(userModel!);
        }
        userModeList = newList;
      },
    );
  }

  List<UserModel> get getUserModelList {
    return userModeList;
  }

  void getCheckOutData({
    required int quantity,
    required double price,
    required String name,
    required String image,
  }) {
    checkOutModel = CartModel(
      price: price,
      name: name,
      image: image,
      quantity: quantity,
    );
    checkOutModelList.add(checkOutModel!);
  }

  List<CartModel> get getCheckOutModelList {
    return List.from(checkOutModelList);
  }

  int get getCheckOutModelListLength {
    return checkOutModelList.length;
  }

  void getCartData({
    required String name,
    required String image,
    required int quantity,
    required double price,
  }) {
    cartModel = CartModel(
      price: price,
      name: name,
      image: image,
      quantity: quantity,
    );
    cartModelList.add(cartModel!);
  }

  List<CartModel> get getCardModelList {
    return List.from(cartModelList);
  }

  int get getCardModelListLength {
    return cartModelList.length;
  }

  Future<void> getFeatureData() async {
    List<Product> newList = [];
    QuerySnapshot featureSnapShot = await FirebaseFirestore.instance
        .collection('products')
        .doc('86qW7GLuZTzoDa7HdRQD')
        .collection('featureproduct')
        .get();
    featureSnapShot.docs.forEach(
      (element) {
        featureData = Product(
            image: element['image'],
            name: element['name'],
            price: element['price']);
        newList.add(featureData!);
      },
    );
    feature = newList;
    notifyListeners();
  }

  List<Product> get getFeatureList {
    return feature;
  }

  List<Product> get getFeaturePiece {
    return List.from(feature);
  }

  List<Product> homeFeature = [];

  Future<void> getHomeFeatureData() async {
    List<Product> newList = [];
    QuerySnapshot featureSnapShot =
        await FirebaseFirestore.instance.collection('homefeature').get();
    featureSnapShot.docs.forEach(
      (element) {
        featureData = Product(
            image: element['image'],
            name: element['name'],
            price: element['price']);
        newList.add(featureData!);
      },
    );
    homeFeature = newList;
  }

  List<Product> get getHomeFeatureList {
    return homeFeature;
  }

  List<Product> homeAchive = [];

  Future<void> getHomeAchiveData() async {
    List<Product> newList = [];
    QuerySnapshot featureSnapShot =
        await FirebaseFirestore.instance.collection('homeachive').get();
    featureSnapShot.docs.forEach(
      (element) {
        featureData = Product(
            image: element['image'],
            name: element['name'],
            price: element['price']);
        newList.add(featureData!);
      },
    );
    homeAchive = newList;
  }

  List<Product> get getHomeAchiveList {
    return homeAchive;
  }

  List<Product> newAchives = [];
  late Product newAchivesData;
  Future<void> getNewAchivesData() async {
    List<Product> newList = [];
    QuerySnapshot achiveSnapShot = await FirebaseFirestore.instance
        .collection('products')
        .doc('86qW7GLuZTzoDa7HdRQD')
        .collection('newachives')
        .get();
    achiveSnapShot.docs.forEach(
      (element) {
        newAchivesData = Product(
            image: element['image'],
            name: element['name'],
            price: element['price']);
        newList.add(newAchivesData);
      },
    );
    newAchives = newList;
  }

  List<Product> get getNewAchivesList {
    return newAchives;
  }

  List<String> notificationList = [];
  void addNotification(String notification) {
    notificationList.add(notification);
  }

  int get getNotificationIndex {
    return notificationList.length;
  }
}
