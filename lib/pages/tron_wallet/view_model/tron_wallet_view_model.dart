import 'package:bs58/bs58.dart';
import 'package:crypto_wallet/model/tron/transaction.dart';
import 'package:crypto_wallet/model/tron/tron_grid_account_info.dart';
import 'package:crypto_wallet/service/tron_wallet_service.dart';
import 'package:crypto_wallet/utilly/showtoast.dart';
import 'package:crypto_wallet/utilly/value_utils.dart';
import 'package:crypto_wallet/utilly/wallet_address/tron_wallet_address.dart';
import 'package:hex/hex.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';

class TronWalletViewModel {
  final BehaviorSubject<String> streamMnemonic =
      BehaviorSubject.seeded('girl glimpse knife emerge bubble ride key jazz dance source hand concert');
  final BehaviorSubject<int> streamAddressIndex = BehaviorSubject.seeded(0);
  final BehaviorSubject<String> streamPrivateKey = BehaviorSubject.seeded('');
  final BehaviorSubject<String?> streamTronAddress = BehaviorSubject();
  final BehaviorSubject<String?> streamTronBase58Address = BehaviorSubject();
  final BehaviorSubject<num> streamBalance = BehaviorSubject.seeded(0);
  final BehaviorSubject<num> streamUSDTBalance = BehaviorSubject.seeded(0);
  final TronWalletAddress walletHelper = TronWalletAddress();

  final BehaviorSubject<String> streamDerivePath = BehaviorSubject.seeded('');

  TronWalletService? walletService;
  AccountData? accountInfo;

  bool get isWalletInit {
    final result = walletService != null && walletService!.isInit;
    if (!result) showToast(msg: 'Please import wallet first.');
    return result;
  }

  TronWalletViewModel();

  ///建立錢包
  Future<void> createWallet({String addressIndex = '0'}) async {
    final mnemonic = walletHelper.generateMnemonic();
    streamMnemonic.add(mnemonic);
    final privateKey = await walletHelper.getPrivateKey(mnemonic, addressIndex: int.parse(addressIndex));
    streamPrivateKey.add(privateKey);
    final address = await walletHelper.getHexAddress(privateKey);
    streamTronAddress.add(address);
    final base58Address = walletHelper.getBase58CheckAddress(privateKey);
    streamTronBase58Address.add(base58Address);
    initWalletService();
  }

  ///匯入錢包
  Future<void> importWallet(String mnemonic, {String addressIndex = '0'}) async {
    if (mnemonic.isEmpty) {
      showToast(msg: 'Please input mnemonic');
      return;
    }
    if (int.tryParse(addressIndex) == null) {
      showToast(msg: 'Please input correct addressIndex');
      return;
    }
    streamMnemonic.add(mnemonic);
    final privateKey = await walletHelper.getPrivateKey(mnemonic, addressIndex: int.parse(addressIndex));
    streamPrivateKey.add(privateKey);
    final address = await walletHelper.getHexAddress(privateKey);
    streamTronAddress.add(address);
    final base58Address = walletHelper.getBase58CheckAddress(privateKey);
    streamTronBase58Address.add(base58Address);
    initWalletService();
  }

  ///初始化錢包
  void initWalletService() {
    walletService = TronWalletService(streamPrivateKey.value);
    streamBalance.add(0);
    streamUSDTBalance.add(0);
    streamDerivePath.add(walletHelper.derivePath);
    getAccountInfo();
  }

  ///取得帳戶資訊
  Future<void> getAccountInfo() async {
    if (!isWalletInit) return;

    final res = await walletService!.getAccountInfo(address: streamTronBase58Address.value!);
    if (res.code != 200) showToast(msg: 'Get account info error: ${res.code}');
    if (res.obj?.data.isEmpty ?? true) {
      showToast(msg: 'This account need to be activate.');
      return;
    }
    accountInfo = res.obj!.data.first;
    refreshBalance();
  }

  ///更新餘額
  Future<void> refreshBalance() async {
    if (accountInfo == null) return;
    streamBalance.add(formatToTRX(accountInfo?.balance));
    final trc20s = accountInfo?.trc20;
    final usdt =
        trc20s!.firstWhere((element) => element.keys.contains('TXLAQ63Xg1NAzckPwKHvzw7CSEmLMEqcdj'), orElse: () => {});
    if (usdt.isNotEmpty) {
      streamUSDTBalance.add(formatToTRX((num.tryParse(usdt['TXLAQ63Xg1NAzckPwKHvzw7CSEmLMEqcdj'] ?? '0'))));
    }
  }

  ///快速傳送TRX幣
  Future<void> sendTRX({required String toAddress, required num amount}) async {
    if (!isWalletInit) return;

    ///validateAddress
    final validated = await walletService!.validateAddress(address: toAddress);
    if (validated.code != 200) {
      showToast(msg: 'Validate Address Api Error: ${validated.code}');
      return null;
    }
    if (!(validated.obj?.result ?? true)) {
      showToast(msg: 'Validate Address Fail: ${validated.obj?.message ?? ''}');
      return null;
    }

    ///base58 Address to Hex
    final addressBytes = base58.decode(toAddress).sublist(0, 21);
    final hexAddress = HEX.encode(addressBytes);

    final res = await walletService!.sendTRX(amount: formatToSUN(amount).toInt(), toAddress: hexAddress);
    if (res.code != 200) {
      showToast(msg: 'Send TRX API Error: ${res.code}');
      return;
    }
    if (!res.obj!.result!.result) {
      showToast(msg: 'Send TRX Fail: ${res.obj?.result?.code ?? ''}, ${res.obj?.result?.message ?? ''}');
    } else {
      print('Send TRX Success: ${res.obj?.transaction?.txID ?? ''}');
      showToast(msg: 'Send TRX Success: ${res.obj?.transaction?.txID ?? ''}');
    }
  }

  ///建立USDT轉帳交易
  Future<Transaction?> createUSDTTransaction({required String toAddress, required num amount}) async {
    if (!isWalletInit) return null;

    ///validateAddress
    final validated = await walletService!.validateAddress(address: toAddress);
    if (validated.code != 200) {
      showToast(msg: 'Validate Address Api Error: ${validated.code}');
      return null;
    }
    if (!(validated.obj?.result ?? true)) {
      showToast(msg: 'Validate Address Fail: ${validated.obj?.message ?? ''}');
      return null;
    }

    ///base58 Address to Hex
    final addressBytes = base58.decode(toAddress).sublist(0, 21);
    final hexAddress = HEX.encode(addressBytes);
    final toAddressFinal = hexAddress.replaceFirst('41', '0x');

    ///Contract Abi Handle
    final contactAbi = ContractAbi.fromJson(TronWalletService.USDTAbiString, 'USDT Contract');
    final function = contactAbi.functions.firstWhere((element) => element.name == 'transfer');
    final encode = function.encodeCall(
      [
        EthereumAddress.fromHex(toAddressFinal),
        BigInt.from(
          formatToSUN(amount),
        ),
      ],
    );
    final hexParameter = HEX.encode(encode);
    final removeERC20Prefix = hexParameter.substring(8); //移除function hash

    ///取得合約交易Transaction
    final res = await walletService!.triggerSmartContract(
      ownerAddress: streamTronBase58Address.value!,
      contractAddress: TronWalletService.USDTContractAddress,
      functionSelector: 'transfer(address,uint256)',
      parameter: removeERC20Prefix,
    );
    if (res.code != 200) {
      showToast(msg: 'Trigger Smart Contract error: ${res.code}');
      return null;
    }
    final result = res.obj!.result;
    if (!(result?.result ?? true)) {
      showToast(msg: 'Trigger Smart Contract error: ${result?.message}');
      return null;
    }
    return res.obj?.transaction;
  }

  ///簽署交易
  Future<Transaction?> signTransaction(Transaction transaction) async {
    if (!isWalletInit) return null;

    final signRes = await walletService!.getTransactionSign(transaction: transaction);
    if (signRes.code != 200) {
      showToast(msg: 'Sign contract error: ${signRes.code}');
      return null;
    }
    if (signRes.obj?.signature.isEmpty ?? true) {
      showToast(msg: 'Sign contract error: ${signRes.code}');
      return null;
    }
    return signRes.obj;
  }

  ///發送交易
  Future<void> broadcastTransaction(Transaction transaction) async {
    if (!isWalletInit) return;

    final broadcastRes = await walletService!.broadcastTransaction(transaction: transaction);
    if (broadcastRes.code != 200) {
      showToast(msg: 'Broadcast contract error: ${broadcastRes.code}');
      return;
    }
    if (!(broadcastRes.obj?.result ?? true)) {
      showToast(msg: 'Broadcast contract error: ${broadcastRes.obj?.code}');
      return;
    }
    print('Result: ${broadcastRes.obj?.result} ,TxID: ${broadcastRes.obj?.txid}');
    showToast(msg: 'Result: ${broadcastRes.obj?.result} ,TxID: ${broadcastRes.obj?.txid}');
  }
}
