import 'package:drinks_app/core/di/service_locator.dart';
import 'package:drinks_app/features/auth/data/models/address_model.dart';
import 'package:drinks_app/features/auth/presentation/cubit/address_cubit.dart';
import 'package:drinks_app/features/cart/data/models/cart_item_model.dart';
import 'package:drinks_app/features/payment/presentation/payment_options_view.dart';
import 'package:drinks_app/utils/shared/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
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
                      ShippingTextField(
                        controller: nameController,
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        prefixIcon: Icons.person_outline,
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
                      ShippingTextField(
                        controller: phoneController,
                        label: 'Phone Number',
                        hint: 'Enter your phone number',
                        prefixIcon: Icons.phone_outlined,
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
                      ShippingTextField(
                        controller: addressLine1Controller,
                        label: 'Address Line 1',
                        hint: 'Street address',
                        prefixIcon: Icons.location_on_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ShippingTextField(
                        controller: addressLine2Controller,
                        label: 'Address Line 2 (Optional)',
                        hint: 'Apartment, suite, etc.',
                        prefixIcon: Icons.home_outlined,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ShippingTextField(
                              controller: cityController,
                              label: 'City',
                              hint: 'Enter city',
                              prefixIcon: Icons.location_city_outlined,
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

class ShippingAppBar extends StatelessWidget {
  const ShippingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: true,
      expandedHeight: 100,
      collapsedHeight: 130,
      floating: true,
      stretch: false,
      pinned: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            context.isDark ? Brightness.light : Brightness.dark,
      ),

      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.isDark
                  ? Colors.white.withOpacity(0.3)
                  : Colors.white.withOpacity(0.8),
              context.isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.4),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color:
                context.isDark
                    ? Colors.white.withOpacity(0.2)
                    : Colors.white.withOpacity(0.6),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.primaryTextColor,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),

      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.isDark
                  ? Colors.black.withOpacity(0.5)
                  : Colors.white.withOpacity(0.9),
              context.isDark
                  ? Colors.black.withOpacity(0.7)
                  : Colors.white.withOpacity(0.5),
              Colors.transparent,
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
        child: ClipRRect(
          child: Container(
            decoration: BoxDecoration(
              color:
                  context.isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.3),
              border: Border(
                bottom: BorderSide(
                  color:
                      context.isDark
                          ? Colors.white.withOpacity(0.1)
                          : context.primaryColor.withOpacity(0.15),
                  width: 0.5,
                ),
              ),
            ),
            child: FlexibleSpaceBar(
              expandedTitleScale: 1,
              titlePadding: EdgeInsets.only(left: 60, bottom: 32),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shipping Details',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontSize: 36,
                      color: context.primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Enter your delivery information',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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

class ShippingTextField extends StatelessWidget {
  const ShippingTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: TextStyle(color: context.primaryTextColor, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon, color: context.primaryColor),
        labelStyle: TextStyle(color: context.secondaryTextColor),
        hintStyle: TextStyle(
          color: context.secondaryTextColor.withOpacity(0.5),
        ),
        filled: true,
        fillColor: context.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: context.dividerColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: context.dividerColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: context.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: context.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: context.errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

class SaveAddressCheckbox extends StatelessWidget {
  const SaveAddressCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.dividerColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color:
                context.isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
            blurRadius: context.isDark ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              onChanged: (newValue) {
                onChanged(newValue ?? false);
              },
              activeColor: context.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Save this address for future orders',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.primaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
