import 'package:flutter/material.dart';

class UserModel {
  String? userName;
  String? userEmail;
  String? userGender;
  String? userPhoneNumber;
  String? userImage;
  String? userAddress;
  UserModel({
    this.userEmail,
    this.userGender,
    this.userName,
    this.userPhoneNumber,
    this.userImage,
    this.userAddress,
  });
}
