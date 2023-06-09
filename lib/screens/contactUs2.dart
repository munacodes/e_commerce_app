import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/model/modelExports.dart';
import 'package:e_commerce_app/provider/providerExports.dart';
import 'package:e_commerce_app/screens/homePage.dart';
import 'package:e_commerce_app/model/modelExports.dart';
import 'package:e_commerce_app/screens/screensExports.dart';
import 'package:e_commerce_app/widgets/widgetsExports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactUs2 extends StatefulWidget {
  const ContactUs2({super.key});

  @override
  State<ContactUs2> createState() => _ContactUs2State();
}

class _ContactUs2State extends State<ContactUs2> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  TextEditingController message = TextEditingController();

  UserModel? userModel;

  Widget _buildSingleField({required String startText}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        height: 60,
        padding: EdgeInsets.only(left: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              startText,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainerDetailsPart() {
    return Container(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSingleField(
            startText: userModel!.userName!,
          ),
          _buildSingleField(
            startText: userModel!.userEmail!,
          ),
        ],
      ),
    );
  }

  void validation() async {
    if (message.text.isEmpty) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Please Fill Message'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else {
      User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('Messages').doc(user!.uid).set({
        'UserName': userModel!.userName.toString(),
        'UserEmail': userModel!.userEmail.toString(),
        'Message': message.text,
      });
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(0xfff8f8f8),
          title: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xff746bc9),
              size: 35,
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
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var myDoc = snapshot.data!.docs;
              myDoc.forEach((checkDocs) {
                if (checkDocs.data()['UserId'].toString() == user!.uid) {
                  userModel = UserModel(
                    userEmail: checkDocs.data()['UserEmail'].toString(),
                    userGender: checkDocs.data()['UserGender'].toString(),
                    userName: checkDocs.data()['UserName'].toString(),
                    userPhoneNumber:
                        checkDocs.data()['UserPhoneNumber'].toString(),
                    userImage: checkDocs.data()['UserImage'],
                    userAddress: checkDocs.data()['UserAddress'].toString(),
                  );
                }
                // print(userModel!.userName);
                // print(userModel!.userEmail);
              });
              return Container(
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
                    _buildContainerDetailsPart(),
                    Container(
                      height: 200,
                      child: TextFormField(
                        controller: message,
                        expands: true,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
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
              );
            },
          ),
        ),
      ),
    );
  }
}
