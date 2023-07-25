import 'package:e_commerce_app/admin/adminExport.dart';
import 'package:e_commerce_app/screens/screensExports.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
          title: const Text(
            'eShop',
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
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
              AdminUploadItems(),
              AdminOrderItems(),
            ],
          ),
        ),
      ),
    );
  }
}
