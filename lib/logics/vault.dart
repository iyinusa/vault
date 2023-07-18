import 'package:get_storage/get_storage.dart';

import '../helper/constant.dart';

class MyVault {
  final store = GetStorage();

  // save data
  saveData(String key, dynamic data) {
    store.write(key, data);
  }

  // read data
  readData(key) {
    return store.read(key);
  }

  // save transactions
  saveTransaction(data) {
    store.write(savedVault, data);
  }

  // add transaction
  addTransaction({
    required String ref,
    required String type,
    required String date,
  }) {
    List transactions = [];
    final trans = fetchTransaction();
    if (trans != null) transactions = List.from(trans.reversed);

    double amount = readData(fundAmount);
    if (amount != 0) {
      transactions.add({
        'ref': ref,
        'type': type,
        'amount': amount,
        'date': date,
      });

      // save transaction
      saveTransaction(transactions);
    }
  }

  // fetch transactions
  fetchTransaction() {
    return store.read(savedVault);
  }
}
