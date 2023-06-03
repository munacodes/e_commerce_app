import 'package:cloud_firestore/cloud_firestore.dart';
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

  void validation() async {
    if (userName.text.isEmpty &&
        email.text.isEmpty &&
        password.text.isEmpty &&
        phoneNumber.text.isEmpty &&
        address.text.isEmpty) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('All Field Are Empty'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else if (userName.text.length < 6) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Name Must Be 6'),
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
    } else if (phoneNumber.text.length < 11 || phoneNumber.text.isEmpty) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Phone Number Must Be 11'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else if (address.text.isEmpty) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Address Is Empty'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else {
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
          'Phone Number': phoneNumber.text,
        });
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

      // on FirebaseException catch (e) {
      //   _scaffoldMessengerKey.currentState!.showSnackBar(
      //     SnackBar(
      //       content: Text('Failed with error code: ${e.code.toString()}'),
      //     ),
      //   );
      // }
    }
  }

  Widget _buildAllTextFormField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
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
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        isMale == true ? 'Male' : 'Female',
                        style: const TextStyle(
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
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MyButton(
            name: 'SignUp',
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
                    children: const [
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
                const SizedBox(
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
