import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drinks_app/core/di/service_locator.dart';
import 'package:drinks_app/features/auth/presentation/cubit/user_cubit.dart';
import 'package:drinks_app/features/cart/data/models/cart_item_model.dart';
import 'package:drinks_app/features/cart/logic/cart_cubit/cart_cubit.dart';
import 'package:drinks_app/features/order/data/models/order_item_model.dart';
import 'package:drinks_app/features/order/data/models/order_model.dart';
import 'package:drinks_app/features/order/presentation/cubit/order_cubit.dart';
import 'package:drinks_app/utils/shared/custom_button.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paymob/flutter_paymob.dart';

class PaymentOptionScreen extends StatefulWidget {
  final Map<String, dynamic> shippingData;

  const PaymentOptionScreen({super.key, required this.shippingData});

  @override
  State<PaymentOptionScreen> createState() => _PaymentOptionScreenState();
}

class _PaymentOptionScreenState extends State<PaymentOptionScreen> {
  String _selectedPaymentMethod = 'Card';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<OrderCubit>()),
        BlocProvider(create: (context) => getIt<UserCubit>()),
      ],
      child: BlocListener<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderCreated) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Order placed successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );

            // Clear the cart
            context.read<CartCubit>().clearCart();

            // Navigate back to home after a short delay
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
          } else if (state is OrderFailure) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to create order: ${state.errMessage}'),
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              isLoading = false;
            });
          }
        },
        child: Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: _buildAppBar(context),
          body: _buildPaymentOptions(context),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.surfaceColor,
      foregroundColor: context.primaryTextColor,
      centerTitle: true,
      title: const Text(
        'Select Payment Method',
        style: TextStyle(fontSize: 22, fontFamily: 'Poppins'),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios_new_outlined,
          color: context.primaryTextColor,
        ),
      ),
    );
  }

  Widget _buildPaymentOptions(BuildContext context) {
    final totalAmount = widget.shippingData['totalAmount'] as double;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Order Summary
          _buildOrderSummary(context),
          const SizedBox(height: 30),
          Text(
            'Payment Method',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: 20),
          _buildPaymentOption(
            context: context,
            label: 'Pay with Card',
            icon: Icons.credit_card,
            isSelected: _selectedPaymentMethod == 'Card',
            onTap: () => _setSelectedPaymentMethod('Card'),
          ),
          const SizedBox(height: 20),
          _buildPaymentOption(
            context: context,
            label: 'Cash on Delivery',
            icon: Icons.money,
            isSelected: _selectedPaymentMethod == 'Cash',
            onTap: () => _setSelectedPaymentMethod('Cash'),
          ),
          const SizedBox(height: 30),
          const Spacer(),
          _buildConfirmPaymentButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final totalAmount = widget.shippingData['totalAmount'] as double;
    final cartItems = widget.shippingData['cartItems'] as List<CartItemModel>;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.dividerColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Items:',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
              Text(
                '${cartItems.length}',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.primaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Address:',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.shippingData['addressLine1']}, ${widget.shippingData['city']}',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.primaryTextColor,
            ),
          ),
          Divider(height: 24, color: context.dividerColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount:',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.primaryTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${totalAmount.toStringAsFixed(2)}',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? context.primaryColor : context.dividerColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? context.primaryColor
                      : context.secondaryTextColor,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: context.primaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmPaymentButton(BuildContext context) {
    return Center(
      child: CustomButton(
        isLoading: isLoading,
        onPressed: () => _processPayment(context),
        text: 'Confirm Payment',
        width: 300,
      ),
    );
  }

  void _setSelectedPaymentMethod(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  Future<void> _processPayment(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please log in to place an order'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final totalAmount = widget.shippingData['totalAmount'] as double;
    final cartItems = widget.shippingData['cartItems'] as List<CartItemModel>;

    if (_selectedPaymentMethod == 'Card') {
      // Process card payment
      await FlutterPaymob.instance.payWithCard(
        title: Text(
          "Card Payment",
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins',
            color: context.theme.isDark ? Colors.white : Colors.black,
          ),
        ),
        context: context,
        currency: "EGP",
        amount: totalAmount,
        onPayment: (response) {
          if (response.success) {
            // Payment successful, create order
            _createOrder(
              context: context,
              userId: currentUser.uid,
              cartItems: cartItems,
              totalAmount: totalAmount,
              paymentMethod: PaymentMethod.card,
              transactionId: response.transactionID,
              isPaid: true,
            );
          } else {
            // Payment failed
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Payment failed: ${response.message}'),
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              isLoading = false;
            });
          }
        },
      );
    } else {
      // Cash on delivery - create order immediately
      _createOrder(
        context: context,
        userId: currentUser.uid,
        cartItems: cartItems,
        totalAmount: totalAmount,
        paymentMethod: PaymentMethod.cash,
        transactionId: null,
        isPaid: false,
      );
    }
  }

  void _createOrder({
    required BuildContext context,
    required String userId,
    required List<CartItemModel> cartItems,
    required double totalAmount,
    required PaymentMethod paymentMethod,
    required String? transactionId,
    required bool isPaid,
  }) {
    // Convert cart items to order items
    final orderItems =
        cartItems.map((cartItem) {
          return OrderItemModel.fromProduct(
            product: cartItem.product,
            size: cartItem.product.size!,
            quantity: cartItem.quantity,
          );
        }).toList();

    // Create order model
    final order = OrderModel(
      userId: userId,
      items: orderItems,
      subtotal: totalAmount,
      deliveryFee: 0.0,
      totalAmount: totalAmount,
      status: OrderStatus.pending,
      paymentMethod: paymentMethod,
      paymentTransactionId: transactionId,
      isPaid: isPaid,
      shippingName: widget.shippingData['name'] as String,
      shippingPhone: widget.shippingData['phone'] as String,
      shippingAddressLine1: widget.shippingData['addressLine1'] as String,
      shippingAddressLine2: widget.shippingData['addressLine2'] as String,
      shippingCity: widget.shippingData['city'] as String,
    );

    // Create the order
    context.read<OrderCubit>().createOrder(order: order);

    // Update user statistics
    context.read<UserCubit>().updateUserProfile(
      userId: userId,
      updates: {
        'ordersCount': FieldValue.increment(1),
        'totalSpent': FieldValue.increment(totalAmount),
        'rewardPoints': FieldValue.increment(totalAmount ~/ 10),
      },
    );
  }
}
