import 'package:e_commerce_app/screens/homePage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3)).then(
      (value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color(0xff746bc9),
      //   elevation: 0.0,
      // ),
      body: SafeArea(
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: const Color(0xff746bc9),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/Company Logo.png'),
                    width: 300,
                  ),
                  SizedBox(
                    height: 50,
                  ),
//                   final spinkit = SpinKitFadingCircle(
//   itemBuilder: (BuildContext context, int index) {
//     return DecoratedBox(
//       decoration: BoxDecoration(
//         color: index.isEven ? Colors.red : Colors.green,
//       ),
//     );
//   },
// );
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
