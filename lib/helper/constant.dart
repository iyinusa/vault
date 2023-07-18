import 'package:flutter/material.dart';

/// APP SETINGS SECTION ///
const String appName = 'Vault';
const String appDesc = 'Your wallet on the go';

const Color primaryColor = Color(0xFFFF3C38);
const Color whiteColor = Color(0xFFFFFFFF);
const Color blackColor = Color(0xFF000000);
const Color dimBlackColor = Color(0xFF424242);
const Color lightGreyColor = Color(0xFFDBDEE0);
const Color darkGreyColor = Color(0xFF9B9B9B);
const Color successColor = Color(0xFF036001);
const Color failedColor = Color(0xFFAF0000);

//// API SECTION ///////
const String base = 'https://seerbitapi.com/api/v2/';
const String pubKey =
    'SBPUBK_DQ24K6T5TI1WOAOYPWWYMGMHKDRVEGPW'; // please remove this in your project
const String myPubKey = 'SBPUBK_XXXXXXXXXXXXX';
const String mySecKey = 'SBSECK_XXXXXXXXXXXXX';
final apiHeaders = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Bearer $pubKey'
};

//// STORED KEYS //////
const virtualAccountRef = 'virtualAccountRef';
const virtualAccountBank = 'virtualAccountBank';
const virtualAccountNo = 'virtualAccountNo';
const vaultTransactions = 'vaultTransactions';
const savedVault = 'savedVault';
const fundAmount = 'fundAmount';
