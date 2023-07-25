import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/admin/adminExport.dart';
import 'package:e_commerce_app/model/modelExports.dart';
import 'package:e_commerce_app/screens/screensExports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminOrderItems extends StatefulWidget {
  const AdminOrderItems({super.key});

  @override
  State<AdminOrderItems> createState() => _AdminOrderItemsState();
}

class _AdminOrderItemsState extends State<AdminOrderItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: productProvider!.getCheckOutModelListLength,
          itemBuilder: (context, index) => SingleOrderProduct(
            index: index,
            color: productProvider!.getCheckOutModelList[index].color,
            size: productProvider!.getCheckOutModelList[index].size,
            image: productProvider!.getCheckOutModelList[index].image,
            name: productProvider!.getCheckOutModelList[index].name,
            price: productProvider!.getCheckOutModelList[index].price,
            quantity: productProvider!.getCheckOutModelList[index].quantity,
          ),
        ),
      ),
    );
  }
}

class AdminOrder extends StatelessWidget {
  const AdminOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Order')
                .orderBy('Product', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data!.docs[index].data();
                    return SingleOrderProduct(
                      color: item['Product'][0]['Product Color'],
                      size: item['Product'][0]['Product Size'],
                      image: item['Product'][0]['ProductImage'],
                      name: item['Product'][0]['ProductName'],
                      price: item['Product'][0]['ProductPrice'],
                      quantity: item['Product'][0]['ProductQuantity'],
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No order yet'),
                );
              }
            }),
      ),
    );
  }
}
