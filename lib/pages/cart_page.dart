import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nike_store/models/shoe.dart';
import 'package:nike_store/widgets/cart_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  Stream<List<Shoe>> fetchCartsFromFirestore() {
    return FirebaseFirestore.instance
        .collection('cart')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Shoe.fromFirestore(doc.data()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<Shoe>>(
        stream: fetchCartsFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data?.isEmpty == true) {
            return Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data?[index];
                    var shoe = Shoe.fromFirestore(doc!.toMap());
                    return CartItem(shoe: shoe);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
