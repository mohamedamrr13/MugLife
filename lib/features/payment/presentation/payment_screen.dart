import 'package:drinks_app/features/payment/presentation/widgets/payment_form_input_configurations.dart';
import 'package:drinks_app/utils/theme/app_theme.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        scrolledUnderElevation: 0,
        backgroundColor: AppTheme.bgScaffoldColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        centerTitle: true,
        title: Text("C h e c k o u t"),
      ),
      backgroundColor: AppTheme.bgScaffoldColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
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
                          backgroundColor: AppTheme.paymentPageprimaryColor,
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
          backgroundColor: AppTheme.greenBtnColor,
        ),
      );
    }
  }
}
