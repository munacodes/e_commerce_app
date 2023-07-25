import 'package:flutter/material.dart';

class SingleOrderProduct extends StatelessWidget {
  final int? index;
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
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text(name),
        Center(
          child: Row(
            children: [
              Card(
                child: Container(
                  padding: const EdgeInsets.all(13),
                  child: Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.blue,
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
        Text(
          price.toString(),
        ),
        Text(size),
        Text(color),
        Text(
          quantity.toString(),
        ),
      ],
    );
  }
}
