import 'package:drinks_app/features/cart/logic/cart_cubit/cart_cubit.dart';
import 'package:drinks_app/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:drinks_app/features/cart/presentation/widgets/cart_summary_widget.dart';
import 'package:drinks_app/features/cart/presentation/widgets/empty_cart_widget.dart';
import 'package:drinks_app/utils/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
  }

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
          BlocConsumer<CartCubit, CartState>(
            listener: (context, state) {
              if (state is CartCleared) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Cart cleared')));
              } else if (state is CartFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.errMessage}')),
                );
              }
            },

            builder: (context, state) {
              final shouldHideButton =
                  state is CartCleared ||
                  (state is CartLoaded && state.items.isEmpty);
              return shouldHideButton
                  ? SizedBox.shrink()
                  : TextButton(
                    onPressed: () {
                      _showClearCartDialog(
                        context,
                        onPressed: () {
                          BlocProvider.of<CartCubit>(context).clearCart();
                          Navigator.pop(context);
                        },
                      );
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
                      context.read<CartCubit>().clearCart();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is CartLoaded) {
            if (state.items.isEmpty) {
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
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      return CartItemWidget(
                        item: state.items[index],
                        onQuantityChanged: (newQuantity) {
                          BlocProvider.of<CartCubit>(context).updateCartItem(
                            state.items[index],
                            newQuantity,
                            state.items[index].product.price,
                          );
                          // Recalculate and log debug total (quantity * price)
                          final double dbgtotal = state.items.fold<double>(
                            0.0,
                            (previousValue, item) =>
                                previousValue +
                                (item.quantity * item.product.price),
                          );
                          debugPrint('Cart total debug: $dbgtotal');
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
                        CartSummaryWidget(total: state.total),
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
                Container(color: theme.colorScheme.surface, height: 90),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showClearCartDialog(
    BuildContext context, {
    required VoidCallback onPressed,
  }) {
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
              onPressed: onPressed,
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
    //Navigator.pushNamed(context, App);
  }
}
