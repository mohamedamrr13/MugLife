import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:drinks_app/utils/colors/app_colors.dart';
import 'package:drinks_app/utils/constants/app_constants.dart';

class PaymentFormInputConfigurations {
  static InputConfiguration get creditCardInputConfiguration {
    return InputConfiguration(
      // Card Holder Name styling
      cardHolderDecoration: _buildInputDecoration(
        labelText: AppConstants.cardHolder,
        prefixIcon: Icons.person_outline,
      ),

      // Card Number styling
      cardNumberDecoration: _buildInputDecoration(
        labelText: AppConstants.cardNumber,
        hintText: AppConstants.sixteenX,
        prefixIcon: Icons.credit_card,
      ),

      // Expiry Date styling
      expiryDateDecoration: _buildInputDecoration(
        labelText: AppConstants.expiryDate,
        hintText: AppConstants.expiryDateShort,
        prefixIcon: Icons.calendar_today,
      ),

      // CVV Code styling
      cvvCodeDecoration: _buildInputDecoration(
        labelText: AppConstants.cvv,
        hintText: AppConstants.threeX,
        prefixIcon: Icons.lock,
      ),

      // Text styles for input fields
      cardNumberTextStyle: _buildTextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
      cardHolderTextStyle: _buildTextStyle(fontWeight: FontWeight.w500),
      expiryDateTextStyle: _buildTextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      cvvCodeTextStyle: _buildTextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
      ),
    );
  }

  static InputDecoration _buildInputDecoration({
    required String labelText,
    String? hintText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: TextStyle(
        color: AppColors.paymentPageMainColor,
        fontSize: AppConstants.fontSizeLarge,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(
        color: AppColors.paymentPageMainColor.withOpacity(0.6),
        fontSize: AppConstants.fontSizeMedium,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(
          color: AppColors.paymentPageMainColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(color: AppColors.paymentPageMainColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(color: AppColors.errorColor, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(color: AppColors.errorColor, width: 2),
      ),
      filled: true,
      fillColor: AppColors.paymentPageMainColor.withOpacity(0.05),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingMedium,
      ),
      prefixIcon:
          prefixIcon != null
              ? Icon(
                prefixIcon,
                color: AppColors.paymentPageMainColor.withOpacity(0.7),
              )
              : null,
    );
  }

  static TextStyle _buildTextStyle({
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: AppColors.paymentPageMainColor,
      fontSize: AppConstants.fontSizeLarge,
      fontWeight: fontWeight ?? FontWeight.w500,
      letterSpacing: letterSpacing,
    );
  }

  // Alternative configurations for different themes or use cases
  static InputConfiguration get lightThemeInputConfiguration {
    return InputConfiguration(
      cardHolderDecoration: _buildLightInputDecoration(
        labelText: AppConstants.cardHolder,
        prefixIcon: Icons.person_outline,
      ),
      cardNumberDecoration: _buildLightInputDecoration(
        labelText: AppConstants.cardNumber,
        hintText: AppConstants.sixteenX,
        prefixIcon: Icons.credit_card,
      ),
      expiryDateDecoration: _buildLightInputDecoration(
        labelText: AppConstants.expiryDate,
        hintText: AppConstants.expiryDateShort,
        prefixIcon: Icons.calendar_today,
      ),
      cvvCodeDecoration: _buildLightInputDecoration(
        labelText: AppConstants.cvv,
        hintText: AppConstants.threeX,
        prefixIcon: Icons.lock,
      ),
      cardNumberTextStyle: _buildLightTextStyle(letterSpacing: 1.2),
      cardHolderTextStyle: _buildLightTextStyle(),
      expiryDateTextStyle: _buildLightTextStyle(letterSpacing: 0.5),
      cvvCodeTextStyle: _buildLightTextStyle(letterSpacing: 1.0),
    );
  }

  static InputDecoration _buildLightInputDecoration({
    required String labelText,
    String? hintText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: TextStyle(
        color: AppColors.textSecondary,
        fontSize: AppConstants.fontSizeMedium,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: TextStyle(
        color: AppColors.textSecondary.withOpacity(0.6),
        fontSize: AppConstants.fontSizeSmall,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
        borderSide: BorderSide(color: AppColors.dividerColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
        borderSide: BorderSide(
          color: AppColors.paymentPageMainColor,
          width: 1.5,
        ),
      ),
      filled: true,
      fillColor: AppColors.surfaceColor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppConstants.paddingSmall,
        vertical: AppConstants.paddingSmall,
      ),
      prefixIcon:
          prefixIcon != null
              ? Icon(
                prefixIcon,
                color: AppColors.textSecondary.withOpacity(0.7),
                size: 20,
              )
              : null,
    );
  }

  static TextStyle _buildLightTextStyle({double? letterSpacing}) {
    return TextStyle(
      color: AppColors.textPrimary,
      fontSize: AppConstants.fontSizeMedium,
      fontWeight: FontWeight.w400,
      letterSpacing: letterSpacing,
    );
  }
}
