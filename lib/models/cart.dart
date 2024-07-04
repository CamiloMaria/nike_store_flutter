import 'package:flutter/material.dart';
import 'package:nike_store/models/shoe.dart';

class Cart extends ChangeNotifier {
  List<Shoe> shoesShop = [
    Shoe(
      name: 'Nike Air Max 90',
      price: '10,000',
      description: 'The Nike Air Max 90.',
      picture: 'assets/images/sneakers-1.png',
    ),
    Shoe(
      name: 'Nike Air Max 95',
      price: '12,000',
      description: 'The Nike Air Max 95.',
      picture: 'assets/images/sneakers-2.jpg',
    ),
    Shoe(
      name: 'Nike Air Max 97',
      price: '15,000',
      description: 'The Nike Air Max 97.',
      picture: 'assets/images/sneakers-3.png',
    ),
    Shoe(
      name: 'Nike Air Max 270',
      price: '18,000',
      description: 'The Nike Air Max 270.',
      picture: 'assets/images/sneakers-4.png',
    ),
  ];

  // List of items in the cart
  List<Shoe> cart = [];

  // get list of shoes for sale
  List<Shoe> get getShoes => shoesShop;

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
