abstract class WalletViewModel {
  getAddressWithDot(String wallet, int dotLength) {
    String dot = '.';
    final int walletLength = wallet.length;
    for (int i = 0; i < dotLength; i++) {
      dot += '.';
    }

    return wallet.substring(0, 5) +
        dot +
        wallet.substring(walletLength - 10, walletLength - 1);
  }
}
