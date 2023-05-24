import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/model/modelExports.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  List<Product> shirt = [];
  Product? shirtData;
  List<Product> dress = [];
  Product? dressData;
  List<Product> shoes = [];
  Product? shoesData;
  List<Product> pant = [];
  Product? pantData;
  List<Product> tie = [];
  Product? tieData;

  List<CategoryIcon> dressIcon = [];
  CategoryIcon? dressIconData;
  Future<void> getDressIconData() async {
    List<CategoryIcon> newList = [];
    QuerySnapshot dressSnapShot = await FirebaseFirestore.instance
        .collection('categoryicon')
        .doc('EJPasr04B7gaDxa0IWfi')
        .collection('dress')
        .get();
    dressSnapShot.docs.forEach(
      (element) {
        dressIconData = CategoryIcon(image: element['image']);
        newList.add(dressIconData!);
      },
    );
    dressIcon = newList;
    notifyListeners();
  }

  List<CategoryIcon> get getDressIcon {
    return dressIcon;
  }

  List<CategoryIcon> shirtIcon = [];
  CategoryIcon? shirtIconData;
  Future<void> getShirtIconData() async {
    List<CategoryIcon> newList = [];
    QuerySnapshot shirtSnapShot = await FirebaseFirestore.instance
        .collection('categoryicon')
        .doc('EJPasr04B7gaDxa0IWfi')
        .collection('shirt')
        .get();
    shirtSnapShot.docs.forEach(
      (element) {
        shirtIconData = CategoryIcon(image: element['image']);
        newList.add(shirtIconData!);
      },
    );
    shirtIcon = newList;
    notifyListeners();
  }

  List<CategoryIcon> get getShirtIcon {
    return shirtIcon;
  }

  List<CategoryIcon> shoesIcon = [];
  CategoryIcon? shoesIconData;
  Future<void> getShoesIconData() async {
    List<CategoryIcon> newList = [];
    QuerySnapshot shoesSnapShot = await FirebaseFirestore.instance
        .collection('categoryicon')
        .doc('EJPasr04B7gaDxa0IWfi')
        .collection('shoes')
        .get();
    shoesSnapShot.docs.forEach(
      (element) {
        shoesIconData = CategoryIcon(image: element['image']);
        newList.add(shoesIconData!);
      },
    );
    shoesIcon = newList;
    notifyListeners();
  }

  List<CategoryIcon> get getShoeIcon {
    return shoesIcon;
  }

  List<CategoryIcon> pantIcon = [];
  CategoryIcon? pantIconData;
  Future<void> getPantIconData() async {
    List<CategoryIcon> newList = [];
    QuerySnapshot pantSnapShot = await FirebaseFirestore.instance
        .collection('categoryicon')
        .doc('EJPasr04B7gaDxa0IWfi')
        .collection('pant')
        .get();
    pantSnapShot.docs.forEach(
      (element) {
        pantIconData = CategoryIcon(image: element['image']);
        newList.add(pantIconData!);
      },
    );
    pantIcon = newList;
    notifyListeners();
  }

  List<CategoryIcon> get getPantIcon {
    return pantIcon;
  }

  List<CategoryIcon> tieIcon = [];
  CategoryIcon? tieIconData;
  Future<void> getTieIconData() async {
    List<CategoryIcon> newList = [];
    QuerySnapshot tieSnapShot = await FirebaseFirestore.instance
        .collection('categoryicon')
        .doc('EJPasr04B7gaDxa0IWfi')
        .collection('tie')
        .get();
    tieSnapShot.docs.forEach(
      (element) {
        tieIconData = CategoryIcon(image: element['image']);
        newList.add(tieIconData!);
      },
    );
    tieIcon = newList;
    notifyListeners();
  }

  List<CategoryIcon> get getTieIcon {
    return tieIcon;
  }

  Future<void> getShirtData() async {
    List<Product> newList = [];
    QuerySnapshot shirtSnapShot = await FirebaseFirestore.instance
        .collection('category')
        .doc('gdmsJAqm1gihcpfrn2c4')
        .collection('shirt')
        .get();
    shirtSnapShot.docs.forEach(
      (element) {
        shirtData = Product(
            image: element['image'],
            name: element['name'],
            price: element['price']);
        newList.add(shirtData!);
      },
    );
    shirt = newList;
    notifyListeners();
  }

  // List<Product> searchShirtList(String query) {
  //  return List<Product> searchShirt = shirt.where((element) {
  //     return element.name.toUpperCase().contains(query) ||
  //         element.name.toLowerCase().contains(query);
  //   }).toList();
  //   return searchShirt;
  // }

  List<Product> get getShirtList {
    return shirt;
  }

  Future<void> getDressData() async {
    List<Product> newList = [];
    QuerySnapshot shirtSnapShot = await FirebaseFirestore.instance
        .collection('category')
        .doc('gdmsJAqm1gihcpfrn2c4')
        .collection('dress')
        .get();
    shirtSnapShot.docs.forEach(
      (element) {
        shirtData = Product(
            image: element['image'],
            name: element['name'],
            price: element['price']);
        newList.add(shirtData!);
      },
    );
    dress = newList;
    notifyListeners();
  }

  List<Product> get getDressList {
    return dress;
  }

  Future<void> getShoesData() async {
    List<Product> newList = [];
    QuerySnapshot shirtSnapShot = await FirebaseFirestore.instance
        .collection('category')
        .doc('gdmsJAqm1gihcpfrn2c4')
        .collection('shoes')
        .get();
    shirtSnapShot.docs.forEach(
      (element) {
        shirtData = Product(
            image: element['image'],
            name: element['name'],
            price: element['price']);
        newList.add(shirtData!);
      },
    );
    shoes = newList;
    notifyListeners();
  }

  List<Product> get getshoesList {
    return shoes;
  }

  Future<void> getPantData() async {
    List<Product> newList = [];
    QuerySnapshot shirtSnapShot = await FirebaseFirestore.instance
        .collection('category')
        .doc('gdmsJAqm1gihcpfrn2c4')
        .collection('pant')
        .get();
    shirtSnapShot.docs.forEach(
      (element) {
        shirtData = Product(
            image: element['image'],
            name: element['name'],
            price: element['price']);
        newList.add(shirtData!);
      },
    );
    pant = newList;
    notifyListeners();
  }

  List<Product> get getPantList {
    return pant;
  }

  Future<void> getTieData() async {
    List<Product> newList = [];
    QuerySnapshot shirtSnapShot = await FirebaseFirestore.instance
        .collection('category')
        .doc('gdmsJAqm1gihcpfrn2c4')
        .collection('tie')
        .get();
    shirtSnapShot.docs.forEach(
      (element) {
        shirtData = Product(
            image: element['image'],
            name: element['name'],
            price: element['price']);
        newList.add(shirtData!);
      },
    );
    tie = newList;
    notifyListeners();
  }

  List<Product> get getTieList {
    return tie;
  }
}
