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

final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final _formKey = GlobalKey<FormState>();

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
// Invaild Email Strings/Letters
    String p =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(p);

    // A popup message that displays at the bottom of the screen scaffoldMessengerKey
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

    bool isMale = true;
    final TextEditingController email = TextEditingController();
    final TextEditingController phoneNumber = TextEditingController();
    final TextEditingController password = TextEditingController();
    final TextEditingController userName = TextEditingController();

    void validation() async {
      if (userName.text.isEmpty &&
          email.text.isEmpty &&
          password.text.isEmpty &&
          phoneNumber.text.isEmpty) {
        _scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(
            content: Text('All Field Are Empty'),
          ),
        );
      } else if (userName.text.length < 6) {
        _scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(
            content: Text('Name Must Be 6'),
          ),
        );
      } else if (email.text.isEmpty) {
        _scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(
            content: Text("Email Is Empty"),
          ),
        );
      } else if (!regExp.hasMatch(email.text)) {
        _scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(
            content: Text('Please Try Valid Email'),
          ),
        );
      } else if (password.text.isEmpty) {
        _scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(
            content: Text('Password Is Empty'),
          ),
        );
      } else if (password.text.length < 8) {
        _scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(
            content: Text('Password Is Too Short'),
          ),
        );
      } else if (phoneNumber.text.length < 11 || phoneNumber.text.isEmpty) {
        _scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(
            content: Text('Phone Number Must Be 11'),
          ),
        );
      } else {
        bool isvalid = true;
        isvalid = _formKey.currentState!.validate();

        if (isvalid) {
          _formKey.currentState!.save();
          ScaffoldMessenger.of(context).showSnackBar(snackBarValid);
          try {
            final UserCredential result =
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
              'UserGender': isMale == true ? 'Male' : 'Female',
              'Phone Number': phoneNumber.text,
            });
          } on FirebaseAuthException catch (e) {
            _scaffoldMessengerKey.currentState!.showSnackBar(
              SnackBar(
                content:
                    Text('Failed with error code: ${e.message.toString()}'),
              ),
            );
          }
        }
      }
    }

//  on FirebaseAuthException catch (e) {
//             print('Failed with error code: ${e.code.toString()}');
//             print(e.message);
//           }

    // A popup message that displays at the bottom of the screen scaffoldMessengerKey
    // const snackBarValid = SnackBar(
    //   content: Center(
    //     child: Text(
    //       'Processing...',
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //   ),
    //   backgroundColor: Color(0xff746bc9),
    //   shape: StadiumBorder(),
    //   padding: EdgeInsets.all(10),
    //   margin: EdgeInsets.only(right: 100, left: 100),
    //   behavior: SnackBarBehavior.floating,
    //   duration: Duration(
    //     seconds: 1,
    //   ),
    // );

    // void validation() async {
    //   bool isvalid;
    //   isvalid = _formKey.currentState!.validate();

    //   if (isvalid) {
    //     _formKey.currentState!.save();
    //     ScaffoldMessenger.of(context).showSnackBar(snackBarValid);
    //     try {
    //       final UserCredential result =
    //           await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //         email: email.trim(),
    //         password: password.trim(),
    //       );
    //       FirebaseFirestore.instance
    //           .collection('Users')
    //           .doc(result.user!.uid)
    //           .set({
    //         'UserName': username,
    //         'UserId': result.user!.uid,
    //         'UserEmail': email,
    //         'UserGender': isMale == true ? 'Male' : 'Female',
    //         'Phone Number': phoneNumber,
    //       });
    //     } on FirebaseAuthException catch (e) {
    //       print('Failed with error code: ${e.code.toString()}');
    //       print(e.message);
    //     }
    //   }
    // }

    Widget _buildAllTextFormField() {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 360,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const MyTextFormField(
                name: 'UserName',
                keyboardType: TextInputType.name,
              ),
              const MyTextFormField(
                name: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const MyTextFormField(
                obscureText: true,
                name: 'Password',
                keyboardType: TextInputType.numberWithOptions(
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
              const MyTextFormField(
                name: 'Phone Number',
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildButtonPart() {
      return Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 10),
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
                    builder: (ctx) => Login(),
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
                  height: 200,
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
