import 'package:crypto_wallet/utilly/wallet_address/wallet_creation.dart';
import 'package:bip32/bip32.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';
import 'package:web3dart/credentials.dart';

class EthWalletAddress implements WalletAddressService {
  final walletType = WalletType.eth;
  String derivePath = '';

  EthWalletAddress();

  ///產生助記詞
  @override
  String generateMnemonic() {
    final mnemonic = bip39.generateMnemonic(strength: 128);
    print('Mnemonic: $mnemonic');
    return mnemonic;
  }

  ///HD - Wallet 取得 PrivateKey
  @override
  Future<String> getPrivateKey(String mnemonic, {int addressIndex = 0}) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final hdWallet = BIP32.fromSeed(seed);
    derivePath = "m/44'/${coinTypeMap[walletType]}'/0'/0/$addressIndex";
    final specWallet = hdWallet.derivePath(derivePath);
    final privateKey = HEX.encode(specWallet.privateKey!);
    print('Private: $privateKey');
    return privateKey;
  }

  ///HD - Wallet 取得 PublicKey
  @override
  Future<String> getPublicKey(String mnemonic, {int addressIndex = 0}) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final hdWallet = BIP32.fromSeed(seed);
    derivePath = "m/44'/${coinTypeMap[walletType]}'/0'/0/$addressIndex";
    final specWallet = hdWallet.derivePath(derivePath);
    final publicKey = HEX.encode(specWallet.publicKey);
    print('Public: $publicKey');
    return publicKey;
  }

  ///取得 Hex Address
  @override
  Future<String> getHexAddress(String privateKey) async {
    final private = EthPrivateKey.fromHex(privateKey);
    final address = await private.extractAddress();
    print('Eth Address: $address');
    return address.hex;
  }
}
