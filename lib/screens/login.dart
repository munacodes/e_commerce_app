import 'package:e_commerce_app/screens/signUp.dart';
import 'package:e_commerce_app/widgets/widgetsExports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

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
    var email;
    var username;
    var password;
    var phoneNumber;

    bool obscureText = true;

// A popup message that displays at the bottom of the screen using scaffoldMessengerKey
    const snackBarValid = SnackBar(
      content: Center(
        child: Text(
          'Successful',
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

    void _validation() async {
      bool isvalid;
      isvalid = _formKey.currentState!.validate();
      print(isvalid);
      if (isvalid) {
        _formKey.currentState!.save();
        ScaffoldMessenger.of(context).showSnackBar(snackBarValid);

        try {
          final UserCredential result = await auth.signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
        } on FirebaseAuthException catch (e) {
          print('Failed with error code: ${e.code}');
          print(e.message);
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
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "Field Is Empty";
                } else if (!regExp.hasMatch(value)) {
                  return "Please Enter A Valid Email";
                }
                {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                email = value;
              },
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "Field Is Empty";
                } else if (value.length < 8) {
                  return "Password must have at least 8 characters";
                }
                {
                  return null;
                }
              },
              onChanged: (value) {
                password = value;
                print(password);
              },
              obscureText: obscureText,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: const TextStyle(
                  color: Colors.black,
                ),
                border: const OutlineInputBorder(),
                suffixIcon: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  child: Icon(
                    obscureText == true
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                ),
              ),
              onSaved: (value) {
                password = value;
              },
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
            ),
            MyButton(
              name: 'Login',
              onPressed: () {
                _validation();
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
