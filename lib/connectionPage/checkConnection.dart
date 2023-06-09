import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:e_commerce_app/connectionPage/connectionPageExports.dart';

class CheckConnectionPage extends StatelessWidget {
  const CheckConnectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Check Connection Page")),
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            child: const Text("Check Connection"),
            onPressed: () async {
              final connectivityResult =
                  await Connectivity().checkConnectivity();
              if (connectivityResult == ConnectivityResult.none) {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) => NetworkErrorDialog(
                    onPressed: () async {
                      final connectivityResult =
                          await Connectivity().checkConnectivity();
                      if (connectivityResult == ConnectivityResult.none) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Please turn on your wifi or mobile data'),
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'You\'re connected to a ${connectivityResult.name} network'),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
