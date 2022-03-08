import 'dart:typed_data';

import 'package:bs58/bs58.dart';
import 'package:crypto/crypto.dart';
import 'package:crypto_wallet/utilly/wallet_address/wallet_creation.dart';
import 'package:bip32/bip32.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:elliptic/elliptic.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/crypto.dart';

///Tron錢包地址Helper
class TronWalletAddress extends WalletAddressService {
  final walletType = WalletType.tron;
  String derivePath = '';

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
    print('privateKe: $privateKey');
    return privateKey;
  }

  ///TRON - 取得 PublicKeyHex
  @override
  Future<String> getPublicKey(String privateKey, {int addressIndex = 0}) {
    final ec = getSecp256k1();
    final key = PrivateKey.fromHex(ec, privateKey);
    final pubKey = key.publicKey;
    var xHex = pubKey.X.toRadixString(16);
    while (xHex.length < 64) {
      xHex = '0$xHex';
    }
    var yHex = pubKey.Y.toRadixString(16);
    while (yHex.length < 64) {
      yHex = '0$yHex';
    }

    final pubKeyHex = '04$xHex$yHex';
    return Future(() => pubKeyHex);
  }

  ///取得 Hex Address
  @override
  Future<String> getHexAddress(String privateKey) {
    final pubKeyBytes = getPubKeyFromPriKey(privateKey);
    final addressBytes = computeAddress(pubKeyBytes);
    final hexAddress = HEX.encode(addressBytes);
    print('HexAddress: $hexAddress');
    return Future(() => hexAddress);
  }

  ///TRON - PublicKey from PrivateKey Bytes
  Uint8List getPubKeyFromPriKey(String privateKey) {
    final ec = getSecp256k1();
    final key = PrivateKey.fromHex(ec, privateKey);
    final pubKey = key.publicKey;
    var xHex = pubKey.X.toRadixString(16);
    while (xHex.length < 64) {
      xHex = '0$xHex';
    }
    var yHex = pubKey.Y.toRadixString(16);
    while (yHex.length < 64) {
      yHex = '0$yHex';
    }

    final pubKeyHex = '04$xHex$yHex';
    final pubKeyBytes = HEX.decode(pubKeyHex) as Uint8List;
    return pubKeyBytes;
  }

  ///取得Tron Address from PublicKey
  Uint8List computeAddress(Uint8List pubBytes) {
    if (pubBytes.length == 65) {
      pubBytes = pubBytes.sublist(1);
    }

    final hash = HEX.encode(keccak256(pubBytes));
    final addressHex = '41${hash.substring(24)}';
    return HEX.decode(addressHex) as Uint8List;
  }

  ///取得 Base58CheckSum Address
  String getBase58CheckAddress(String privateKey) {
    final pubKeyBytes = getPubKeyFromPriKey(privateKey);
    final addressBytes = computeAddress(pubKeyBytes);
    final hash0 = sha256.convert(addressBytes);
    final hash1 = sha256.convert(hash0.bytes);

    var checkSum = hash1.bytes.sublist(0, 4);
    final addressByteAddCheckSum = addressBytes.toList();
    addressByteAddCheckSum.addAll(checkSum);

    final base58CheckAddress = base58.encode(Uint8List.fromList(addressByteAddCheckSum));
    print('Base58CheckAddress: $base58CheckAddress');
    return base58CheckAddress;
  }
}
