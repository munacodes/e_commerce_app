import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String? Function(dynamic value) validator;
  final Function(String? value) onChanged;
  final String name;
  final TextInputType? keyboardType;
  final Function(String? value) onSaved;

  final Function? onTap;

  const MyTextFormField({
    Key? key,
    required this.validator,
    required this.onChanged,
    required this.name,
    this.keyboardType,
    required this.onSaved,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onChanged: ((value) {
        onChanged(value);
      }),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: name,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      keyboardType: keyboardType,
      onSaved: ((value) {
        onSaved(value);
      }),
    );
  }
}
