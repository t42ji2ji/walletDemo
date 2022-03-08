import 'dart:convert';

import 'package:crypto_wallet/abis/eth/bsc_testnet/usdt.g.dart';
import 'package:crypto_wallet/abis/eth/eth_ropsten/metatoken.g.dart';
import 'package:crypto_wallet/model/eth/nft_metadata.dart';
import 'package:crypto_wallet/service/wallet_service.dart';
import 'package:crypto_wallet/utilly/value_utils.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

enum EvmChain { ethMainnet, ethRopsten, bscMainnet, bscTest }

class EthWalletService extends WalletService<EtherAmount> {
  static const String ethRopstenTestnetEndpoints = 'https://ropsten.infura.io/v3/e3090e47c3624aa3aa126fa7297bff9b';
  static const String ethMainnetEndpoints = 'https://mainnet.infura.io/v3/e3090e47c3624aa3aa126fa7297bff9b';
  static const String bscMainnetEndpoints = 'https://bsc-dataseed.binance.org';
  static const String bscTestEndpoints = 'https://data-seed-prebsc-1-s1.binance.org:8545';

  final EvmChain chainType;
  final String _privateKey;

  late Web3Client _client;
  late EthereumAddress _address;
  late EthPrivateKey _credentials;
  late int _chainId;
  late String _endPoint;
  bool isInit = false;

  EthWalletService(this._privateKey, this.chainType) {
    switch (chainType) {
      case EvmChain.ethMainnet:
        _endPoint = ethMainnetEndpoints;
        break;
      case EvmChain.ethRopsten:
        _endPoint = ethRopstenTestnetEndpoints;
        break;
      case EvmChain.bscMainnet:
        _endPoint = bscMainnetEndpoints;
        break;
      case EvmChain.bscTest:
        _endPoint = bscTestEndpoints;
        break;
    }
    init(privateKey: _privateKey, endpoints: _endPoint);
  }

  Future<void> initChainId() async {
    final chainId = await _client.getChainId();
    _chainId = chainId.toInt();
  }

  @override
  void init({required String privateKey, required String endpoints}) async {
    _client = Web3Client(endpoints, Client());
    _credentials = EthPrivateKey.fromHex(privateKey);
    _address = _credentials.address;
    initChainId();
    isInit = true;
  }

  @override
  Future<EtherAmount> getBalance() async {
    return _client.getBalance(_address);
  }

  @override
  Future<String> send({required String toAddress, required num amount}) async {
    final toWei = ethToWeiBi(amount);
    final tran = Transaction(
      from: _address,
      to: EthereumAddress.fromHex(toAddress),
      value: EtherAmount.fromUnitAndValue(EtherUnit.wei, toWei),
    );
    final res = await _client.sendTransaction(_credentials, tran, chainId: _chainId);
    return res;
  }

  Future<BigInt> getUSDTBalance({required String ownerAddress}) async {
    final token = Usdt(
      client: _client,
      address: EthereumAddress.fromHex('0x337610d27c682E347C9cD60BD4b3b107C9d34dDd'),
    );

    return token.balanceOf(
      EthereumAddress.fromHex(ownerAddress),
    );
  }

  Future<String> transferUSDT({required String toAddress, required num amount}) async {
    final token = Usdt(
      client: _client,
      address: EthereumAddress.fromHex('0x337610d27c682E347C9cD60BD4b3b107C9d34dDd'),
    );

    return token.transfer(EthereumAddress.fromHex(toAddress), ethToWeiBi(amount), credentials: _credentials);
  }

  Future<EthereumAddress> getTokenOwner({required int tokenId}) async {
    final metatoken =
        Metatoken(address: EthereumAddress.fromHex('0x12846a2955363831b3bD5b2824a7f103c9C2f90b'), client: _client);

    return metatoken.ownerOf(BigInt.from(tokenId));
  }

  Future<String> getTokenUri({required int tokenId}) async {
    final metatoken =
        Metatoken(address: EthereumAddress.fromHex('0x12846a2955363831b3bD5b2824a7f103c9C2f90b'), client: _client);

    return metatoken.tokenURI(BigInt.from(tokenId));
  }

  Future<NFTMetadata?> getTokenMetaData({required String uri}) async {
    final response = await Dio().get(uri);
    if (response.statusCode != 200) return null;
    final data = const JsonDecoder().convert(response.data);
    return NFTMetadata.fromJson(data);
  }
}
