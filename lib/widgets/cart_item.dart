import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_store/models/cart.dart';
import 'package:nike_store/models/shoe.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  const CartItem({super.key, required this.shoe});
  final Shoe shoe;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  void removeFromCart(Shoe shoe) async {
    Provider.of<Cart>(context, listen: false).removeFromCart(shoe);

    try {
      await FirebaseFirestore.instance.collection('cart').doc(shoe.id).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from Cart and Firestore'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing from Firestore: $error'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: Image.asset(widget.shoe.picture, width: 50, height: 50),
          title: Text(widget.shoe.name),
          subtitle: Text('\$${widget.shoe.price}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              removeFromCart(widget.shoe);
            },
          ),
        ),
      ),
    );
  }
}
