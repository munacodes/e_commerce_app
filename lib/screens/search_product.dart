import 'package:e_commerce_app/model/modelExports.dart';
import 'package:e_commerce_app/provider/category_provider.dart';
import 'package:e_commerce_app/provider/product_provider.dart';
import 'package:e_commerce_app/widgets/singleProduct.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchProduct extends SearchDelegate<void> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    ProductProvider providerProvider = Provider.of<ProductProvider>(context);
    List<Product> searchProduct = providerProvider.searchProductList(query);
    return GridView.count(
      childAspectRatio: 0.67,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: searchProduct
          .map((e) => SingleProduct(
                image: e.image,
                price: e.price,
                name: e.name,
              ))
          .toList(),
    );
  }

  void getProduct() {}

  @override
  Widget buildSuggestions(BuildContext context) {
    ProductProvider providerProvider = Provider.of(context);
    List<Product> searchProduct = providerProvider.searchProductList(query);
    return GridView.count(
      childAspectRatio: 0.87,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: searchProduct
          .map((e) => SingleProduct(
                image: e.image,
                price: e.price,
                name: e.name,
              ))
          .toList(),
    );
  }
}
