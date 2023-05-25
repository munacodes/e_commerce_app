import 'package:e_commerce_app/model/modelExports.dart';
import 'package:e_commerce_app/provider/providerExports.dart';
import 'package:e_commerce_app/screens/homePage.dart';
import 'package:e_commerce_app/screens/screensExports.dart';
import 'package:e_commerce_app/screens/search_category.dart';
import 'package:e_commerce_app/widgets/singleProduct.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListProduct extends StatelessWidget {
  final String name;
  final List<Product> snapShot;
  bool? isCategory = true;
  ListProduct({
    Key? key,
    required this.name,
    required this.snapShot,
    this.isCategory,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
        actions: [
          isCategory == true
              ? IconButton(
                  onPressed: () {
                    categoryProvider.getSearchList(list: snapShot);
                    showSearch(
                      context: context,
                      delegate: SearchCategory(),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    productProvider.getSearchList(list: snapShot);
                    showSearch(
                      context: context,
                      delegate: SearchProduct(),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 640,
                    child: GridView.count(
                      crossAxisCount:
                          orientation == Orientation.portrait ? 2 : 3,
                      childAspectRatio: 0.6,
                      scrollDirection: Axis.vertical,
                      children: snapShot
                          .map(
                            (e) => GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      image: e.image,
                                      name: e.name,
                                      price: e.price,
                                    ),
                                  ),
                                );
                              },
                              child: SingleProduct(
                                image: e.image,
                                price: e.price,
                                name: e.name,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
