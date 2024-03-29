import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/admin/adminLogin.dart';
import 'package:e_commerce_app/dialogBox/dialogBoxExpoets.dart';
import 'package:e_commerce_app/screens/screensExports.dart';
import 'package:e_commerce_app/screens/signUp.dart';
import 'package:e_commerce_app/widgets/widgetsExports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
// Invaild Email Strings/Letters
    String p =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(p);

    final FirebaseAuth auth = FirebaseAuth.instance;
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();

    qwer({required String name}) {
      return SnackBar(
        content: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xff746bc9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        behavior: SnackBarBehavior.floating,
      );
    }

    snackBar({required String name}) {
      return SnackBar(
        backgroundColor: const Color(0xff746bc9),
        content: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        //   behavior: SnackBarBehavior.floating,
      );
    }

    validation2() async {
      if (email.text.isEmpty && password.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('All Fields Are Empty'),
            backgroundColor: Color(0xff746bc9),
          ),
        );
      } else if (email.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Enter Email Address'),
            backgroundColor: Color(0xff746bc9),
          ),
        );
      } else if (!regExp.hasMatch(email.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Enter Valid Email'),
            backgroundColor: Color(0xff746bc9),
          ),
        );
      } else if (password.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Enter Password'),
            backgroundColor: Color(0xff746bc9),
          ),
        );
      } else if (_formKey.currentState!.validate()) {
        showDialog(
          context: context,
          builder: (c) {
            return const LoadingAlertDialog(
                message: 'Authenticating, Please wait....');
          },
        );
        final formState = _formKey.currentState;
        formState!.save();
        final UserCredential result = await auth.signInWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
        print(result.user!.uid);
      } else {
        try {
          final UserCredential result = await auth.signInWithEmailAndPassword(
            email: email.text,
            password: password.text,
          );
          if (FirebaseAuth.instance.currentUser != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          }
          print(result.user!.uid);
        } catch (e) {
          if (e is FirebaseAuthException) {
            FirebaseAuthException authException = e;
            switch (authException.code) {
              case 'invalid-email':
                break;
              case 'user-not-found':
                break;
              case 'wrong-password':
                break;
              default:
                final snackBar = SnackBar(
                  content: Text('Failed with error code: ${e.code.toString()}'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                break;
            }
          }
        }
      }
    }

    void validation() async {
      if (email.text.isEmpty && password.text.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar(name: 'Both Fields Are Empty'));
      } else if (email.text.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar(name: 'Enter Email'));
      } else if (!regExp.hasMatch(email.text)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar(name: 'Enter Valid Email'));
      } else if (password.text.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar(name: 'Enter Password'));
      } else if (password.text.length < 8) {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar(name: 'Password Is Too Short'));
      } else if (_formKey.currentState!.validate()) {
        try {
          final UserCredential result = await auth.signInWithEmailAndPassword(
            email: email.text,
            password: password.text,
          );
          print(result.user!.uid);
        } on FirebaseAuthException catch (e) {
          FirebaseAuthException authException = e;
          switch (authException.code) {
            case 'invalid-email':
              break;
            case 'user-not-found':
              break;
            case 'wrong-password':
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(snackBar(
                  name: 'Failed with error code: ${e.code.toString()}'));
              break;
          }
        }
      }
    }

    Widget _buildAllPart() {
      return Container(
        height: 350,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            MyTextFormField(
              name: 'Email',
              controller: email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            PasswordTextFormField(
              obscureText: obscureText,
              controller: password,
              name: 'Password',
              onTap: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  obscureText = !obscureText;
                });
              },
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            MyButton(
              name: 'Login',
              onPressed: () {
                validation2();
              },
            ),
            const SizedBox(height: 10),
            ChangeScreen(
              name: 'Register',
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SignUp(),
                  ),
                );
              },
              whichAccount: 'Don\'t Have An Account?',
            ),
            const SizedBox(height: 20),

            // Add Admin Login
            const Divider(
              thickness: 3.0,
              color: Colors.grey,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => const AdminLogin(),
                      /* ctx means or is a shortform of context*/
                    ),
                  );
                },
                child: Text(
                  'I am Admin',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      key: _scaffoldMessengerKey,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAllPart(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
