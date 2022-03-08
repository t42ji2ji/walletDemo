import 'package:crypto_wallet/model/eth/nft_metadata.dart';
import 'package:crypto_wallet/model/tron/tron_grid_account_info.dart';
import 'package:crypto_wallet/service/eth_wallet_service.dart';
import 'package:crypto_wallet/utilly/showtoast.dart';
import 'package:crypto_wallet/utilly/wallet_address/eth_wallet_address.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web3dart/web3dart.dart';

class EthWalletViewModel {
  final EvmChain chainType;

  final BehaviorSubject<String> streamMnemonic = BehaviorSubject.seeded(
      'scorpion prevent hire rotate income verb exotic rate green appear feel bean');
  final BehaviorSubject<int> streamAddressIndex = BehaviorSubject.seeded(0);
  final BehaviorSubject<String> streamPrivateKey = BehaviorSubject.seeded('');
  final BehaviorSubject<String?> streamHexAddress = BehaviorSubject();
  final BehaviorSubject<num> streamBalance = BehaviorSubject.seeded(0);
  final BehaviorSubject<num> streamUSDTBalance = BehaviorSubject.seeded(0);
  final EthWalletAddress walletHelper = EthWalletAddress();

  final BehaviorSubject<String> streamDerivePath = BehaviorSubject.seeded('');

  final BehaviorSubject<List<NFTMetadata>> streamMyMetadata =
      BehaviorSubject.seeded([]);

  EthWalletService? walletService;
  AccountData? accountInfo;

  bool get isWalletInit {
    final result = walletService != null && walletService!.isInit;
    if (!result) showToast(msg: 'Please import wallet first.');
    return result;
  }

  EthWalletViewModel(this.chainType);

  ///建立錢包
  Future<void> createWallet({String addressIndex = '0'}) async {
    final mnemonic = walletHelper.generateMnemonic();
    streamMnemonic.add(mnemonic);
    final privateKey = await walletHelper.getPrivateKey(mnemonic,
        addressIndex: int.parse(addressIndex));
    streamPrivateKey.add(privateKey);
    final address = await walletHelper.getHexAddress(privateKey);
    streamHexAddress.add(address);
    initWalletService();
  }

  ///匯入錢包
  Future<void> importWallet(String mnemonic,
      {String addressIndex = '0'}) async {
    if (mnemonic.isEmpty) {
      showToast(msg: 'Please input mnemonic');
      return;
    }
    if (int.tryParse(addressIndex) == null) {
      showToast(msg: 'Please input correct addressIndex');
      return;
    }
    streamMnemonic.add(mnemonic);
    final privateKey = await walletHelper.getPrivateKey(mnemonic,
        addressIndex: int.parse(addressIndex));
    streamPrivateKey.add(privateKey);
    final address = await walletHelper.getHexAddress(privateKey);
    streamHexAddress.add(address);
    initWalletService();
  }

  ///初始化錢包
  void initWalletService() {
    walletService = EthWalletService(streamPrivateKey.value, chainType);
    streamBalance.add(0);
    streamUSDTBalance.add(0);
    streamDerivePath.add(walletHelper.derivePath);
    getAccountBalance();
    getUSDTBalance();
  }

  ///取得帳戶資訊
  Future<void> getAccountBalance() async {
    if (!isWalletInit) return;

    final res = await walletService!.getBalance();
    streamBalance.add(res.getValueInUnit(EtherUnit.ether));
  }

  Future<void> sendEth(
      {required String toAddress, required double amount}) async {
    if (!isWalletInit) return;
    final res = await walletService!.send(amount: amount, toAddress: toAddress);
    print('TxID: $res');
    showToast(msg: 'TxID: $res');
  }

  ///取得帳戶資訊
  Future<void> getUSDTBalance() async {
    if (!isWalletInit) return;

    try {
      final res = await walletService!
          .getUSDTBalance(ownerAddress: streamHexAddress.value!);
      streamUSDTBalance.add(
        EtherAmount.fromUnitAndValue(EtherUnit.wei, res)
            .getValueInUnit(EtherUnit.ether),
      );
    } catch (e) {
      // showToast(msg: 'Can\'t get the token: ${e.toString()}');
    }
  }

  ///取得帳戶資訊
  Future<void> transferUSDT(
      {required String toAddress, required num amount}) async {
    if (!isWalletInit) return;

    try {
      final res = await walletService!
          .transferUSDT(toAddress: toAddress, amount: amount);
      print('TxID: $res');
      showToast(msg: 'TxID: $res');
    } on Exception catch (e) {
      showToast(msg: 'Can\'t get the token: ${e.toString()}');
    }
  }

  Future<void> addNftToken({required int tokenId}) async {
    if (!isWalletInit) return;

    try {
      final res = await walletService!.getTokenOwner(tokenId: tokenId);
      if (res.hexEip55.toLowerCase() != streamHexAddress.value!.toLowerCase()) {
        showToast(msg: 'The token is not belong to you.');
        return;
      }

      final uri = await walletService!.getTokenUri(tokenId: tokenId);

      final metadata = await walletService!.getTokenMetaData(uri: uri);
      if (metadata == null) {
        showToast(msg: 'Get metadata error!');
        return;
      }
      metadata.tokenId = tokenId;
      if (streamMyMetadata.value.any((element) => element.tokenId == tokenId)) {
        showToast(msg: 'Already added.');
        return;
      }
      streamMyMetadata.value.add(metadata);
      streamMyMetadata.add(streamMyMetadata.value);
    } catch (e) {
      showToast(msg: 'Get token error! ${e.toString()}');
    }
  }

  ///更新餘額
  // Future<void> refreshBalance() async {
  //   if (accountInfo == null) return;
  //   streamBalance.add(formatToTRX(accountInfo?.balance));
  //   final trc20s = accountInfo?.trc20;
  //   final usdt =
  //       trc20s!.firstWhere((element) => element.keys.contains('TXLAQ63Xg1NAzckPwKHvzw7CSEmLMEqcdj'), orElse: () => {});
  //   if (usdt.isNotEmpty) {
  //     streamUSDTBalance.add(formatToTRX((num.tryParse(usdt['TXLAQ63Xg1NAzckPwKHvzw7CSEmLMEqcdj'] ?? '0'))));
  //   }
  // }
}
