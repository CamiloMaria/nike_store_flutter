import 'package:flutter/material.dart';
import 'package:nike_store/models/shoe.dart';

class Cart extends ChangeNotifier {
  // List of items in the cart
  List<Shoe> cart = [];

  // get list of items in the cart
  List<Shoe> get getCart => cart;

  // add item to the cart
  void addToCart(Shoe shoe) {
    cart.add(shoe);
    notifyListeners();
  }

  // remove item from the cart
  void removeFromCart(Shoe shoe) {
    cart.remove(shoe);
    notifyListeners();
  }

  // get total price of items in the cart
  int totalPrice() {
    int total = 0;
    for (Shoe shoes in cart) {
      total += int.parse(shoes.price);
    }
    return total;
  }
}
