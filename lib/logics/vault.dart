import 'package:get_storage/get_storage.dart';

class MyVault {
  final savedVault = 'savedVault';
  final fundAmount = 'fundAmount';
  final store = GetStorage();

  // save fund amount
  saveAmount(String data) {
    store.write(fundAmount, double.parse(data));
  }

  // read fund amount
  readAmount() {
    return store.read(fundAmount);
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

    double amount = readAmount();
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
