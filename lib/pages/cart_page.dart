import 'package:flutter/material.dart';
import 'package:nike_store/models/cart.dart';
import 'package:nike_store/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Consumer<Cart>(builder: (context, value, child) {
          if (value.cart.isEmpty) {
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
                      itemCount: value.cart.length,
                      itemBuilder: (context, index) {
                        final shoe = value.getCart[index];
                        return CartItem(shoe: shoe);
                      }))
            ],
          );
        }));
  }
}
