import 'package:flutter/material.dart';

class PasswordTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String name;
  final Function onTap;
  final TextInputType keyboardType;

  const PasswordTextFormField({
    Key? key,
    required this.controller,
    required this.obscureText,
    required this.name,
    required this.onTap,
    required this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: name,
        suffixIcon: GestureDetector(
          onTap: () {
            onTap();
          },
          child: Icon(
            obscureText == true ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      keyboardType: keyboardType,
    );
  }
}
