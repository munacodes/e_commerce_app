import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/provider/providerExports.dart';
import 'package:e_commerce_app/screens/screensExports.dart';
import 'package:e_commerce_app/widgets/widgetsExports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({Key? key}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final TextStyle myStyle = const TextStyle(
    fontSize: 18,
  );

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  ProductProvider? productProvider;

  Widget _buildButtonDetail(
      {required String startName, required String endName}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          startName,
          style: myStyle,
        ),
        Text(
          endName,
          style: myStyle,
        ),
      ],
    );
  }

  User? user;
  double? total;
  int? index;

  Widget _buildButton() {
    return Column(
      children: productProvider!.userModelList.map((e) {
        return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color(0xff746bc9),
            ),
          ),
          child: const Text(
            'Order',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: () {
            if (productProvider!.checkOutModelList.isNotEmpty) {
              FirebaseFirestore.instance
                  .collection('Order')
                  .doc(user!.uid)
                  .set({
                'Product': productProvider!.checkOutModelList
                    .map((c) => {
                          'ProductName': c.name,
                          'ProductPrice': c.price,
                          'ProductQuantity': c.quantity,
                          'ProductImage': c.image,
                          'Product Color': c.color,
                          'Prduct Size': c.size,
                        })
                    .toList(),
                'TotalPrice': total!.toStringAsFixed(2),
                'UserName': e.userName,
                'UserEmail': e.userEmail,
                'UserNumber': e.userPhoneNumber,
                'UserAddress': e.userAddress,
                'UserUid': user!.uid,
              });
              productProvider!.clearCheckoutProduct();
              productProvider!.addNotification('Notification');
            } else {
              _scaffoldMessengerKey.currentState!.showSnackBar(
                const SnackBar(
                  content: Text('No Item Yet'),
                  backgroundColor: Color(0xff746bc9),
                ),
              );
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildButton2() {
    return Container(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color(0xff746bc9),
          ),
        ),
        child: const Text(
          'Order',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        onPressed: () {
          if (productProvider!.checkOutModelList.isEmpty) {
            _scaffoldMessengerKey.currentState!.showSnackBar(
              SnackBar(
                content: Text('No Item Yet'),
                backgroundColor: Color(0xff746bc9),
              ),
            );
          } else if (productProvider!.checkOutModelList.isNotEmpty) {
            FirebaseFirestore.instance.collection('Order').doc(user!.uid).set(
              {
                'Product': productProvider!.checkOutModelList
                    .map((c) => {
                          'ProductName': c.name,
                          'ProductPrice': c.price,
                          'ProductQuantity': c.quantity,
                          'ProductImage': c.image,
                          'Product Color': c.color,
                          'Prduct Size': c.size,
                        })
                    .toList(),
                'TotalPrice': total!.toStringAsFixed(2),
              },
            );
            productProvider!.clearCheckoutProduct();
            productProvider!.addNotification('Notification');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser!;
    double subTotal = 0;
    double discount = 3;
    double discountRupees;
    double shipping = 60;

    productProvider = Provider.of<ProductProvider>(context);
    productProvider!.getCheckOutModelList.forEach(
      (element) {
        subTotal += element.price * element.quantity;
      },
    );
    discountRupees = discount / 100 * subTotal;
    total = subTotal + shipping - discountRupees;
    if (productProvider!.checkOutModelList.isEmpty) {
      total = 0.0;
      discount = 0.0;
      shipping = 0.0;
    }

    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'CheckOut Page',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
        actions: [
          NotificationButton(),
        ],
      ),
      // bottomNavigationBar: Container(
      //   height: 50,
      //   width: 100,
      //   margin: const EdgeInsets.symmetric(horizontal: 10),
      //   padding: const EdgeInsets.only(bottom: 15),
      //   child: _buildButton(),
      // ),

      bottomNavigationBar: Container(
        height: 60,
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.only(bottom: 15),
        child: _buildButton2(),
      ),

      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 430,
                child: ListView.builder(
                  itemCount: productProvider!.getCheckOutModelListLength,
                  itemBuilder: (context, myIndex) {
                    index = myIndex;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CartSingleProduct(
                          isCount: true,
                          index: myIndex,
                          color: productProvider!
                              .getCheckOutModelList[myIndex].color,
                          size: productProvider!
                              .getCheckOutModelList[myIndex].size,
                          image: productProvider!
                              .getCheckOutModelList[myIndex].image,
                          name: productProvider!
                              .getCheckOutModelList[myIndex].name,
                          price: productProvider!
                              .getCheckOutModelList[myIndex].price,
                          quantity: productProvider!
                              .getCheckOutModelList[myIndex].quantity,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                height: 130,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButtonDetail(
                      startName: 'Your Price',
                      endName: '\$ ${subTotal.toStringAsFixed(2)}',
                    ),
                    _buildButtonDetail(
                      startName: 'Discount',
                      endName: '${discount.toStringAsFixed(2)}%',
                    ),
                    _buildButtonDetail(
                      startName: 'Shipping',
                      endName: '\$ ${shipping.toStringAsFixed(2)}',
                    ),
                    _buildButtonDetail(
                      startName: 'Total',
                      endName: '\$ ${total!.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
