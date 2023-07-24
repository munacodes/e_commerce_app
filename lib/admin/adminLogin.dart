import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/admin/adminExport.dart';
import 'package:e_commerce_app/dialogBox/dialogBoxExpoets.dart';
import 'package:e_commerce_app/screens/login.dart';
import 'package:e_commerce_app/widgets/widgetsExports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController adminID = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool obscureText = false;

  validation() {
    showDialog(
      context: context,
      builder: (c) {
        return const LoadingAlertDialog(
            message: 'Authenticating, Please wait....');
      },
    );
    FirebaseFirestore.instance.collection('admins').get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result.data()['id'] != adminID.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your id is not correct'),
            ),
          );
        } else if (result.data()['password'] != password.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your password is not correct'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome Dear Admin ${result.data()['name']}'),
            ),
          );
          setState(() {
            adminID.clear();
            password.clear();
          });
          Route route = MaterialPageRoute(
            builder: (context) => const AdminHomePage(),
          );
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Login(),
              ),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'eCommerce Admin Page',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'I am Admin',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      MyTextFormField(
                        name: 'Admin ID',
                        controller: adminID,
                        keyboardType: TextInputType.name,
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
                          adminID.text.isNotEmpty && password.text.isNotEmpty
                              ? validation()
                              : showDialog(
                                  context: context,
                                  builder: (c) {
                                    return const ErrorAlertDialog(
                                      message:
                                          'Please enter email and password.',
                                    );
                                  },
                                );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
