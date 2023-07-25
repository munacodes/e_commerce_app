import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/admin/adminLogin.dart';
import 'package:e_commerce_app/dialogBox/dialogBoxExpoets.dart';
import 'package:e_commerce_app/screens/screensExports.dart';
import 'package:e_commerce_app/widgets/widgetsExports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

bool obscureText = true;
bool isMale = true;
final TextEditingController email = TextEditingController();
final TextEditingController phoneNumber = TextEditingController();
final TextEditingController password = TextEditingController();
final TextEditingController userName = TextEditingController();
final TextEditingController address = TextEditingController();

// Invaild Email Strings/Letters
String p =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
RegExp regExp = RegExp(p);

class _SignUpState extends State<SignUp> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();

  // TODO: Instead of using snackbar widget use flutterToast widget
  // flutterToast(msg:'All Fields are Empty');

  void validation() async {
    showDialog(
      context: context,
      builder: (c) {
        return const LoadingAlertDialog(
            message: 'Authenticating, Please wait....');
      },
    );
    if (userName.text.isEmpty &&
        email.text.isEmpty &&
        password.text.isEmpty &&
        phoneNumber.text.isEmpty &&
        address.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All Field Are Empty'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else if (userName.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Name Must Be 6'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else if (email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email Is Empty"),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else if (!regExp.hasMatch(email.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Try Valid Email'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else if (password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password Is Empty'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else if (password.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password Is Too Short'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else if (phoneNumber.text.length < 11 || phoneNumber.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone Number Must Be 11'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else if (address.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Address Is Empty'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else if (_formKey.currentState!.validate()) {
      final snackBar = SnackBar(
        content: Text('Successful'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      try {
        UserCredential result =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
        FirebaseFirestore.instance
            .collection('Users')
            .doc(result.user!.uid)
            .set({
          'UserName': userName.text,
          'UserId': result.user!.uid,
          'UserEmail': email.text,
          'UserAddress': address.text,
          'UserGender': isMale == true ? 'Male' : 'Female',
          'UserPhoneNumber': phoneNumber.text,
        });
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed with error code: ${e.code.toString()}'),
                ),
              );
              break;
          }
        }
      }
    }
  }

  Widget _buildAllTextFormField() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MyTextFormField(
              name: 'User Name',
              controller: userName,
              keyboardType: TextInputType.name,
            ),
            MyTextFormField(
              name: 'Email',
              controller: email,
              keyboardType: TextInputType.emailAddress,
            ),
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
            GestureDetector(
              onTap: () {
                setState(() {
                  isMale = !isMale;
                });
              },
              child: Container(
                height: 60,
                width: double.infinity,
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        isMale == true ? 'Male' : 'Female',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MyTextFormField(
              name: 'Phone Number',
              controller: phoneNumber,
              keyboardType: TextInputType.phone,
            ),
            MyTextFormField(
              name: 'Address',
              controller: address,
              keyboardType: TextInputType.streetAddress,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonPart() {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MyButton(
            name: 'SignUp',
            onPressed: () {
              validation();
            },
          ),
          ChangeScreen(
            name: 'Login',
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => const Login(),
                  /* ctx means or is a shortform of context*/
                ),
              );
            },
            whichAccount: 'Already Have An Account?',
          ),
          // Add Admin Register
          const Divider(
            thickness: 3.0,
            color: Colors.red,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _buildAllTextFormField(),
                _buildButtonPart(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
