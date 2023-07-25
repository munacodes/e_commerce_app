import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/admin/adminExport.dart';
import 'package:e_commerce_app/model/modelExports.dart';
import 'package:e_commerce_app/screens/screensExports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminOrderItems extends StatelessWidget {
  const AdminOrderItems({super.key});

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
                  child: Text(
                    'No order yet',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
