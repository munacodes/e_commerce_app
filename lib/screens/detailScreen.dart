import 'package:e_commerce_app/screens/cartScreen.dart';
import 'package:e_commerce_app/screens/homePage.dart';
import 'package:e_commerce_app/widgets/widgetsExports.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/provider/providerExports.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final String image;
  final String name;
  final double price;

  const DetailScreen({
    Key? key,
    required this.image,
    required this.name,
    required this.price,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int count = 1;
  ProductProvider? productProvider;
  // Widget _buildSizeProduct({required String name}) {
  //   return Container(
  //     height: 60,
  //     width: 60,
  //     color: const Color(0xfff2f2f2),
  //     child: Center(
  //       child: Text(
  //         name,
  //         style: const TextStyle(
  //           fontSize: 17,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildColorProduct({required Color color}) {
    return Container(
      height: 40,
      width: 40,
      color: color,
    );
  }

  final TextStyle myStyle = const TextStyle(
    fontSize: 18,
  );

  Widget _buildImage() {
    return Center(
      child: Row(
        children: [
          Container(
            width: 380,
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(13),
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.image),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameToDescriptionPart() {
    return Container(
      height: 100,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: myStyle,
              ),
              Text(
                '\$ ${widget.price.toString()}',
                style: const TextStyle(
                  color: Color(0xff9b96d6),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Description',
                style: myStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      height: 170,
      child: Wrap(
        children: const [
          Text(
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  List<bool> isSelected = [true, false, false, false];
  List<bool> colored = [true, false, false, false];

  Widget _buildSizePart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Size',
          style: myStyle,
        ),
        const SizedBox(
          height: 15,
        ),
        // Container(
        //   width: 265,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       _buildSizeProduct(name: 'S'),
        //       _buildSizeProduct(name: 'M'),
        //       _buildSizeProduct(name: 'L'),
        //       _buildSizeProduct(name: 'XXL'),
        //     ],
        //   ),
        // ),
        Container(
          width: 265,
          child: ToggleButtons(
            isSelected: isSelected,
            onPressed: (int index) {
              setState(() {
                for (int indexBtn = 0;
                    indexBtn < isSelected.length;
                    indexBtn++) {
                  if (indexBtn == index) {
                    isSelected[indexBtn] = true;
                  } else {
                    isSelected[indexBtn] = false;
                  }
                }
              });
            },
            children: const [
              Text('S'),
              Text('M'),
              Text('L'),
              Text('XL'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          'Color',
          style: myStyle,
        ),
        const SizedBox(
          height: 15,
        ),
        // Container(
        //   width: 265,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       _buildColorProduct(color: Colors.blue[200]!),
        //       _buildColorProduct(color: Colors.green[200]!),
        //       _buildColorProduct(color: Colors.yellow[200]!),
        //       _buildColorProduct(color: Colors.cyan[300]!),
        //     ],
        //   ),
        // ),
        Container(
          width: 265,
          child: ToggleButtons(
            fillColor: const Color(0xff746bc9),
            renderBorder: false,
            isSelected: colored,
            onPressed: (int index) {
              setState(() {
                for (int indexBtn = 0; indexBtn < colored.length; indexBtn++) {
                  if (indexBtn == index) {
                    colored[indexBtn] = true;
                  } else {
                    colored[indexBtn] = false;
                  }
                }
              });
            },
            children: [
              _buildColorProduct(color: Colors.blue[200]!),
              _buildColorProduct(color: Colors.green[200]!),
              _buildColorProduct(color: Colors.yellow[200]!),
              _buildColorProduct(color: Colors.cyan[300]!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          'Qauntity',
          style: myStyle,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 40,
          width: 130,
          decoration: BoxDecoration(
            color: Colors.blue[200]!,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (count > 1) {
                      count--;
                    }
                  });
                },
                child: const Icon(Icons.remove),
              ),
              Text(
                count.toString(),
                style: myStyle,
              ),
              GestureDetector(
                child: const Icon(Icons.add),
                onTap: () {
                  setState(() {
                    count++;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonPart() {
    return Container(
      height: 60,
      child: MyButton(
        name: 'CheckOut',
        onPressed: () {
          productProvider!.getCartData(
            name: widget.name,
            image: widget.image,
            quantity: count,
            price: widget.price,
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const CartScreen(),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Detail Page',
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
      body: SafeArea(
        child: Container(
          child: ListView(
            children: [
              _buildImage(),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNameToDescriptionPart(),
                    _buildDescription(),
                    _buildSizePart(),
                    _buildColorPart(),
                    _buildQuantityPart(),
                    const SizedBox(
                      height: 15,
                    ),
                    _buildButtonPart(),
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
