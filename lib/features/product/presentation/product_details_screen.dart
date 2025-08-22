import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:drinks_app/features/product/presentation/widgets/product_details_buttons_section.dart';
import 'package:drinks_app/features/product/presentation/widgets/product_details_image.dart';
import 'package:drinks_app/features/product/presentation/widgets/product_size_selector.dart';
import 'package:drinks_app/features/product/presentation/widgets/custom_appbar.dart';
import 'package:drinks_app/features/payment/presentation/payment_screen.dart';
import 'package:drinks_app/utils/theming/app_colors.dart';
import 'package:drinks_app/utils/page_indicator_widget/custom_page_indicator_widget.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    required this.products,
    required this.currentIndex,
  });
  final List<ProductModel> products;
  final double currentIndex;
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with TickerProviderStateMixin {
  PageController pageController = PageController(viewportFraction: 0.6);
  int selectedIndex = 1;
  int quantity = 1;
  late double currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
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
      backgroundColor: AppTheme.bgScaffoldColor,
      body: Stack(
        children: [
          // App Bar
          Positioned(
            left: 0,
            right: 0,
            top: size * 0.05,
            child: CustomAppbar(
              color: const Color(0xffF4F6F9),
              title: widget.products[currentIndex.round()].name,
              subTitle: widget.products[currentIndex.round()].description,
              prefixIcon: Text(
                "£${widget.products[currentIndex.round()].price + selectedIndex * 15}",
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
            itemCount: widget.products.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final scale = 1.1 - (currentIndex - index).abs() * 1;
              final translateY = (currentIndex - index).abs() * 400;

              return ProductDetailsImage(
                product: widget.products[index],
                scale: scale,
                translateY: translateY.toDouble(),
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
                listLength: widget.products.length,
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
            child: ProductDetailsButtonsSection(
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
