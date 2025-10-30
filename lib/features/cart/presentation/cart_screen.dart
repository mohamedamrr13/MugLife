import 'package:drinks_app/features/cart/data/models/cart_item_model.dart';
import 'package:drinks_app/features/cart/logic/cart_cubit/cart_cubit.dart';
import 'package:drinks_app/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:drinks_app/features/cart/presentation/widgets/cart_summary_widget.dart';
import 'package:drinks_app/features/cart/presentation/widgets/empty_cart_widget.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:drinks_app/utils/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,

        title: Text(
          'My Cart',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return TextButton(
                onPressed: () {
                  _showClearCartDialog(context);
                },
                child: Text(
                  'Clear',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }

          if (state is CartFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // context.read<CartCubit>().clearError();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (context.read<CartCubit>().isCartEmpty() == true) {
            return const EmptyCartWidget();
          }

          return Column(
            children: [
              // Cart Items List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return CartItemWidget(
                      item: CartItemModel(
                        product: ProductModel(
                          name: 'Sample Drink',
                          description: 'A refreshing sample beverage.',
                          category: 'Beverage',
                          image: 'https://via.placeholder.com/150',
                          price: 4.99,
                          size: 'Regular',
                        ),
                        addedAt: DateTime.now(),
                      ),
                      onQuantityChanged: (newQuantity) {
                        context.read<CartCubit>().addProductToCart(
                          ProductModel(
                            name: 'Sample Drink',
                            description: 'A refreshing sample beverage.',
                            category: 'Beverage',
                            image: 'https://via.placeholder.com/150',
                            price: 4.99,
                          ),
                          1,
                          'Regular',
                        );
                      },
                      onRemove: () {
                        // context.read<CartCubit>().removeFromCart(item.id);
                      },
                    );
                  },
                ),
              ),

              // Cart Summary and Checkout
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.outline.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CartSummaryWidget(state: state),
                      const SizedBox(height: 20),
                      CustomButton(
                        onPressed: () {
                          _proceedToCheckout(context, state);
                        },
                        text: 'Proceed to Checkout',
                        height: 56,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: Text(
            'Clear Cart',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Are you sure you want to remove all items from your cart?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //context.read<CartCubit>().clearCart();
                Navigator.pop(context);
              },
              child: Text(
                'Clear',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _proceedToCheckout(BuildContext context, CartState state) {
    // Navigate to payment/checkout screen
    Navigator.pushNamed(context, '/payment');
  }
}
