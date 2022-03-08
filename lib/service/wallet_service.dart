abstract class WalletService<T> {
  void init({required String privateKey, required String endpoints});
  Future<T?> getBalance();
  Future<String> send({required String toAddress, required num amount});
}
