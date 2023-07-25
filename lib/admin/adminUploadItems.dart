import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/admin/adminExport.dart';
import 'package:e_commerce_app/widgets/widgetsExports.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminUploadItems extends StatefulWidget {
  const AdminUploadItems({super.key});

  @override
  State<AdminUploadItems> createState() => _AdminUploadItemsState();
}

class _AdminUploadItemsState extends State<AdminUploadItems> {
  final TextEditingController _priceTextEditingController =
      TextEditingController();
  final TextEditingController _nameTextEditingController =
      TextEditingController();

  String? productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  Scaffold displayAdminHomeScreen() {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Card(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36),
            ),
            child: GestureDetector(
              onTap: () => takeImage(context),
              child: Container(
                height: 70,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Center(
                  child: Text(
                    'Upload Item',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  takeImage(mcontext) {
    return showDialog<void>(
      context: mcontext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Item Image',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  title: const Text(
                    'Capture with Camera',
                    style: TextStyle(color: Colors.green),
                  ),
                  onTap: () {
                    capturePhotoWithCamera();
                  },
                ),
                ListTile(
                  title: const Text(
                    'Select from Gallery',
                    style: TextStyle(color: Colors.green),
                  ),
                  onTap: () {
                    pickPhotoFromGallery();
                  },
                ),
                ListTile(
                  title: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.green),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  File? _imageFile;
  Future<void> capturePhotoWithCamera() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final image = await picker.pickImage(
        source: ImageSource.camera, maxHeight: 600.0, maxWidth: 970.0);
    setState(() {
      _imageFile = File(image!.path);
    });
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(image!.path);
    });
  }

  displayAdminUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'New Product',
          style: TextStyle(
              color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
            child: const Text(
              'Add',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              uploading ? circularProgress() : const Text(''),
              Row(
                children: [
                  Icon(Icons.border_color, color: Colors.blue),
                  const SizedBox(width: 10),
                  Container(
                    width: 250.0,
                    child: TextField(
                      controller: _nameTextEditingController,
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.black),
              Container(
                height: 230.0,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_imageFile!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(color: Colors.black),
              Row(
                children: [
                  Icon(Icons.attach_money, color: Colors.blue),
                  const SizedBox(width: 10),
                  Container(
                    width: 250.0,
                    child: TextField(
                      controller: _priceTextEditingController,
                      decoration: const InputDecoration(
                        hintText: 'Price',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.black),
              GestureDetector(
                onTap: () => showMessage(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.category, color: Colors.blue),
                    const SizedBox(width: 10),
                    Container(
                      height: 50,
                      width: 250.0,
                      child: Text(
                        'Category',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.black),
              // zxcvbnm(),
              poipu(),
            ],
          ),
        ),
      ),
    );
  }

  poipu() {
    return Container(
      height: 40,
      width: 60,
      color: Colors.blue,
      child: Text(''),
    );
  }

  zxcvbnm() async {
    if (qwertyuiop == 'Dress') {
      return poipu;
    } else if (qwertyuiop == 'Pants') {
      return poipu;
    } else if (qwertyuiop == 'Shoes') {
      return poipu;
    } else if (qwertyuiop == 'Tie') {
      return poipu;
    } else if (qwertyuiop == 'Shirt') {
      return poipu;
    }
  }

  decoractionBox({required String name}) {
    return Container(
      height: 50,
      child: Card(
        color: Colors.grey[300],
        child: Center(
          child: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  qwertyuiop({required String text}) {
    return Text(text);
  }

  showMessage() {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 280,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                GestureDetector(
                  onTap: qwertyuiop(text: 'Dress'),
                  child: decoractionBox(name: 'Dress'),
                ),
                GestureDetector(
                  onTap: qwertyuiop(text: 'Pants'),
                  child: decoractionBox(name: 'Pants'),
                ),
                GestureDetector(
                  onTap: qwertyuiop(text: 'Shoes'),
                  child: decoractionBox(name: 'Shoes'),
                ),
                GestureDetector(
                  onTap: qwertyuiop(text: 'Tie'),
                  child: decoractionBox(name: 'Tie'),
                ),
                GestureDetector(
                  onTap: qwertyuiop(text: 'Shirt'),
                  child: decoractionBox(name: 'Shirt'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  clearFormInfo() {
    setState(() {
      _imageFile == null;
      _priceTextEditingController.clear();
      _nameTextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItemImage(_imageFile!);
    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mfileImage) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('Items');
    UploadTask uploadTask =
        storageReference.child("product $productId.jpg").putFile(mfileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(String downloadUrl) {
    final itemRef = FirebaseFirestore.instance.collection('items');
    itemRef.doc(productId).set({
      'price': double.parse(_priceTextEditingController.text),
      'image': downloadUrl,
      'name': _nameTextEditingController.text.trim(),
    });

    setState(() {
      _imageFile == null;
      uploading = false;
      _nameTextEditingController.clear();
      _priceTextEditingController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _imageFile == null
        ? displayAdminHomeScreen()
        : displayAdminUploadFormScreen();
  }
}
