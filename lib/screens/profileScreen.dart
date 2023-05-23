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

//   FirebaseStorage storage = FirebaseStorage.instance;
//   File? pickedImage;
//   var imageMap;
//   var imagePath;
//   PickedFile? image;
//   Future<void> getImage({required ImageSource source}) async {
//     final image = await ImagePicker().pickImage(source: source);
//     if (image == null) {
//       pickedImage = File(image!.path);
//     }
//   }

  Widget _buildSingleContainer(
      {required String startText, required String endText}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
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
            Text(
              endText,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleTextFormField({required String name}) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: name,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  FirebaseStorage storage = FirebaseStorage.instance;
  String? imageUrl;
  File? _imageFile;
  Future<void> _getImage({required ImageSource source}) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadAndSetProfilePicture() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (_imageFile == null) {
      return;
    }
    // Reference the profile picture path in Firebase Storage
    final uploadTask = storage
        .ref()
        .child('UserImage/${user!.uid}')
        // Upload the image file to Firebase Storage
        .putFile(_imageFile!);
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

  bool edit = false;

  Widget _buildContainerPart() {
    List<UserModel> userModel = productProvider!.userModeList;
    return Column(
      children: userModel.map((e) {
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
            ],
          ),
        );
      }).toList(),
    );
  }

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

  Widget _buildTextFormFieldPart() {
    List<UserModel> userModel = productProvider!.userModeList;
    return Column(
      children: userModel.map((e) {
        return Container(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSingleTextFormField(
                name: e.userName,
              ),
              _buildSingleTextFormField(
                name: e.userEmail,
              ),
              _buildSingleTextFormField(
                name: e.userGender,
              ),
              _buildSingleTextFormField(
                name: e.userPhoneNumber,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of(context);
    return Scaffold(
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
                    _uploadAndSetProfilePicture();
                    setState(() {
                      edit = false;
                    });
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
                          backgroundImage:
                              const AssetImage('assets/images/User Image.png'),
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
