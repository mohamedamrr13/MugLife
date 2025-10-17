import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paymob/flutter_paymob.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  String _selectedPaymentMethod = 'Card';

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
      title: const Text('Select Payment Method'),
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
      child: ElevatedButton(
        onPressed: () async {
          if (_selectedPaymentMethod == 'Card') {
            await FlutterPaymob.instance.payWithCard(
              title: Text("Card Payment"), // Optional - Custom title AppBar
              appBarColor: Colors.blueAccent, // Optional - Custom AppBar color
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
          }else{
            
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: context.primaryColor,
          foregroundColor: Colors.white,
        ),
        child: const Text(
          'Confirm Payment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _setSelectedPaymentMethod(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }
}
