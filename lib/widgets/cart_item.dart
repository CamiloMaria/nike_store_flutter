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
              Provider.of<Cart>(context, listen: false)
                  .removeFromCart(widget.shoe);
            },
          ),
        ),
      ),
    );
  }
}
