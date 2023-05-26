import 'package:cloud_firestore/cloud_firestore.dart';
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

    FirebaseAuth auth = FirebaseAuth.instance;
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();

// A popup message that displays at the bottom of the screen using scaffoldMessengerKey
    const snackBarValid = SnackBar(
      content: Center(
        child: Text(
          'Processing...',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Color(0xff746bc9),
      shape: StadiumBorder(),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 100, left: 100),
      behavior: SnackBarBehavior.floating,
      duration: Duration(
        seconds: 1,
      ),
    );

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
        _scaffoldMessengerKey.currentState!.showSnackBar(
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
        bool isvalid;
        isvalid = _formKey.currentState!.validate();
        print(isvalid);
        if (isvalid) {
          _formKey.currentState!.save();
          ScaffoldMessenger.of(context).showSnackBar(snackBarValid);
          try {
            final UserCredential result = await auth.signInWithEmailAndPassword(
              email: email.text,
              password: password.text,
            );
            print(result.user!.uid);
          } on FirebaseAuthException catch (e) {
            _scaffoldMessengerKey.currentState!.showSnackBar(
              SnackBar(
                content: Text('Failed with error code: ${e.code.toString()}'),
              ),
            );
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
              obscureText: true,
              controller: password,
              onTap: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  //obscureText = !obscureText;
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
              whichAccount: 'Dont Have An Account?',
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
