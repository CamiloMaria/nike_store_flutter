class Shoe {
  String id;
  final String name;
  final String price;
  final String picture;
  final String description;

  Shoe(
      {required this.id,
      required this.name,
      required this.picture,
      required this.price,
      required this.description});

  toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'picture': picture,
      'description': description,
    };
  }

  factory Shoe.fromFirestore(data) {
    return Shoe(
      id: data['id'],
      name: data['name'],
      price: data['price'],
      picture: data['picture'],
      description: data['description'],
    );
  }
}
