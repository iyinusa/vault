import 'package:get_storage/get_storage.dart';

class MyVault {
  final savedVault = 'savedVault';
  final store = GetStorage();

  // save transactions
  saveTransaction(data) {
    store.write(savedVault, data);
  }

  // add transaction
  addTransaction({
    required String ref,
    required String type,
    required double amount,
    required String date,
  }) {
    List transactions = [];
    final trans = fetchTransaction();
    if (trans != null) transactions = List.from(trans.reversed);

    transactions.add({
      'ref': ref,
      'type': type,
      'amount': amount,
      'date': date,
    });

    // save transaction
    saveTransaction(transactions);
  }

  // fetch transactions
  fetchTransaction() {
    return store.read(savedVault);
  }
}
