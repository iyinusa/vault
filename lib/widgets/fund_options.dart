import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vault/helper/router.dart';
import 'package:vault/home.dart';
import 'package:vault/widgets/button.dart';
import 'package:vault/widgets/input.dart';

import '../helper/constant.dart';
import '../helper/seerbit.dart';
import '../helper/utils.dart';
import '../logics/vault.dart';

class FundOptions extends StatefulWidget {
  const FundOptions({super.key});

  @override
  State<FundOptions> createState() => _FundOptionsState();
}

class _FundOptionsState extends State<FundOptions> {
  final store = GetStorage();
  final utils = Utils();
  final seerbit = SeerBitPay();
  final myVault = MyVault();

  final _fullNameC = TextEditingController();
  final _emailC = TextEditingController();
  final _bvnC = TextEditingController();

  final _amountC = TextEditingController();

  late List transactions = [];

  bool isVirtualAccount = false;
  late String _bank = '';
  late String _accNumber = '';

  // check data
  _checkData() async {
    final trans = myVault.fetchTransaction();
    setState(() {
      if (trans != null) transactions = List.from(trans.reversed);
    });
  }

  // select integration option
  _payOption(context, type) async {
    // Simple Checkout
    if (type == 'simple_checkout') {
      String fullName = 'Kennedy Yinusa';
      String email = 'iyinusa@yahoo.co.uk';
      String amount = _amountC.text.trim();
      await seerbit
          .simpleCheckout(context, fullName, email, amount)
          .then((resp) {
        if (resp != null) {
          print('============\n$resp\n===========');
          // add fund
          const fundType = 'Simple Checkout';
          final fundRef = resp['payments']['reference'];
          final fundAmount =
              resp['payments']['amount'] - resp['payments']['fee'];
          final fundDate = resp['payments']['transactionProcessedTime'];
          transactions.add({
            'ref': fundRef,
            'type': fundType,
            'amount': fundAmount,
            'date': fundDate,
          });
          myVault.saveTransaction(transactions);
          navTo(page: const HomeScreen());
        }
      });
    }

    // Virtual Account
    if (type == 'virtual_account') {
      utils.processing(context);

      seerbit.creatVirtualAccount({
        'publicKey': pubKey,
        'fullName': _fullNameC.text.trim(),
        'email': _emailC.text.trim(),
        'bankVerificationNumber': _bvnC.text.trim(),
        'currency': 'NGN',
        'country': 'NG',
        'reference': utils.random(10),
      }).then((resp) {
        Navigator.of(context).pop();

        if (resp != null) {
          // save virtual account reference on device for
          // future virtual account retrieval
          final ref = resp['payments']['reference'];
          store.write(virtualAccountRef, ref);

          setState(() {
            _bank = resp['payments']['bankName'];
            _accNumber = resp['payments']['accountNumber'];
          });

          Navigator.of(context).pop();
        }
      });
    }
  }

  // get virtual account
  _getVirtualAccount() async {}

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
              'Fund your vault using any of below options',
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
                _sheet(context, _simpleCheckout(screen));
              },
            ),
            _optionList(
              name: 'Standard Checkout',
              onTap: () {
                _payOption(context, 'standard_checkout');
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

  // simple checkout
  _simpleCheckout(screen) {
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
                  onPressed: () => _payOption(context, 'simple_checkout'),
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
