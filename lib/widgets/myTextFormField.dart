import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? name;

  final TextInputType? keyboardType;
  final bool? obscureText;

  const MyTextFormField({
    Key? key,
    this.controller,
    this.name,
    this.keyboardType,
    this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: name,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      keyboardType: keyboardType,
      obscureText: true,
    );
  }
}
