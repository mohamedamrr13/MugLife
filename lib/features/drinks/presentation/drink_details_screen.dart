// drinks_screen.dart
import 'package:drinks_app/features/drinks/presentation/widgets/drink_buttons_section.dart';
import 'package:drinks_app/features/drinks/presentation/widgets/drink_item.dart';
import 'package:drinks_app/features/drinks/presentation/widgets/drink_size_selector.dart';
import 'package:drinks_app/features/home/data/models/drink_model.dart';
import 'package:drinks_app/features/drinks/presentation/widgets/custom_appbar.dart';
import 'package:drinks_app/features/payment/presentation/payment_screen.dart';
import 'package:drinks_app/utils/colors/app_colors.dart';
import 'package:drinks_app/utils/page_indicator_widget/custom_page_indicator_widget.dart';
import 'package:flutter/material.dart';

class DrinksDetailsScreen extends StatefulWidget {
  const DrinksDetailsScreen({super.key});

  @override
  State<DrinksDetailsScreen> createState() => _DrinksDetailsScreenState();
}

class _DrinksDetailsScreenState extends State<DrinksDetailsScreen>
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

  void _onSizeSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _onQuantityChanged(int newQuantity) {
    setState(() {
      quantity = newQuantity;
    });
  }

  void _onAddToCart() {
    // Implement add to cart functionality
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.bgScaffoldColor,
      body: Stack(
        children: [
          // App Bar
          Positioned(
            left: 0,
            right: 0,
            top: size * 0.05,
            child: CustomAppbar(
              color: const Color(0xffF4F6F9),
              title: drinks[currentIndex.round()].name,
              subTitle: drinks[currentIndex.round()].title,
              prefixIcon: Text(
                "£${drinks[currentIndex.round()].price + selectedIndex * 15}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Drinks PageView
          PageView.builder(
            controller: pageController,
            itemCount: drinks.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final scale = 1.1 - (currentIndex - index).abs() * 1;
              final translateY = (currentIndex - index).abs() * 400;

              return DrinkItem(
                drink: drinks[index],
                scale: scale,
                translateY: translateY,
                screenHeight: size,
              );
            },
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

          // Size Selector
          Positioned(
            left: 0,
            right: 0,
            bottom: 180,
            child: SizeSelector(
              selectedIndex: selectedIndex,
              onSizeSelected: _onSizeSelected,
            ),
          ),

          // Bottom Action Section
          Positioned(
            left: 20,
            right: 20,
            bottom: 40,
            child: ActionButtonsSection(
              quantity: quantity,
              onQuantityChanged: _onQuantityChanged,
              onAddToCart: _onAddToCart,
              onBuyNow:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PaymentScreen();
                      },
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
