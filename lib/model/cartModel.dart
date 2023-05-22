import 'package:flutter/material.dart';

class CartModel {
  final String name;
  final String image;
  final double price;
  final int quantity;
  const CartModel(
      {required this.price,
      required this.name,
      required this.image,
      required this.quantity});
}
