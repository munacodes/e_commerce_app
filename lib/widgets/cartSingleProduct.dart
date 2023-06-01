import 'package:e_commerce_app/provider/product_provider.dart';
import 'package:e_commerce_app/screens/screensExports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartSingleProduct extends StatefulWidget {
  final String image;
  final String name;
  int quantity;
  final double price;
  bool? isCount;
  final int index;
  final String color;
  final String size;

  CartSingleProduct({
    Key? key,
    required this.image,
    required this.name,
    required this.quantity,
    required this.price,
    this.isCount,
    required this.index,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  State<CartSingleProduct> createState() => _CartSingleProductState();
}

TextStyle myStyle = const TextStyle(fontSize: 18);

class _CartSingleProductState extends State<CartSingleProduct> {
  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    return Container(
      height: 150,
      width: double.infinity,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 130,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.image),
                    ),
                  ),
                ),
                Container(
                  height: 140,
                  width: widget.isCount == true ? 250 : 282,
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.name,
                                style: myStyle,
                              ),
                              IconButton(
                                onPressed: () {
                                  widget.isCount == false
                                      ? productProvider!
                                          .deleteCartProduct(widget.index)
                                      : productProvider!
                                          .deleteCheckoutProduct(widget.index);
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.color,
                                style: myStyle,
                              ),
                              Text(
                                widget.size,
                                style: myStyle,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$ ${widget.price.toString()}',
                          style: const TextStyle(
                              color: Color(0xff9b96d6),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 35,
                          width: widget.isCount == false ? 120 : 100,
                          color: const Color(0xfff2f2f2),
                          child: widget.isCount == false
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (widget.quantity > 1) {
                                            widget.quantity--;
                                            productProvider!.getCheckOutData(
                                              quantity: widget.quantity,
                                              price: widget.price,
                                              name: widget.name,
                                              image: widget.image,
                                              color: widget.color,
                                              size: widget.size,
                                            );
                                          }
                                        });
                                      },
                                      child: const Icon(Icons.remove),
                                    ),
                                    Text(
                                      widget.quantity.toString(),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    GestureDetector(
                                      child: const Icon(Icons.add),
                                      onTap: () {
                                        setState(() {
                                          widget.quantity++;
                                          productProvider!.getCheckOutData(
                                            quantity: widget.quantity,
                                            price: widget.price,
                                            name: widget.name,
                                            image: widget.image,
                                            color: widget.color,
                                            size: widget.size,
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text('Quantity'),
                                    Text(
                                      widget.quantity.toString(),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
