import 'package:get_storage/get_storage.dart';

class MyVault {
  final savedVault = 'savedVault';
  final store = GetStorage();

  // save transactions
  saveTransaction(data) {
    store.write(savedVault, data);
  }

  // fetch transactions
  fetchTransaction() {
    return store.read(savedVault);
  }
}
