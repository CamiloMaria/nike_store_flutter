import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:nike_store/models/cart.dart';
import 'package:nike_store/models/shoe.dart';
import 'package:nike_store/widgets/shoes_title.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final TextEditingController _textController = TextEditingController();

  Stream<List<Shoe>> fetchShoesFromFirestore() {
    return FirebaseFirestore.instance
        .collection('shoes')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Shoe.fromFirestore(doc.data()))
          .toList();
    });
  }

  void addShoeToCart(Shoe shoe) async {
    // Generate a unique ID for the shoe
    String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
    shoe.id = uniqueId;

    Provider.of<Cart>(context, listen: false).addToCart(shoe);

    Map<String, dynamic> shoeData = shoe.toMap();

    await FirebaseFirestore.instance
        .collection('cart')
        .doc(uniqueId)
        .set(shoeData)
        .then((docRef) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to Cart and saved to Firestore'),
          duration: Duration(seconds: 1),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding to Firestore: $error'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Cart>(
        builder: (context, cart, child) => SingleChildScrollView(
          child: Column(
            children: [
              _buildSearchBar(),
              _buildInspirationalQuote(),
              _buildHotPicksHeader(context),
              StreamBuilder<List<Shoe>>(
                stream: fetchShoesFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return Center(child: Text('No shoes found'));
                  }
                  // Update the _buildShoesList method to work with Firestore data
                  return _buildShoesList(snapshot.data!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: AnimSearchBar(
        width: 480,
        textController: _textController,
        onSuffixTap: () => _textController.clear(),
        onSubmitted: (value) => print(value),
      ),
    );
  }

  Widget _buildInspirationalQuote() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Text(
        'Everyone flies... some fly longer than others.',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildHotPicksHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'Hot Picks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'View All',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildShoesList(List<Shoe> shoes) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: shoes.length,
        itemBuilder: (context, index) {
          Shoe shoe = shoes[index];
          return ShoesTitle(
            shoes: shoe,
            onTap: () => addShoeToCart(shoe),
          );
        },
      ),
    );
  }
}
