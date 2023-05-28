import 'package:e_commerce_app/provider/providerExports.dart';
import 'package:e_commerce_app/screens/SignUp.dart';
import 'package:e_commerce_app/screens/screensExports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const WelcomeScreen();
        } else if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const Login();
        }
      },
    );
  }
}
