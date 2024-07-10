import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:nike_store/models/cart.dart';
import 'package:nike_store/models/shoe.dart';
import 'package:nike_store/widgets/shoes_tile.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final TextEditingController _textController = TextEditingController();
  List<String> inspirationalQuotes = [
    "Everyone flies... some fly longer than others.",
    "The only limit is the one you set yourself.",
    "Dream big and dare to fail."
  ];
  String selectedQuote = "";

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
  void initState() {
    super.initState();
    selectedQuote = (inspirationalQuotes..shuffle()).first;
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
              _buildShoesGrid(),
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
        onSubmitted: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildInspirationalQuote() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Text(
        selectedQuote,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildHotPicksHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Hot Picks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildShoesGrid() {
    return StreamBuilder<List<Shoe>>(
      stream: fetchShoesFromFirestore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No shoes found'));
        }
        var shoes = snapshot.data!;
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
          ),
          itemCount: shoes.length,
          itemBuilder: (context, index) {
            Shoe shoe = shoes[index];
            return ShoesTile(
              shoe: shoe,
              onTap: () => addShoeToCart(shoe),
            );
          },
        );
      },
    );
  }
}
