import 'package:e_commerce_app/provider/providerExports.dart';
import 'package:e_commerce_app/screens/screensExports.dart';
import 'package:e_commerce_app/widgets/widgetsExports.dart';
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

  @override
  Widget build(BuildContext context) {
    double subTotal = 0;
    double discount = 3;
    double discountRupees;
    double shipping = 60;
    double total;
    productProvider = Provider.of<ProductProvider>(context);
    productProvider!.getCheckOutModelList.forEach(
      (element) {
        subTotal += element.price * element.quantity;
      },
    );
    discountRupees = discount / 100 * subTotal;
    total = subTotal + shipping - discountRupees;
    return Scaffold(
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
        actions: const [
          NotificationButton(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.only(bottom: 15),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color(0xff746bc9),
            ),
          ),
          onPressed: () {},
          child: const Text(
            'Buy',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 400,
                child: ListView.builder(
                  itemCount: productProvider!.getCheckOutModelListLength,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CartSingleProduct(
                          image: productProvider!
                              .getCheckOutModelList[index].image,
                          name:
                              productProvider!.getCheckOutModelList[index].name,
                          price: productProvider!
                              .getCheckOutModelList[index].price,
                          quantity: productProvider!
                              .getCheckOutModelList[index].quantity,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                height: 150,
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
                      endName: '\$ ${total.toStringAsFixed(2)}',
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
