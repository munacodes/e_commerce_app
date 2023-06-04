import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/model/modelExports.dart';
import 'package:e_commerce_app/provider/product_provider.dart';
import 'package:e_commerce_app/screens/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app/widgets/widgetsExports.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController message = TextEditingController();
  String? name, email;

  void validation() async {
    if (message.text.isEmpty) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Please Fill Message'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else {
      User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('Message').doc(user!.uid).set({
        'Name': name,
        'Email': email,
        'Message': message.text,
      });
    }
  }

  Widget _buildSingleField({required String name}) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    ProductProvider? provider;
    List<UserModel> user = provider!.userModeList;
    user.map((e) {
      name = e.userName;
      email = e.userEmail;

      return Container();
    }).toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(name);
    return
        // WillPopScope(
        //   onWillPop: () async {
        //     Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(
        //         builder: (context) => const HomePage(),
        //       ),
        //     );
        //     return true;
        //   },
        //   // onWillPop: () async {
        //   //   return true;
        //   // },
        //   child:
        Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xfff8f8f8),
        title: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff746bc9),
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 27),
          height: 600,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Send Us Your Message',
                style: TextStyle(
                  color: Color(0xff746bc9),
                  fontSize: 28,
                ),
              ),
              _buildSingleField(name: name!),
              _buildSingleField(name: email!),
              Container(
                height: 200,
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Message',
                  ),
                ),
              ),
              MyButton(
                name: 'Submit',
                onPressed: () {
                  validation();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
