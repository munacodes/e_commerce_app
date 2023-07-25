import 'package:flutter/material.dart';

class SingleOrderProduct extends StatelessWidget {
  final String name;
  final double price;
  final String image;
  final String size;
  final String color;
  final int quantity;
  const SingleOrderProduct({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.size,
    required this.color,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Product Name: $name'),
        Center(
          child: Row(
            children: [
              Card(
                child: Container(
                  padding: const EdgeInsets.all(13),
                  child: Container(
                    height: 220,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(image),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Text('Product Price: N $price'),
        Text('Product Size: $size'),
        Text('Product Color: $color'),
        Text('Product Quantity: $quantity'),
      ],
    );
  }
}
