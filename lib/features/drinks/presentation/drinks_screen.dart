import 'package:drinks_app/features/home/data/models/drink_model.dart';
import 'package:drinks_app/features/home/presentation/widgets/custom_appbar.dart';
import 'package:drinks_app/utils/page_indicator_widget/custom_page_indicator_widget.dart';
import 'package:flutter/material.dart';

class DrinksScreen extends StatefulWidget {
  const DrinksScreen({super.key});

  @override
  State<DrinksScreen> createState() => _DrinksScreenState();
}

class _DrinksScreenState extends State<DrinksScreen>
    with TickerProviderStateMixin {
  PageController pageController = PageController(viewportFraction: 0.6);
  double currentIndex = 0;
  int selectedIndex = 1;
  int quantity = 1;

  @override
  void initState() {
    super.initState();

    pageController.addListener(() {
      setState(() {
        currentIndex = pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  List<DrinkModel> drinks = DrinkModel.drinks;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffF4F6F9),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: size * 0.05,
            child: CustomAppbar(
              color: Color(0xffF4F6F9),
              title: drinks[currentIndex.round()].name,
              subTitle: drinks[currentIndex.round()].title,
              endWidget: Text(
                "£${drinks[currentIndex.round()].price + selectedIndex * 15}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(),
            child: PageView.builder(
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
                        SizedBox(height: size * 0.17),
                        Stack(
                          children: [
                            Image.asset(
                              drinks[index].image,
                              height: size * 0.42,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 10,
                              child: Opacity(
                                opacity: 0.6,
                                child: Image.asset(
                                  "assets/drinks/Ellipse 2.png",
                                ),
                              ),
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
          ),
          // Page Indicator
          Positioned(
            left: 0,
            right: 0,
            bottom: 290,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CustomPageIndicatorWidget(
                currentIndex: currentIndex,
                listLength: drinks.length,
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 180,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  3,
                  (index) => _buildSizeSelector(index),
                ),
              ),
            ),
          ),

          // Bottom Action Section
          Positioned(
            left: 20,
            right: 20,
            bottom: 40,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Action buttons
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildActionButton(
                          "Add To Cart",
                          const Color(0xFF6C5CE7),
                          Colors.white,
                          () {},
                        ),
                        const SizedBox(height: 12),
                        _buildActionButton(
                          "Buy Now",
                          const Color(0xFF00B894),
                          Colors.white,
                          () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Quantity selector
                  SizedBox(width: 115, child: _buildQuantitySelector()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSelector(int index) {
    final isSelected = selectedIndex == index;
    final sizes = ["S", "M", "L"];
    final sizeNames = ["Small", "Medium", "Large"];

    return GestureDetector(
      onTap:
          () => setState(() {
            selectedIndex = index;
          }),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: isSelected ? 55 : 50,
            width: isSelected ? 55 : 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey[100],
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: const Color(0xFF6C5CE7).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                      : null,
            ),
            child: Center(
              child: Text(
                sizes[index],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            sizeNames[index],
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuantityButton(Icons.remove, () {
            if (quantity > 1) {
              setState(() {
                quantity--;
              });
            }
          }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              quantity.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
          ),
          _buildQuantityButton(Icons.add, () {
            setState(() {
              if (quantity < 40) {
                quantity++;
              }
            });
          }),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF6C5CE7)),
      ),
    );
  }
}
