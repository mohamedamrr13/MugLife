class DrinkModel {
  String image;
  String name;
  String title;

  int price;

  DrinkModel({
    required this.name,
    required this.title,
    required this.image,
    required this.price,
  });

  static List<DrinkModel> drinks = [
    DrinkModel(
      image: "assets/drinks/Banana.png",
      name: "Banana",
      title: "5 Cups of different flavours",
      price: 23,
    ),

    DrinkModel(
      image: "assets/drinks/Salted Caramel.png",
      name: "Milkshake",
      title: "20 Cups of different flavours",
      price: 20,
    ),

    DrinkModel(
      image: "assets/drinks/Chocolate.png",
      name: "Chocolate Drinks",
      title: "15 Cups of different flavours",
      price: 10,
    ),

    DrinkModel(
      image: "assets/drinks/Strawberry.png",
      name: "Strawberry",
      title: "3 Cups of different flavours",
      price: 40,
    ),

    DrinkModel(
      image: "assets/drinks/Banana.png",
      name: "Banana",
      title: "20 Cups of different flavours",
      price: 23,
    ),

    DrinkModel(
      image: "assets/drinks/Salted Caramel.png",
      name: "Milkshake",
      title: "20 Cups of different flavours",
      price: 20,
    ),

    DrinkModel(
      image: "assets/drinks/Chocolate.png",
      name: "Chocolate Drinks",
      title: "20 Cups of different flavours",
      price: 10,
    ),

    DrinkModel(
      image: "assets/drinks/Strawberry.png",
      name: "Strawberry",
      title: "3 Cups of different flavours",
      price: 40,
    ),

    DrinkModel(
      image: "assets/drinks/Salted Caramel.png",
      name: "Milkshake",
      title: "20 Cups of different flavours",
      price: 20,
    ),
  ];
}
