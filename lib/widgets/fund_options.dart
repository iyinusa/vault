import 'package:flutter/material.dart';
import 'package:vault/widgets/button.dart';
import 'package:vault/widgets/input.dart';

import '../helper/constant.dart';
import '../helper/utils.dart';

class FundOptions extends StatefulWidget {
  const FundOptions({super.key});

  @override
  State<FundOptions> createState() => _FundOptionsState();
}

class _FundOptionsState extends State<FundOptions> {
  final utils = Utils();

  final _fullNameC = TextEditingController();
  final _emailC = TextEditingController();
  final _bvnC = TextEditingController();

  bool isVirtualAccount = false;
  late String _bank = '9PAYMENT SERVICE BANK';
  late String _accNumber = '1234567890';

  _selectOption(type) async {}

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
                      _sheet(_virtualAccountForm(screen));
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
                _selectOption('simple_heckout');
              },
            ),
            _optionList(
              name: 'Standard Checkout',
              onTap: () {
                _selectOption('standard_heckout');
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
            onPressed: () {},
            text: 'Create Virtual Account',
          ),
        ],
      ),
    );
  }

  // show sheet
  _sheet(screenContent) {
    return showBottomSheet(
      context: context,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      builder: (context) {
        return screenContent;
      },
    );
  }
}
