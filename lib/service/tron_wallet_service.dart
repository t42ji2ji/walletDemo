import 'dart:convert';

import 'package:crypto_wallet/model/tron/broadcast_transaction_response.dart';
import 'package:crypto_wallet/model/response_base.dart';
import 'package:crypto_wallet/model/tron/transaction.dart';
import 'package:crypto_wallet/model/tron/transaction_response.dart';
import 'package:crypto_wallet/model/tron/tron_grid_account_info.dart';
import 'package:crypto_wallet/model/tron/validate_address_response.dart';
import 'package:crypto_wallet/service/wallet_service.dart';
import 'package:crypto_wallet/utilly/service_utils.dart';
import 'package:dio/dio.dart';

class TronWalletService extends WalletService {
  static const String shastaEndpoints = 'https://api.shasta.trongrid.io';

  ///TRC20相關
  static const String USDTContractAddress = 'TXLAQ63Xg1NAzckPwKHvzw7CSEmLMEqcdj';
  static const String USDTAbiString =
      "[{\"inputs\":[{\"name\":\"name_\",\"type\":\"string\"},{\"name\":\"symbol_\",\"type\":\"string\"}],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"inputs\":[{\"indexed\":true,\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"spender\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"value\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\",\"anonymous\":false},{\"inputs\":[{\"indexed\":false,\"name\":\"userAddress\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"relayerAddress\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"functionSignature\",\"type\":\"bytes\"}],\"name\":\"MetaTransactionExecuted\",\"type\":\"event\",\"anonymous\":false},{\"inputs\":[{\"indexed\":true,\"name\":\"previousOwner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"newOwner\",\"type\":\"address\"}],\"name\":\"OwnershipTransferred\",\"type\":\"event\",\"anonymous\":false},{\"inputs\":[{\"indexed\":true,\"name\":\"from\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"to\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"value\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\",\"anonymous\":false},{\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"name\":\"ERC712_VERSION\",\"stateMutability\":\"View\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"inputs\":[{\"name\":\"owner\",\"type\":\"address\"},{\"name\":\"spender\",\"type\":\"address\"}],\"name\":\"allowance\",\"stateMutability\":\"View\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"inputs\":[{\"name\":\"spender\",\"type\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"approve\",\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"inputs\":[{\"name\":\"account\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"stateMutability\":\"View\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"\",\"type\":\"uint8\"}],\"name\":\"decimals\",\"stateMutability\":\"View\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"inputs\":[{\"name\":\"spender\",\"type\":\"address\"},{\"name\":\"subtractedValue\",\"type\":\"uint256\"}],\"name\":\"decreaseAllowance\",\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"\",\"type\":\"bytes\"}],\"inputs\":[{\"name\":\"userAddress\",\"type\":\"address\"},{\"name\":\"functionSignature\",\"type\":\"bytes\"},{\"name\":\"sigR\",\"type\":\"bytes32\"},{\"name\":\"sigS\",\"type\":\"bytes32\"},{\"name\":\"sigV\",\"type\":\"uint8\"}],\"name\":\"executeMetaTransaction\",\"stateMutability\":\"payable\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"name\":\"getChainId\",\"stateMutability\":\"Pure\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\"}],\"name\":\"getDomainSeperator\",\"stateMutability\":\"View\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"nonce\",\"type\":\"uint256\"}],\"inputs\":[{\"name\":\"user\",\"type\":\"address\"}],\"name\":\"getNonce\",\"stateMutability\":\"View\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"inputs\":[{\"name\":\"spender\",\"type\":\"address\"},{\"name\":\"addedValue\",\"type\":\"uint256\"}],\"name\":\"increaseAllowance\",\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"mint\",\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"name\":\"name\",\"stateMutability\":\"View\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"name\":\"owner\",\"stateMutability\":\"View\",\"type\":\"function\"},{\"name\":\"renounceOwnership\",\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"name\":\"symbol\",\"stateMutability\":\"View\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"name\":\"totalSupply\",\"stateMutability\":\"View\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"inputs\":[{\"name\":\"recipient\",\"type\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"transfer\",\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"inputs\":[{\"name\":\"sender\",\"type\":\"address\"},{\"name\":\"recipient\",\"type\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"name\":\"newOwner\",\"type\":\"address\"}],\"name\":\"transferOwnership\",\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]";

  final String _privateKey;
  bool isInit = false;

  TronWalletService(this._privateKey) {
    init(privateKey: _privateKey, endpoints: '');
  }

  @override
  void init({required String privateKey, required String endpoints}) {
    isInit = true;
  }

  @override
  Future getBalance() {
    // TODO: implement getBalance
    throw UnimplementedError();
  }

  @override
  Future<String> send({required String toAddress, required num amount}) async {
    final uri = targetPath('/wallet/easytransferbyprivate');

    final data = {
      'privateKey': _privateKey,
      'toAddress': '4110e747873e28750e42a1959241c6d28e1acc0c76',
      'amount': 10000
    };
    final response = await Dio().postUri(uri, data: data);
    return response.statusCode.toString();
  }

  ///呼叫合約Function
  Future<ResponseData<TransactionResponse?>> triggerSmartContract({
    required String ownerAddress,
    required String contractAddress,
    required String functionSelector,
    required String parameter,
    int callValue = 0,
    int feeLimit = 100000000,
    bool base58Address = true,
  }) async {
    final uri = targetPath('/wallet/triggersmartcontract');
    final data = {
      "owner_address": ownerAddress,
      "contract_address": contractAddress,
      "function_selector": functionSelector,
      "parameter": parameter,
      "call_value": callValue,
      "fee_limit": feeLimit,
      "visible": base58Address
    };
    final response = await Dio().postUri(uri, data: data);
    return apiResponse(response, (json) => TransactionResponse.fromJson(json));
  }

  ///簽署交易
  Future<ResponseData<Transaction?>> getTransactionSign({required Transaction transaction}) async {
    final uri = targetPath('/wallet/gettransactionsign');
    final data = {
      "transaction": json.encode(transaction.toJson()),
      "privateKey": _privateKey,
    };
    final response = await Dio().postUri(uri, data: data);
    return apiResponse(response, (json) => Transaction.fromJson(json));
  }

  ///發送交易
  Future<ResponseData<BroadcastTransactionResponse?>> broadcastTransaction({required Transaction transaction}) async {
    final uri = targetPath('/wallet/broadcasttransaction');
    final data = json.encode(transaction);
    final response = await Dio().postUri(uri, data: data);
    return apiResponse(response, (json) => BroadcastTransactionResponse.fromJson(json));
  }

  ///取得帳戶資訊
  Future<ResponseData<TronGridAccountInfo?>> getAccountInfo({required String address}) async {
    final uri = targetPath('/v1/accounts/$address');
    final response = await Dio().getUri(uri);
    return apiResponse(response, (json) => TronGridAccountInfo.fromJson(json));
  }

  ///驗證Address
  Future<ResponseData<ValidateAddressResponse?>> validateAddress({required String address}) async {
    final uri = targetPath('/wallet/validateaddress');
    final data = {
      'address': address,
    };
    final response = await Dio().postUri(uri, data: data);
    return apiResponse(response, (json) => ValidateAddressResponse.fromJson(json));
  }

  Future<ResponseData<TransactionResponse?>> sendTRX({required String toAddress, required int amount}) async {
    final uri = targetPath('/wallet/easytransferbyprivate');

    final data = {'privateKey': _privateKey, 'toAddress': toAddress, 'amount': amount};
    final response = await Dio().postUri(uri, data: data);
    return apiResponse(response, (json) => TransactionResponse.fromJson(json));
  }
}
