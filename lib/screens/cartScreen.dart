import 'package:e_commerce_app/screens/checkOut.dart';
import 'package:e_commerce_app/screens/homePage.dart';
import 'package:e_commerce_app/widgets/cartSingleProduct.dart';
import 'package:e_commerce_app/widgets/widgetsExports.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app/provider/providerExports.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  @override
  State<CartScreen> createState() => _CartScreenState();
}

ProductProvider? productProvider;

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      bottomNavigationBar: Container(
        height: 70,
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.only(bottom: 10),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color(0xff746bc9),
            ),
          ),
          onPressed: () {
            productProvider!.addNotification('Notification');
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const CheckOut(),
              ),
            );
          },
          child: const Text(
            'Continue',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Cart Page',
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
      body: SafeArea(
        child: ListView.builder(
          itemCount: productProvider!.getCardModelListLength,
          itemBuilder: (context, index) => CartSingleProduct(
            index: index,
            color: productProvider!.getCardModelList[index].color,
            size: productProvider!.getCardModelList[index].size,
            isCount: false,
            image: productProvider!.getCardModelList[index].image,
            name: productProvider!.getCardModelList[index].name,
            price: productProvider!.getCardModelList[index].price,
            quantity: productProvider!.getCardModelList[index].quantity,
          ),
        ),
      ),
    );
  }
}
