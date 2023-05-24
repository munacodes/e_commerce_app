import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/model/modelExports.dart';
import 'package:e_commerce_app/provider/providerExports.dart';
import 'package:e_commerce_app/screens/homePage.dart';
import 'package:e_commerce_app/widgets/mybutton.dart';
import 'package:e_commerce_app/widgets/widgetsExports.dart';
import 'package:e_commerce_app/model/modelExports.dart';
import 'package:e_commerce_app/provider/providerExports.dart';
import 'package:e_commerce_app/screens/screensExports.dart';
import 'package:e_commerce_app/widgets/widgetsExports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProductProvider? productProvider;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();

  // Invaild Email Strings/Letters
  static String p =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regExp = RegExp(p);

  bool edit = false;
  String? userImage;
  bool isMale = false;

  TextEditingController? phoneNumber;
  TextEditingController? userName;
  TextEditingController? address;

  void _finalValidation() async {
    await _uploadImage(image: _pickedImage!);
    await _userDetailUpdate();
  }

  Future<void> _userDetailUpdate() async {
    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('Users').doc(user!.uid).set({
      'UserName': userName!.text,
      'UserGender': isMale == true ? 'Male' : 'Female',
      'UserNumber': phoneNumber!.text,
      'userImage': imageUrl,
      'UserAddress': address!.text,
    });
  }

  FirebaseStorage storage = FirebaseStorage.instance;
  File? _pickedImage;
  String? imageUrl;
  PickedFile? _image;
  Future<void> _getImage({required ImageSource source}) async {
    final picker = ImagePicker();
    final _image = await picker.pickImage(source: source);
    if (_image != null) {
      setState(() {
        _pickedImage = File(_image.path);
      });
    }
  }

  Future<void> _uploadImage({required File image}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (_image == null) {
      return;
    }
    // Reference the profile picture path in Firebase Storage
    final uploadTask = storage
        .ref()
        .child('UserImage/${user!.uid}')
        // Upload the image file to Firebase Storage
        .putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    imageUrl = await snapshot.ref.getDownloadURL();
    // Listen for state changes, errors, and completion of the upload.
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          // Handle unsuccessful uploads
          break;
        case TaskState.success:
          // Handle successful uploads on complete
          // ...
          break;
      }
    });
  }

// A popup message that displays at the bottom of the screen scaffoldMessengerKey
  final snackBarValid = const SnackBar(
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
    if (userName!.text.isEmpty && phoneNumber!.text.isEmpty) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('All Field Are Empty'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else if (userName!.text.isEmpty) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Name Is Empty'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else if (userName!.text.length < 6) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Name Must Be 6'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else if (phoneNumber!.text.length < 11 || phoneNumber!.text.isEmpty) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Phone Number Must Be 11'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else {
      _finalValidation();
    }
  }

  Widget _buildSingleContainer(
      {required String startText, required String endText, Color? color}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: edit == true ? color : Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              startText,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black45,
              ),
            ),
            Expanded(
              child: Text(
                endText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildSingleTextFormField({
  //   required String name,
  //   required Function onChanged,
  //   required Function validator,
  //   required String initialValue,
  // }) {
  //   return TextFormField(
  //     initialValue: initialValue,
  //     onChanged: onChanged(),
  //     validator: validator(),
  //     decoration: InputDecoration(
  //       hintText: name,
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //     ),
  //   );
  // }

  Future<void> myDialogBox() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Pick Form Camera'),
                  onTap: () {
                    _getImage(source: ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Pick Form Gallery'),
                  onTap: () {
                    _getImage(source: ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContainerPart() {
    List<UserModel> userModel = productProvider!.userModeList;
    return Column(
      children: userModel.map((e) {
        userImage = e.userImage;
        address = TextEditingController(text: e.userAddress);
        userName = TextEditingController(text: e.userName);
        phoneNumber = TextEditingController(text: e.userPhoneNumber);
        if (e.userGender == 'Male') {
          setState(() {
            isMale = true;
          });
        } else {
          setState(() {
            isMale = false;
          });
        }
        return Container(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSingleContainer(
                endText: e.userName,
                startText: 'Name',
              ),
              _buildSingleContainer(
                endText: e.userEmail,
                startText: 'Email',
              ),
              _buildSingleContainer(
                endText: e.userGender,
                startText: 'Gender',
              ),
              _buildSingleContainer(
                endText: e.userPhoneNumber,
                startText: 'Phone Number',
              ),
              _buildSingleContainer(
                endText: e.userAddress,
                startText: 'Address',
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextFormFieldPart() {
    List<UserModel> userModel = productProvider!.userModeList;
    return Column(
      children: userModel.map((e) {
        return Container(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MyTextFormField(
                name: 'UserName',
                controller: userName,
                keyboardType: TextInputType.name,
              ),
              _buildSingleContainer(
                color: Colors.grey[300],
                endText: e.userEmail,
                startText: 'Email',
              ),
              _buildSingleContainer(
                color: Colors.white,
                endText: e.userGender,
                startText: 'Gender',
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
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(isMale);
    productProvider = Provider.of(context);
    return Scaffold(
      key: _formKey,
      backgroundColor: const Color(0xfff8f8f8),
      appBar: AppBar(
        leading: edit == true
            ? IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.redAccent,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    edit = false;
                  });
                },
              )
            : IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black45,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  });
                },
              ),
        backgroundColor: Colors.white,
        actions: [
          edit == false
              ? const NotificationButton()
              : IconButton(
                  onPressed: () {
                    validation();
                  },
                  icon: const Icon(
                    Icons.check,
                    size: 30,
                    color: Color(0xff746bc9),
                  ),
                ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  Container(
                    height: 130,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          maxRadius: 65,
                          backgroundImage: userImage == null
                              ? const AssetImage('assets/images/User Image.png')
                              : NetworkImage(userImage!) as ImageProvider,
                        ),
                      ],
                    ),
                  ),
                  edit == true
                      ? Padding(
                          padding: const EdgeInsets.only(left: 200, top: 85),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                myDialogBox();
                              },
                              child: const CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Color(0xff746bc9),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              Container(
                height: 300,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 300,
                      child: edit == true
                          ? _buildTextFormFieldPart()
                          : _buildContainerPart(),
                    ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: edit == false
                      ? MyButton(
                          name: 'Edit Profile',
                          onPressed: () {
                            setState(() {
                              edit = true;
                            });
                          },
                        )
                      : Container(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
