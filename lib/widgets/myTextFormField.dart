import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String name;
  final TextInputType keyboardType;

  const MyTextFormField({
    Key? key,
    required this.controller,
    required this.name,
    required this.keyboardType,
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
    );
  }
}
