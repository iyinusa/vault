import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vault/helper/router.dart';
import 'package:vault/home.dart';
import 'package:vault/widgets/button.dart';
import 'package:vault/widgets/input.dart';
import 'package:vault/widgets/webview.dart';

import '../helper/constant.dart';
import '../helper/seerbit.dart';
import '../helper/utils.dart';
import '../logics/vault.dart';

enum BillingCycles { daily, weekly, monthly, annually }

class FundOptions extends StatefulWidget {
  const FundOptions({super.key});

  @override
  State<FundOptions> createState() => _FundOptionsState();
}

class _FundOptionsState extends State<FundOptions> {
  final utils = Utils();
  final seerbit = SeerBitPay();
  final myVault = MyVault();

  final _fullNameC = TextEditingController();
  final _emailC = TextEditingController();
  final _bvnC = TextEditingController();

  final _cardNumberC = TextEditingController();
  final _cardNameC = TextEditingController();
  final _expiryMonthC = TextEditingController();
  final _expiryYearC = TextEditingController();
  final _cvvC = TextEditingController();
  final _billingPeriodC = TextEditingController();

  BillingCycles billingCycle = BillingCycles.daily;
  late String _selectCycle = 'DIALY';

  final _amountC = TextEditingController();

  bool chargeNow = true;

  late List transactions = [];

  bool isVirtualAccount = false;
  late String _bank = '';
  late String _accNumber = '';

  // check data
  _checkData() async {
    _getVirtualAccount();
  }

  // select integration option
  _payOption(context, type) async {
    // Simple Checkout
    if (type == 'simple_checkout') {
      String fullName = 'Kennedy Yinusa';
      String email = 'iyinusa@yahoo.co.uk';
      String amount = _amountC.text.trim();
      myVault.saveData(fundAmount, double.parse(amount));
      await seerbit.simpleCheckout(context, fullName, email, amount);
    }

    // Standard Checkout
    if (type == 'standard_checkout') {
      utils.processing(context);
      String ref = utils.random(16);
      String email = 'iyinusa@yahoo.co.uk';

      // save payment reference for after payment verification
      myVault.saveData(paymentRef, ref);
      myVault.saveData(fundAmount, double.parse(_amountC.text.trim()));

      await seerbit.standardCheckout({
        'publicKey': myPubKey,
        'amount': _amountC.text.trim(),
        'currency': 'NGN',
        'country': 'NG',
        'paymentReference': ref,
        'email': email,
        'productId': utils.random(8),
        'productDescription': 'Funding Vault',
        'callbackUrl': 'https://solvsai.com/',
      }).then((resp) {
        Navigator.of(context).pop();
        if (resp != null) {
          final res = jsonDecode(resp);
          if (res['status'] == 'SUCCESS') {
            final payLink = res['data']['payments']['redirectLink'];
            if (payLink != null) _launchPayment(payLink);
          } else {
            utils.failedNotify(msg: 'Failed to initialize payment');
          }
        } else {
          utils.failedNotify(msg: 'Failed to initialize payment');
        }
      });
    }

    // Virtual Account
    if (type == 'virtual_account') {
      utils.processing(context);

      seerbit.createVirtualAccount({
        'publicKey': myPubKey,
        'fullName': _fullNameC.text.trim(),
        'email': _emailC.text.trim(),
        'bankVerificationNumber': _bvnC.text.trim(),
        'currency': 'NGN',
        'country': 'NG',
        'reference': utils.random(10),
      }).then((resp) {
        Navigator.of(context).pop();
        if (resp != null) {
          final res = jsonDecode(resp);
          if (res['status'] == 'SUCCESS') {
            final pays = res['data']['payments'];
            final accBank = pays['bankName'];
            final accNo = pays['accountNumber'];

            // save virtual account reference on device for
            // future virtual account retrieval
            final ref = pays['reference'];
            myVault.saveData(virtualAccountRef, ref);
            myVault.saveData(virtualAccountBank, accBank);
            myVault.saveData(virtualAccountNo, accNo);

            setState(() {
              _bank = accBank;
              _accNumber = accNo;
              isVirtualAccount = true;
            });

            Navigator.of(context).pop();
          }
        }
      });
    }

    // Subscription
    if (type == 'subscription') {
      utils.processing(context);

      String email = 'iyinusa@yahoo.co.uk';

      seerbit.createSubscription({
        'publicKey': myPubKey,
        'paymentReference': utils.random(10),
        'cardNumber': _cardNumberC.text.trim(),
        'cardName': _cardNameC.text.trim(),
        'expiryMonth': _expiryMonthC.text.trim(),
        'expiryYear': _expiryYearC.text.trim(),
        'cvv': _cvvC.text.trim(),
        'amount': _amountC.text.trim(),
        'email': email,
        'currency': 'NGN',
        'country': 'NG',
        'productId': utils.random(10),
        'productDescription': 'Create Subscription',
        'startDate': DateTime.now().toString(),
        'billingCycle': _selectCycle,
        'billingPeriod': _billingPeriodC.text.trim(),
        'subscriptionAmount': chargeNow,
        'redirectUrl': 'https://solvsai.com/',
        'callbackUrl': 'https://solvsai.com/',
        'allowPartialDebit': 'false',
      }).then((resp) {
        Navigator.of(context).pop();
        if (resp != null) {
          final res = jsonDecode(resp);
          if (res['status'] == 'SUCCESS') {
            utils.successNotify(msg: 'Subscription Created');
          } else {
            // utils.failedNotify(msg: 'Subscription Creation Failed');
          }
        } else {
          // utils.failedNotify(msg: 'Subscription Creation Failed');
        }

        navTo(page: const HomeScreen());
      });
    }
  }

  // get virtual account
  _getVirtualAccount() async {
    final accBank = myVault.readData(virtualAccountBank);
    final accNo = myVault.readData(virtualAccountNo);

    if (accBank != null && accNo != null) {
      setState(() {
        isVirtualAccount = true;
        _bank = accBank;
        _accNumber = accNo;
      });
    }
  }

  // launch payment
  _launchPayment(link) async {
    var result = await showDialog(
      context: context,
      builder: (context) => WebViewScreen(
        name: 'SeerBit Standard Payment',
        url: link,
      ),
    );

    if (result == null) _verifyPayment();
  }

  // verify payment
  _verifyPayment() async {
    final ref = await myVault.readData(paymentRef);
    if (ref != null) {
      seerbit.verifyPayment(ref).then((resp) {
        if (resp != null) {
          final res = jsonDecode(resp);
          if (res['status'] == 'SUCCESS') {
            // fund vault
            myVault.addTransaction(
              ref: ref,
              type: 'Standard Checkout',
              date: DateTime.now().toString(),
            );
            navTo(page: const HomeScreen());
          } else {
            utils.failedNotify(msg: 'Payment Failed');
          }
        } else {
          utils.failedNotify(msg: 'Payment Failed');
        }
      });
    }
  }

  @override
  void initState() {
    _checkData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return SizedBox(
      width: screen.width,
      height: screen.height * 0.5,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5),
            Container(
              height: 5,
              width: screen.width * 0.2,
              decoration: const BoxDecoration(
                color: lightGreyColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 15),
            const Text(
              'Fund your Vault using any of below options',
              style: TextStyle(color: darkGreyColor),
            ),
            const SizedBox(height: 25),

            // virtual account
            !isVirtualAccount
                ? TextButton(
                    onPressed: () {
                      _sheet(context, _virtualAccountForm(screen));
                    },
                    child: const Text('CREATE VIRTUAL ACCOUNT'),
                  )
                : Column(
                    children: [
                      const Text(
                        'VIRTUAL ACCOUNT',
                        style: TextStyle(color: darkGreyColor),
                      ),
                      const SizedBox(height: 10),

                      // account number
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _accNumber,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              utils.copy(_accNumber).then((_) {
                                utils.successNotify(msg: 'Copied');
                              });
                            },
                            child: const Icon(
                              Icons.copy_outlined,
                              size: 20,
                              color: darkGreyColor,
                            ),
                          ),
                        ],
                      ),

                      // bank
                      Text(
                        _bank,
                        style: const TextStyle(
                          color: darkGreyColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 10),

            const Divider(),

            // option list
            _optionList(
              name: 'Simple Checkout',
              onTap: () {
                _sheet(context, _checkout(screen, 'simple_checkout'));
              },
            ),
            _optionList(
              name: 'Standard Checkout',
              onTap: () {
                _sheet(context, _checkout(screen, 'standard_checkout'));
              },
            ),
            _optionList(
              name: 'Subscription',
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  isScrollControlled: true,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return _subscriptionForm(screen, setState);
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // options list
  _optionList({required String name, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Image.asset(
          'assets/images/seerbit.png',
          height: 25,
        ),
        title: Text(name),
        trailing: const Icon(Icons.arrow_forward_outlined),
      ),
    );
  }

  // checkout
  _checkout(screen, type) {
    return Container(
      width: screen.width,
      height: screen.height * 0.25,
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const Text('Provide amount to be funded'),
          const SizedBox(height: 15),
          const Divider(),
          const SizedBox(height: 15),
          Row(
            children: [
              SizedBox(
                width: screen.width * 0.45,
                child: TextInput(
                  controller: _amountC,
                  label: '5000',
                  inputType: TextInputType.number,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: screen.width * 0.40,
                child: FullRoundedButton(
                  onPressed: () => _payOption(
                    context,
                    type == 'simple_checkout'
                        ? 'simple_checkout'
                        : 'standard_checkout',
                  ),
                  text: 'Make Payment',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // create virtual account
  _virtualAccountForm(screen) {
    return Container(
      width: screen.width,
      height: screen.height * 0.4,
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const Text('Provide below details to generate Virtual Account'),
          const SizedBox(height: 15),
          TextInput(
            controller: _fullNameC,
            label: 'Full Name',
            inputType: TextInputType.text,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: screen.width * 0.45,
                child: TextInput(
                  controller: _emailC,
                  label: 'Email Address',
                  inputType: TextInputType.emailAddress,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: screen.width * 0.4,
                child: TextInput(
                  controller: _bvnC,
                  label: 'BVN',
                  inputType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          FullRoundedButton(
            onPressed: () => _payOption(context, 'virtual_account'),
            text: 'Create Virtual Account',
          ),
        ],
      ),
    );
  }

  // create subscription
  _subscriptionForm(screen, setState) {
    return Container(
      width: screen.width,
      height: screen.height * 0.75,
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Provide below details to create a subscription'),
          const SizedBox(height: 15),
          TextInput(
            controller: _cardNumberC,
            label: 'Card Number',
            inputType: TextInputType.number,
          ),
          const SizedBox(height: 10),

          // amount & expiry
          Row(
            children: [
              SizedBox(
                width: screen.width * 0.45,
                child: TextInput(
                  controller: _amountC,
                  label: '5000',
                  inputType: TextInputType.number,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: screen.width * 0.2,
                child: TextInput(
                  controller: _expiryMonthC,
                  label: 'MM',
                  inputType: TextInputType.number,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: screen.width * 0.2,
                child: TextInput(
                  controller: _expiryYearC,
                  label: 'YY',
                  inputType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // name & cvv
          Row(
            children: [
              SizedBox(
                width: screen.width * 0.6,
                child: TextInput(
                  controller: _fullNameC,
                  label: 'Card Name',
                  inputType: TextInputType.text,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: screen.width * 0.25,
                child: TextInput(
                  controller: _cvvC,
                  label: 'CVV',
                  inputType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),

          const Text(
            'Billing Cycle',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          // dialy and weekly
          Row(
            children: [
              SizedBox(
                width: screen.width * 0.4,
                child: RadioListTile<BillingCycles>(
                  value: BillingCycles.daily,
                  groupValue: billingCycle,
                  title: const Text(
                    'DAILY',
                    style: TextStyle(fontSize: 12),
                  ),
                  onChanged: (BillingCycles? v) {
                    setState(() {
                      billingCycle = v!;
                      _selectCycle = 'DAILY';
                    });
                  },
                ),
              ),
              SizedBox(
                width: screen.width * 0.4,
                child: RadioListTile<BillingCycles>(
                  value: BillingCycles.weekly,
                  groupValue: billingCycle,
                  title: const Text(
                    'WEEKLY',
                    style: TextStyle(fontSize: 12),
                  ),
                  onChanged: (BillingCycles? v) {
                    setState(() {
                      billingCycle = v!;
                      _selectCycle = 'WEEKLY';
                    });
                  },
                ),
              )
            ],
          ),
          // monthly and yearly
          Row(
            children: [
              SizedBox(
                width: screen.width * 0.4,
                child: RadioListTile<BillingCycles>(
                  value: BillingCycles.monthly,
                  groupValue: billingCycle,
                  title: const Text(
                    'MONTHLY',
                    style: TextStyle(fontSize: 12),
                  ),
                  onChanged: (BillingCycles? v) {
                    setState(() {
                      billingCycle = v!;
                      _selectCycle = 'MONTHLY';
                    });
                  },
                ),
              ),
              SizedBox(
                width: screen.width * 0.4,
                child: RadioListTile<BillingCycles>(
                  value: BillingCycles.annually,
                  groupValue: billingCycle,
                  title: const Text(
                    'ANNUALLY',
                    style: TextStyle(fontSize: 12),
                  ),
                  onChanged: (BillingCycles? v) {
                    setState(() {
                      billingCycle = v!;
                      _selectCycle = 'ANNUALLY';
                    });
                  },
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),

          const Text(
            'Billing Period',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              SizedBox(
                width: screen.width * 0.2,
                child: TextInput(
                  controller: _billingPeriodC,
                  label: '6',
                  inputType: TextInputType.text,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                  'Number of times SeerBit will do a\nrecurrent billing'),
            ],
          ),

          const SizedBox(height: 15),
          FullRoundedButton(
            onPressed: () => _payOption(context, 'subscription'),
            text: 'Create Subscription',
          ),
        ],
      ),
    );
  }

  // show sheet
  _sheet(context, screenContent) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return screenContent;
        });
      },
    );
  }
}
