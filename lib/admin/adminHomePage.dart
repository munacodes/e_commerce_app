import 'package:e_commerce_app/admin/adminExport.dart';
import 'package:e_commerce_app/model/modelExports.dart';
import 'package:e_commerce_app/provider/providerExports.dart';
import 'package:e_commerce_app/screens/screensExports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  CategoryProvider? categoryProvider;
  ProductProvider? productProvider;

  UserModel? userModel;
  CartModel? cartModel;

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    productProvider!.getUserData();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => AdminLogin(),
                ),
              );
            },
          ),
          centerTitle: true,
          title: const Text(
            'eShop',
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Uploaded Items',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ),
              Tab(
                child: Text(
                  'Upload Items',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ),
              Tab(
                child: Text(
                  'Ordered Items',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ),
            ],
            indicatorColor: Colors.black38,
            indicatorWeight: 5.0,
          ),
        ),
        body: Container(
          child: TabBarView(
            children: [
              ViewUploadedItems(),
              AdminUploadItems(),
              AdminOrderItems(),
            ],
          ),
        ),
      ),
    );
  }
}
