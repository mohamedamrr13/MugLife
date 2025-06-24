import 'package:drinks_app/features/payment/presentation/widgets/payment_form_input_configurations.dart';
import 'package:drinks_app/utils/colors/app_colors.dart';
import 'package:drinks_app/utils/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool showBackView = false;
  bool onCreditCardWidgetChange = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.bgScaffoldColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        centerTitle: true,
        title: Text("C h e c k o u t"),
      ),
      backgroundColor: AppColors.bgScaffoldColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  CreditCardWidget(
                    isHolderNameVisible: true,
                    isSwipeGestureEnabled: true,
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvCode,
                    showBackView: showBackView,
                    onCreditCardWidgetChange: (creditCardBrand) {
                      // Handle credit card brand change if needed
                    },
                  ),

                  // Add padding around the form
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingMedium,
                      vertical: AppConstants.paddingSmall,
                    ),
                    child: CreditCardForm(
                      inputConfiguration:
                          PaymentFormInputConfigurations
                              .creditCardInputConfiguration,
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      onCreditCardModelChange: (data) {
                        setState(() {
                          cardNumber = data.cardNumber;
                          expiryDate = data.expiryDate;
                          cvvCode = data.cvvCode;
                          cardHolderName = data.cardHolderName;
                        });
                      },
                      // Use the class-level GlobalKey instead of creating new one
                      formKey: _formKey,
                    ),
                  ),

                  // Payment button with proper spacing
                  Padding(
                    padding: EdgeInsets.all(AppConstants.paddingLarge),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isFormValid() ? _processPayment : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.paymentPageMainColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium,
                            ),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          AppConstants.processPayment,
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeLarge,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Add bottom padding for safe area
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isFormValid() {
    return cardNumber.isNotEmpty &&
        expiryDate.isNotEmpty &&
        cardHolderName.isNotEmpty &&
        cvvCode.isNotEmpty;
  }

  void _processPayment() {
    // Validate form before processing
    if (_formKey.currentState?.validate() ?? false) {
      // Add your payment processing logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppConstants.processPayment),
          backgroundColor: AppColors.greenBtnColor,
        ),
      );
    }
  }
}
