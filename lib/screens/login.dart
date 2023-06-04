import 'package:cloud_firestore/cloud_firestore.dart';
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

    void validation() async {
      if (email.text.isEmpty && password.text.isEmpty) {
        _scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(
            content: Text('Both Field Are Empty'),
            backgroundColor: Color(0xff746bc9),
          ),
        );
      } else if (email.text.isEmpty) {
        _scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(
            content: Text("Email Is Empty"),
            backgroundColor: Color(0xff746bc9),
          ),
        );
      } else if (!regExp.hasMatch(email.text)) {
        _scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(
            content: Text('Please Try Valid Email'),
            backgroundColor: Color(0xff746bc9),
          ),
        );
      } else if (password.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password Is Empty'),
            backgroundColor: Color(0xff746bc9),
          ),
        );
      } else if (password.text.length < 8) {
        _scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(
            content: Text('Password Is Too Short'),
            backgroundColor: Color(0xff746bc9),
          ),
        );
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
            // Handle FirebaseAuthException
            FirebaseAuthException authException = e;
            // Handle different error codes or scenarios
            switch (authException.code) {
              case 'invalid-email':
                // Handle invalid email error
                break;
              case 'user-not-found':
                // Handle user not found error
                break;
              case 'wrong-password':
                // Handle wrong password error
                break;
              // Add more cases as needed
              default:
                // Handle other FirebaseAuthException errors
                break;
            }
          } else {
            // Handle other types of exceptions or errors
          }
        }

        // on FirebaseAuthException catch (e) {
        //   _scaffoldMessengerKey.currentState!.showSnackBar(
        //     SnackBar(
        //       content: Text('Failed with error code: ${e.code.toString()}'),
        //     ),
        //   );
        // }
//        try {
        // Code that may throw a FirebaseAuthException
// } catch (e) {
//   if (e is FirebaseAuthException) {
//     // Handle FirebaseAuthException
//     FirebaseAuthException authException = e;
//     // Handle different error codes or scenarios
//     switch (authException.code) {
//       case 'invalid-email':
//         // Handle invalid email error
//         break;
//       case 'user-not-found':
//         // Handle user not found error
//         break;
//       case 'wrong-password':
//         // Handle wrong password error
//         break;
//       // Add more cases as needed
//       default:
//         // Handle other FirebaseAuthException errors
//         break;
//     }
//   } else {
//     // Handle other types of exceptions or errors
//   }
// }
      }
    }

    Widget _buildAllPart() {
      return Container(
        height: 350,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            MyTextFormField(
              name: 'Email',
              controller: email,
              keyboardType: TextInputType.emailAddress,
            ),
            PasswordTextFormField(
              obscureText: obscureText,
              controller: password,
              onTap: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  obscureText = !obscureText;
                });
              },
              name: 'Password',
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
            ),
            MyButton(
              name: 'Login',
              onPressed: () {
                validation();
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (context) => const HomePage(),
                //   ),
                // );
              },
            ),
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
            margin: const EdgeInsets.symmetric(horizontal: 10),
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
