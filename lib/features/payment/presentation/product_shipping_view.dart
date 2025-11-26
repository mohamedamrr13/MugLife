import 'package:drinks_app/core/di/service_locator.dart';
import 'package:drinks_app/core/utils/shared/custom_textfield.dart';
import 'package:drinks_app/features/auth/data/models/address_model.dart';
import 'package:drinks_app/features/auth/presentation/cubit/address_cubit.dart';
import 'package:drinks_app/features/cart/data/models/cart_item_model.dart';
import 'package:drinks_app/features/payment/presentation/payment_options_view.dart';
import 'package:drinks_app/core/utils/shared/custom_button.dart';
import 'package:drinks_app/features/payment/presentation/widgets/save_address_checkbox.dart';
import 'package:drinks_app/features/payment/presentation/widgets/shipping_screen_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShippingScreen extends StatefulWidget {
  final List<CartItemModel> cartItems;
  final double totalAmount;

  const ShippingScreen({
    super.key,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  State<ShippingScreen> createState() => ShippingScreenState();
}

class ShippingScreenState extends State<ShippingScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: 'Mohamed Ahmed');
  final phoneController = TextEditingController(text: '01234567890');
  final addressLine1Controller = TextEditingController(text: '123 Main St');
  final addressLine2Controller = TextEditingController(text: '');
  final cityController = TextEditingController(text: 'Alexandria');

  bool saveAddress = false;
  bool isSavingAddress = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();

    super.dispose();
  }

  void handleContinue() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isSavingAddress = true;
      });

      // Save address if checkbox is checked
      if (saveAddress) {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          final address = AddressModel(
            name: nameController.text.trim(),
            phone: phoneController.text.trim(),
            addressLine1: addressLine1Controller.text.trim(),
            addressLine2: addressLine2Controller.text.trim(),
            city: cityController.text.trim(),
            isDefault: false,
          );

          // Save the address using AddressCubit
          context.read<AddressCubit>().addAddress(
            userId: currentUser.uid,
            address: address,
          );
        }
      }

      // Prepare shipping data to pass to payment screen
      final shippingData = {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'addressLine1': addressLine1Controller.text.trim(),
        'addressLine2': addressLine2Controller.text.trim(),
        'city': cityController.text.trim(),
        'cartItems': widget.cartItems,
        'totalAmount': widget.totalAmount,
      };

      setState(() {
        isSavingAddress = false;
      });

      // Navigate to payment screen with shipping data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentOptionScreen(shippingData: shippingData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddressCubit>(),
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            ShippingAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShippingSectionHeader(title: 'Personal Information'),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: nameController,
                        label: 'Full Name',
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(Icons.person_outline),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          if (value.trim().length < 3) {
                            return 'Name must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: phoneController,
                        label: 'Phone Number',
                        hintText: 'Enter your phone number',
                        prefixIcon: Icon(Icons.phone_outlined),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (value.trim().length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      ShippingSectionHeader(title: 'Shipping Address'),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: addressLine1Controller,
                        label: 'Address Line 1',
                        hintText: 'Street address',
                        prefixIcon: Icon(Icons.location_on_outlined),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: addressLine2Controller,
                        label: 'Address Line 2 (Optional)',
                        hintText: 'Apartment, suite, etc.',
                        prefixIcon: Icon(Icons.home_outlined),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              controller: cityController,
                              label: 'City',
                              hintText: 'Enter city',
                              prefixIcon: Icon(Icons.location_city_outlined),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Order Summary
                      _buildOrderSummary(context),
                      const SizedBox(height: 24),
                      SaveAddressCheckbox(
                        value: saveAddress,
                        onChanged: (value) {
                          setState(() {
                            saveAddress = value;
                          });
                        },
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        onPressed: isSavingAddress ? null : handleContinue,
                        text: 'Continue to Payment',
                        icon: Icon(Icons.arrow_forward_rounded, size: 20),
                        isLoading: isSavingAddress,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
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
                '${widget.cartItems.length}',
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
                'Total Amount:',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.primaryTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${widget.totalAmount.toStringAsFixed(2)}',
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
}

class ShippingSectionHeader extends StatelessWidget {
  const ShippingSectionHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: context.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.primaryTextColor,
          ),
        ),
      ],
    );
  }
}
