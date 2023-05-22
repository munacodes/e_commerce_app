import 'package:flutter/material.dart';

class PasswordTextFormField extends StatelessWidget {
  final bool obscureText;
  final Function validator;
  final String name;
  final Function? onChanged;
  final Function onTap;
  final Function? onSaved;
  final TextInputType? keyboardType;

  const PasswordTextFormField({
    Key? key,
    required this.obscureText,
    required this.validator,
    required this.name,
    this.onChanged,
    required this.onTap,
    this.onSaved,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      validator: (value) {
        validator();
      },
      onChanged: (value) {
        onChanged!();
      },
      onSaved: (value) {
        onSaved!();
      },
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
