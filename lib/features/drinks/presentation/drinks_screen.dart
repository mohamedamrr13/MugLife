import 'package:drinks_app/features/home/data/models/drink_model.dart';
import 'package:flutter/material.dart';

class DrinksScreen extends StatefulWidget {
  const DrinksScreen({super.key});

  @override
  State<DrinksScreen> createState() => _DrinksScreenState();
}

class _DrinksScreenState extends State<DrinksScreen> {
  PageController pageController = PageController(viewportFraction: 0.5);
  double currentIndex = 0;
  @override
  void initState() {
    pageController.addListener(() {
      setState(() {
        currentIndex = pageController.page ?? 1;
      });
    });
    super.initState();
  }

  List<DrinkModel> drinks = DrinkModel.drinks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: 20,
            right: 20,
            top: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      drinks[currentIndex.round()].name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(drinks[currentIndex.round()].title),
                  ],
                ),
                Text(
                  "£${drinks[currentIndex.round()].price}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          PageView.builder(
            controller: pageController,
            itemCount: drinks.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final scale = 1.1 - (currentIndex - index).abs() * 1;
              final translateY = (currentIndex - index).abs() * 400;
              return Transform.translate(
                offset: Offset(translateY, 0),
                child: Transform.scale(
                  scale: scale.clamp(0.5, 1.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.asset(drinks[index].image, height: 900),
                          Positioned(
                            bottom: 200,
                            right: 0,
                            left: 10,
                            child: Image.asset("assets/drinks/Ellipse 2.png"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: _buildPageIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        drinks.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentIndex.round() == index ? 36 : 8,
          height: 8,
          decoration: BoxDecoration(
            color:
                currentIndex.round() == index
                    ? Colors.black45
                    : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
