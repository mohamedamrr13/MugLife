import 'package:drinks_app/features/cart/data/models/cart_item_model.dart';
import 'package:drinks_app/features/cart/logic/cart_cubit/cart_cubit.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:drinks_app/features/payment/presentation/product_shipping_view.dart';
import 'package:drinks_app/features/product/presentation/widgets/product_details_buttons_section.dart';
import 'package:drinks_app/features/product/presentation/widgets/product_details_image.dart';
import 'package:drinks_app/features/product/presentation/widgets/product_size_selector.dart';
import 'package:drinks_app/features/product/presentation/widgets/custom_appbar.dart';
import 'package:drinks_app/core/utils/page_indicator_widget/custom_page_indicator_widget.dart';
import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late PageController pageController;
  int selectedIndex = 1;
  int quantity = 1;
  late double currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;

    pageController = PageController(
      viewportFraction: 0.6,
      initialPage: widget.currentIndex.round(),
    );

    pageController.addListener(() {
      setState(() {
        currentIndex = pageController.page ?? widget.currentIndex;
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

  void _onAddToCart() async {
    await BlocProvider.of<CartCubit>(context).addProductToCart(
      widget.products[currentIndex.toInt()],
      quantity,
      selectedIndex == 0
          ? 'Small'
          : selectedIndex == 1
          ? 'Medium'
          : 'Large',
    );
  }

  void _onBuyNow() {
    // Get the current product
    final currentProduct = widget.products[currentIndex.toInt()];

    // Get the selected size
    final selectedSize =
        selectedIndex == 0
            ? 'Small'
            : selectedIndex == 1
            ? 'Medium'
            : 'Large';

    // Update the product with the selected size
    final productWithSize = currentProduct.copyWith(size: selectedSize);

    // Create a cart item for this single product
    final cartItem = CartItemModel(
      product: productWithSize,
      quantity: quantity,
      addedAt: DateTime.now(),
    );

    // Calculate total amount
    final totalAmount = cartItem.totalPrice;

    // Navigate to shipping screen with this single item
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                ShippingScreen(cartItems: [cartItem], totalAmount: totalAmount),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      body: Stack(
        children: [
          // App Bar
          Positioned(
            left: 0,
            right: 0,
            child: CustomAppbar(
              color: context.theme.scaffoldBackgroundColor,
              title: widget.products[currentIndex.round()].name,
              prefixIcon: Text(
                "£${widget.products[currentIndex.toInt()].getPriceForSizeIndex(selectedIndex)}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: context.primaryTextColor,
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
              onBuyNow: _onBuyNow,
            ),
          ),
        ],
      ),
    );
  }
}
