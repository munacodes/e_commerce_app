import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/model/modelExports.dart';
import 'package:e_commerce_app/provider/providerExports.dart';
import 'package:e_commerce_app/screens/homePage.dart';
import 'package:e_commerce_app/widgets/mybutton.dart';
import 'package:e_commerce_app/widgets/widgetsExports.dart';
import 'package:e_commerce_app/screens/screensExports.dart';
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
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();

  // Invaild Email Strings/Letters
  static String p =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regExp = RegExp(p);

  bool edit = false;
  String? userImage;
  bool isMale = false;

  UserModel? userModel;

  TextEditingController? phoneNumber;
  TextEditingController? userName;
  TextEditingController? address;

  void _finalValidation() async {
    await _uploadImage(image: _pickedImage!);
    _userDetailUpdate();
    setState(() {
      edit = false;
    });
  }

  ProductProvider? productProvider;
  Future<void> _userDetailUpdate() async {
    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('Users').doc(user!.uid).update({
      'UserName': userName!.text,
      'UserGender': isMale == true ? 'Male' : 'Female',
      'UserPhoneNumber': phoneNumber!.text,
      'userImage': imageUrl,
      'UserAddress': address!.text,
    });
  }

  FirebaseStorage storage = FirebaseStorage.instance;
  File? _pickedImage;
  // PickedFile? _image;
  Future<void> _getImage({required ImageSource source}) async {
    final picker = ImagePicker();
    final _image = await picker.pickImage(source: source);
    if (_image != null) {
      setState(() {
        _pickedImage = File(_image.path);
      });
    }
  }

  String? imageUrl;
  Future<void> _uploadImage({required File image}) async {
    User? user = FirebaseAuth.instance.currentUser;
    Reference storageReference =
        FirebaseStorage.instance.ref().child("userImage/${user!.uid}");
    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    imageUrl = await snapshot.ref.getDownloadURL();
    print('profile $imageUrl');
  }

  void validation() async {
    if (userName!.text.isEmpty && phoneNumber!.text.isEmpty) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('All Field Are Empty'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else if (userName!.text.isEmpty) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Name Is Empty'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else if (userName!.text.length < 6) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Name Must Be 6'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else if (phoneNumber!.text.length < 11 || phoneNumber!.text.isEmpty) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
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
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: edit == true ? color : Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              startText,
              style: TextStyle(
                fontSize: 17,
                color: Colors.black45,
              ),
            ),
            Text(
              endText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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
                  title: const Text('Pick From Camera'),
                  onTap: () {
                    _getImage(source: ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Pick From Gallery'),
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
    address = TextEditingController(text: userModel!.userAddress);
    userName = TextEditingController(text: userModel!.userName);
    phoneNumber = TextEditingController(text: userModel!.userPhoneNumber);
    if (userModel!.userGender == 'Male') {
      isMale = true;
    } else {
      isMale = false;
    }
    return Container(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSingleContainer(
            endText: userModel!.userName,
            startText: 'Name',
          ),
          _buildSingleContainer(
            endText: userModel!.userEmail,
            startText: 'Email',
          ),
          _buildSingleContainer(
            endText: userModel!.userGender,
            startText: 'Gender',
          ),
          _buildSingleContainer(
            endText: userModel!.userPhoneNumber,
            startText: 'Phone Number',
          ),
          _buildSingleContainer(
            endText: userModel!.userAddress,
            startText: 'Address',
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormFieldPart() {
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
            endText: userModel!.userEmail,
            startText: 'Email',
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isMale = !isMale;
              });
            },
            child: _buildSingleContainer(
              color: Colors.white,
              endText: isMale == true ? 'Male' : 'Female',
              startText: 'Gender',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of(context);
    User? user = FirebaseAuth.instance.currentUser;
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
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
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
                print(userModel!.userImage);
              });
              return Container(
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
                                backgroundImage: _pickedImage == null
                                    ? userModel!.userImage == null
                                        ? AssetImage(
                                            'assets/images/User Image.png')
                                        : NetworkImage(
                                                userModel!.userImage ?? "")
                                            as ImageProvider
                                    : FileImage(_pickedImage!),
                              ),
                            ],
                          ),
                        ),
                        edit == true
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 200, top: 85),
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
              );
            }),
      ),
    );
  }
}
