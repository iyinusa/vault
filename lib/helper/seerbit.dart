import 'package:flutter/material.dart';
import 'package:seerbit_flutter/seerbit_flutter.dart';
import 'package:vault/logics/vault.dart';

import '../home.dart';
import 'api.dart';
import 'constant.dart';
import 'router.dart';
import 'utils.dart';

class SeerBitPay {
  final utils = Utils();
  final api = Api();

  // simple checkout
  /// The `simpleCheckout` function in Dart is used to initiate a payment transaction using the SeerBit payment gateway, with optional parameters for customization.
  ///
  /// Args:
  ///   context: The `context` parameter is the current build context of the widget tree. It is typically passed from the widget's build method using the `BuildContext` object. It is used to access the current state of the widget and to navigate to other screens or perform other actions.
  ///   fullName: The full name of the customer making the payment.
  ///   email: The email parameter is used to specify the email address of the customer who is making the payment.
  ///   amount: The `amount` parameter is the total amount to be paid by the customer. It represents the cost of the item or service being purchased.
  ///   description (String): A string that describes the purpose or nature of the payment. If not provided, it defaults to 'SeerBit Payment'.
  ///   currency (String): The currency parameter is used to specify the currency in which the payment should be made. It is an optional parameter and if not provided, it defaults to 'NGN' (Nigerian Naira).
  ///   country (String): The "country" parameter is used to specify the country for the payment transaction. It is an optional parameter and if not provided, it defaults to 'NG' (Nigeria).
  simpleCheckout(
    context,
    fullName,
    email,
    amount, {
    String? description,
    String? currency,
    String? country,
    String? subAccountID,
  }) async {
    PayloadModel payload = PayloadModel(
      fullName: fullName,
      email: email,
      amount: amount,
      description: description ?? 'SeerBit Payment',
      currency: currency ?? 'NGN',
      country: country ?? 'NG',
      transRef: utils.random(12),
      publicKey: pubKey,
      pocketRef: "",
      vendorId: subAccountID ?? "",
      closeOnSuccess: false,
      closePrompt: false,
      setAmountByCustomer: false,
      tokenize: false,
      planId: "",
      customization: const CustomizationModel(
        borderColor: '#000000',
        backgroundColor: '#004C64',
        buttonColor: '#0084A0',
        paymentMethod: [
          PayChannel.account,
          PayChannel.transfer,
          PayChannel.card,
          PayChannel.momo
        ],
        confetti: false,
        logo: 'https://solvsai.com/assets/images/logo.png', // your custom logo
      ),
    );

    await SeerbitMethod().startPayment(context, payload: payload,
        onSuccess: (response) {
      // debugPrint(response);

      // save transactions
      final Map<String, dynamic> payments = response['payments'];
      MyVault().addTransaction(
        ref: payments['paymentReference'],
        type: 'Simple Checkout',
        date: payments['transactionProcessedTime'],
      );
      navTo(page: const HomeScreen());
    }, onCancel: (e) {
      debugPrint(e);
      return false;
    });
  }

  /// The function performs a standard checkout by making a POST request to the 'payments' endpoint with the provided data.
  ///
  /// Args:
  ///   data: The `data` parameter is the payload or data that you want to send in the request. It could be an object or a map containing the necessary information for the payment.
  ///
  /// Returns:
  ///   The `standardCheckout` function is returning the result of the `api.postCall` function, which is an asynchronous call to the 'payments' endpoint with the provided data.
  standardCheckout(data) async {
    return await api.postCall(endpoint: 'payments/', data: data);
  }

  // create virtual account
  /// The function `creatVirtualAccount` creates a virtual account by making a POST request to an API endpoint and returns the response data if the status is 'SUCCESS'.
  ///
  /// Args:
  ///   data: The `data` parameter is the data that you want to send in the request body when creating a virtual account. It should be a JSON object containing the necessary information for creating the
  /// virtual account.
  ///
  /// Returns:
  ///   either the decoded JSON data from the response if the status is 'SUCCESS', or null if there is an error or the status is not 'SUCCESS'.
  creatVirtualAccount(data) async {
    return await api.postCall(endpoint: 'virtual-accounts/', data: data);
  }

  verifyPayment(ref) async {
    return await api.getCall(endpoint: 'payments/query/$ref', query: '');
  }
}
