import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/admin/adminExport.dart';
import 'package:flutter/material.dart';

class AdminOrderItems extends StatelessWidget {
  const AdminOrderItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Order').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data!.docs[index];
                  return SingleOrderProduct(
                    name: item['ProductName'],
                    price: item['ProductPrice'],
                    image: item['ProductImage'],
                    size: item['Product Size'],
                    color: item['Product Color'],
                    quantity: item['ProductQuantity'],
                  );
                },
              );
            } else {
              Center(
                child: Text(
                  'No Order yet',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
