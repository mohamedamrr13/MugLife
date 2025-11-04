import 'package:drinks_app/utils/shared/custom_button.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paymob/flutter_paymob.dart';

class PaymentOptionScreen extends StatefulWidget {
  const PaymentOptionScreen({super.key});

  @override
  State<PaymentOptionScreen> createState() => _PaymentOptionScreenState();
}

class _PaymentOptionScreenState extends State<PaymentOptionScreen> {
  String _selectedPaymentMethod = 'Card';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: _buildAppBar(context),
      body: _buildPaymentOptions(context),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            label: 'Pay with Cash',
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
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          if (_selectedPaymentMethod == 'Card') {
            await FlutterPaymob.instance.payWithCard(
              title: Text(
                "Card Payment",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              context: context,
              currency: "EGP",
              amount: 150,
              onPayment: (response) {
                if (response.success) {
                  debugPrint(
                    "🎉 Payment Success! TxID: ${response.transactionID}",
                  );
                } else {
                  debugPrint(
                    "🎉 Payment Success! TxID: ${response.transactionID}",
                  );
                  ("❌ Payment Failed: ${response.message}");
                }
              },
            );
          } else {
            //TODO: Pay With Cash
          }
          setState(() {
            isLoading = false;
          });
        },
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
}
