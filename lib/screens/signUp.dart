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

class _SignUpState extends State<SignUp> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
// Invaild Email Strings/Letters
    String p =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(p);

    bool obscureText = true;

    var email;
    var username;
    var phoneNumber;
    var password;
    bool isMale = true;

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

    void validation() async {
      bool isvalid;
      isvalid = _formKey.currentState!.validate();

      if (isvalid) {
        _formKey.currentState!.save();
        ScaffoldMessenger.of(context).showSnackBar(snackBarValid);
        try {
          final UserCredential result =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
          FirebaseFirestore.instance
              .collection('Users')
              .doc(result.user!.uid)
              .set({
            'UserName': username,
            'UserId': result.user!.uid,
            'UserEmail': email,
            'UserGender': isMale == true ? 'Male' : 'Female',
            'Phone Number': phoneNumber,
          });
        } on FirebaseAuthException catch (e) {
          print('Failed with error code: ${e.code.toString()}');
          print(e.message);
        }
      }
    }

    Widget _buildAllTextFormField() {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 360,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Field is Empty";
                  } else if (value.length < 5) {
                    return "UserName is Too Short";
                  }
                  {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: "UserName",
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(),
                ),
                onSaved: (newValue) {
                  username = newValue;
                },
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
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
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
                  email = value.toString();
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
                  setState(() {
                    password = value;
                  });
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
                      setState(() {
                        obscureText = !obscureText;
                      });
                      FocusScope.of(context).unfocus();
                    },
                    child: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
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
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Field Is Empty";
                  } else if (value.length < 8) {
                    return "Phone Number must have at least 8 characters";
                  }
                  {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  phoneNumber = value;
                },
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
