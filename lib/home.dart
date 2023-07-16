import 'package:flutter/material.dart';
import 'package:vault/helper/constant.dart';

import 'helper/utils.dart';
import 'logics/vault.dart';
import 'widgets/vault_stats.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final utils = Utils();
  final myVault = MyVault();

  late double _balance = 0;
  late double _inflow = 0;
  late double _outlow = 0;

  bool isLoading = false;
  List transactions = [];

  // check data
  _checkData() async {
    final trans = await myVault.fetchTransaction();
    setState(() {
      if (trans != null) {
        transactions = List.from(trans.reversed);

        _inflow = 0;
        _outlow = 0;
        for (int i = 0; i < trans.length; i++) {
          _inflow = _inflow + transactions[i]['amount'];
        }

        _balance = _inflow - _outlow;
      }
    });
  }

  @override
  void initState() {
    _checkData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor.withOpacity(0.9),
      appBar: AppBar(
        title: const Text(appName),
      ),
      body: Center(
        child: Column(
          children: [
            // vault stats
            VaultStats(
              balance: _balance,
              inflow: _inflow,
              outflow: _outlow,
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('TRANSACTIONS'),
            ),
            const Divider(),

            // transactions
            Expanded(
              child: isLoading
                  ? utils.shimmer(context)
                  : transactions.isEmpty
                      ? utils.noContent(
                          icon: const Icon(
                            Icons.wallet_outlined,
                            color: darkGreyColor,
                            size: 120,
                          ),
                          content: 'No transactions',
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: transactions.length,
                            itemBuilder: (c, i) {
                              return _transItem(transactions[i]);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  _transItem(item) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: lightGreyColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['ref'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(item['type']),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item['amount'].toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(item['date']),
            ],
          ),
        ],
      ),
    );
  }
}
