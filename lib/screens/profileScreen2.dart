import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/model/modelExports.dart';
import 'package:e_commerce_app/screens/screensExports.dart';
import 'package:e_commerce_app/widgets/widgetsExports.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen2 extends StatefulWidget {
  const ProfileScreen2({super.key});

  @override
  State<ProfileScreen2> createState() => _ProfileScreen2State();
}

class _ProfileScreen2State extends State<ProfileScreen2> {
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

  // Function to retrieve user details
  Future<User?> getUserDetails() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // User is logged in
      // Retrieve user details from Firestore or Realtime Database
      // You can customize this based on your database structure
      // Example: Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .get();

      if (snapshot.exists) {
        // User details found
        // Retrieve the user object
        User? userDetails = snapshot.data() as User?;
        return userDetails!;
      } else {
        // User details not found
        return null;
      }
    } else {
      // User is not logged in
      return null;
    }
  }

// Function to update user details
  Future<void> updateUserDetails(User user) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // User is logged in
      // Update user details in Firestore or Realtime Database
      // You can customize this based on your database structure
      // Example: Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({
        'UserName': userName!.text,
        'UserGender': isMale == true ? 'Male' : 'Female',
        'UserNumber': phoneNumber!.text,
        'userImage': imageUrl,
        'UserAddress': address!.text,
      });
    } else {
      // User is not logged in
      throw Exception("User not logged in");
    }
  }

// Function to upload profile picture
  Future<String> uploadImage({required File image}) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null || _image == null) {
      // User is logged in
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profilePictures/$fileName');

      UploadTask uploadTask = storageReference.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
        uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
          switch (taskSnapshot.state) {
            case TaskState.running:
              final progress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
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
      });
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } else {
      // User is not logged in
      throw Exception("User not logged in");
    }
  }

  // Example usage

  // void validateUser() async {
  //   // Retrieve user details
  //   User? userDetails = await getUserDetails();
  //   if (userDetails != null) {
  //     // User details found
  //     //  print('User Name: ${userDetails.name}');
  //     print('User Email: ${userDetails.email}');
  //     // Update user details
  //     //   userDetails.name = 'New Name';
  //     await updateUserDetails(userDetails);
  //     // Upload profile picture
  //     File imageFile = File('path_to_image_file.jpg');
  //     String imageUrl = await uploadImage(image: _pickedImage!);
  //     print('Profile Picture URL: $imageUrl');
  //   } else {
  //     // User details not found or user not logged in
  //     print('User not logged in or details not found');
  //   }
  // }

  void checkIconUpdate() async {
    // Retrieve user details
    User? userDetails = await getUserDetails();

    if (userDetails != null) {
      // User details found
      //print('User Name: ${userDetails.name}');
      print('User Email: ${userDetails.email}');

      // Update user details
      //  userDetails.name = 'New Name';
      await updateUserDetails(userDetails);

      // Upload profile picture
      //  File imageFile = File('path_to_image_file.jpg');
      String imageUrl = await uploadImage(image: _pickedImage!);
      print('Profile Picture URL: $imageUrl');
    } else {
      // User details not found or user not logged in
      print('User not logged in or details not found');
    }
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
            Text(
              endText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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

  void _finalValidation() {
    uploadImage(image: _pickedImage!);
    //updateUserDetails();
    checkIconUpdate();
    setState(() {
      edit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    _finalValidation();
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
                          backgroundImage: _pickedImage == false
                              ? userModel!.userImage == false
                                  ? AssetImage('assets/images/User Image.png')
                                  : NetworkImage(userModel!.userImage)
                                      as ImageProvider
                              : FileImage(_pickedImage!),
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
