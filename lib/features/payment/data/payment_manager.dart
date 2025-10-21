import 'package:drinks_app/utils/helper/secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paymob/flutter_paymob.dart';

class PaymentManager {
  static Future<void> initializePaymentGateway() async {
    await dotenv.load(fileName: ".env");

    PaymobSecureStorage.setApiKey();
    PaymobSecureStorage.setMobileWalletId();
    PaymobSecureStorage.setTransactionId();
    await FlutterPaymob.instance.initialize(
      apiKey: await (AppSecureStorage.getString('api_key')) ?? '',
      integrationID: int.parse(
        await AppSecureStorage.getString('transaction_id') ?? '',
      ), // Card integration ID
      walletIntegrationId: int.parse(
        await AppSecureStorage.getString('wallet_id') ?? '0',
      ), // Wallet integration ID

      iFrameID: 934476, // Paymob iframe ID
    );
  }
}
