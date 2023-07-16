import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seerbit_flutter/seerbit_flutter.dart';

import 'api.dart';
import 'constant.dart';
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

    SeerbitMethod().startPayment(context, payload: payload,
        onSuccess: (response) {
      // JSON response
      print(response);
      return response;
    }, onCancel: (e) {
      debugPrint(e);
      return false;
    });
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
    try {
      await api.post(endpoint: 'virtual-accounts', data: data).then((resp) {
        if (resp != null) {
          final res = jsonDecode(resp);
          if (res['status'] == 'SUCCESS') {
            return jsonDecode(res['data']);
          }
        }
      });
    } catch (e) {
      debugPrint('Error => $e');
    }

    return null;
  }
}