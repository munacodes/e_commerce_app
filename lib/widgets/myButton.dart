import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final Function onPressed;
  final String name;
  const MyButton({
    Key? key,
    required this.name,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color(0xff746bc9),
          ),
        ),
        onPressed: () {
          widget.onPressed();
        },
        child: Text(
          widget.name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
