import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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

class NetworkErrorDialog extends StatelessWidget {
  const NetworkErrorDialog({Key? key, this.onPressed}) : super(key: key);

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 200,
            child: Image.asset('assets/images/no_connection.png'),
          ),
          const SizedBox(height: 32),
          const Text(
            "Whoops!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            "No internet connection found.",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "Check your connection and try again.",
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text("Try Again"),
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}
