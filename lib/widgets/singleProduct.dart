import 'package:flutter/material.dart';

class SingleProduct extends StatelessWidget {
  final double price;
  final String image;
  final String name;
  const SingleProduct({
    super.key,
    required this.image,
    required this.price,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 260,
        width: 175,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                height: 130,
                width: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(image),
                  ),
                ),
              ),
            ),
            Text(
              '\$ ${price.toString()}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Color(0xff9b96d6),
              ),
            ),
            Container(
              child: Text(
                name,
                style: const TextStyle(fontSize: 17),
              ),
            )
          ],
        ),
      ),
    );
  }
}
