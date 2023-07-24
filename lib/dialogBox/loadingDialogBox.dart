import 'package:e_commerce_app/widgets/widgetsExports.dart';
import 'package:flutter/material.dart';

class LoadingAlertDialog extends StatelessWidget {
  final String message;
  const LoadingAlertDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          circularProgress(),
          const SizedBox(
            height: 10,
          ),
          Text(message),
        ],
      ),
    );
  }
}
