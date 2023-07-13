import 'package:flutter/material.dart';
import 'package:vault/helper/constant.dart';
import 'package:vault/widgets/fund_options.dart';

class VaultStats extends StatefulWidget {
  final double balance, inflow, outflow;
  const VaultStats({
    super.key,
    required this.balance,
    required this.inflow,
    required this.outflow,
  });

  @override
  State<VaultStats> createState() => _VaultStatsState();
}

class _VaultStatsState extends State<VaultStats> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: lightGreyColor,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(color: lightGreyColor, spreadRadius: 2),
        ],
      ),
      child: Column(
        children: [
          const Text('BALANCE'),
          Text(
            'NGN ${widget.balance}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          // inflow and outflow
          Row(
            children: [
              // inflow
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('INFLOW'),
                  Text(
                    'NGN ${widget.inflow}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // outflow
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('OUTFLOW'),
                  Text(
                    'NGN ${widget.outflow}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // add fund button
          TextButton.icon(
            onPressed: () {
              showBottomSheet(
                context: context,
                enableDrag: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                builder: (context) {
                  return const FundOptions();
                },
              );
            },
            icon: const Icon(Icons.add_outlined),
            label: const Text('Add Fund'),
          ),
        ],
      ),
    );
  }
}
