abstract class WalletAddressService {
  String generateMnemonic();
  Future<String> getPrivateKey(String mnemonic, {int addressIndex = 0});
  Future<String> getPublicKey(String input, {int addressIndex = 0});
  Future<String> getHexAddress(String privateKey);
}

enum WalletType { btc, eth, tron, bnb }

const Map<WalletType, int> coinTypeMap = {
  WalletType.btc: 0,
  WalletType.eth: 60,
  WalletType.tron: 195,
  WalletType.bnb: 714,
};
