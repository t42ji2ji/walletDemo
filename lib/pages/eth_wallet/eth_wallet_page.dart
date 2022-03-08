import 'dart:async';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:crypto_wallet/pages/eth_wallet/view_model/eth_wallet_nfts_page.dart';
import 'package:crypto_wallet/pages/eth_wallet/view_model/eth_wallet_view_model.dart';
import 'package:crypto_wallet/service/eth_wallet_service.dart';
import 'package:crypto_wallet/widgets/dialogs/confirm_transfer_dialog.dart';
import 'package:crypto_wallet/widgets/dialogs/transfer_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EthWalletPage extends StatefulWidget {
  static const String route = '/eth_wallet';

  const EthWalletPage({Key? key}) : super(key: key);

  @override
  _EthWalletPageState createState() => _EthWalletPageState();
}

class _EthWalletPageState extends State<EthWalletPage> {
  late TextEditingController _addressIndexController;
  late TextEditingController _mnemonicController;
  late EthWalletViewModel _viewModel;
  late StreamSubscription _mnemonicSubscription;
  late EvmChain chainType;

  @override
  void initState() {
    _mnemonicController = TextEditingController();
    _addressIndexController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _mnemonicController.dispose();
    _mnemonicSubscription.cancel();
    super.dispose();
  }

  late CoinType coinType;
  String coinSymbol = '';
  String coinIcon =
      'https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png';

  void initChain(BuildContext context) {
    chainType = (ModalRoute.of(context)!.settings.arguments) as EvmChain;
    _viewModel = EthWalletViewModel(chainType);
    _mnemonicController.text = _viewModel.streamMnemonic.value;
    _mnemonicSubscription = _viewModel.streamMnemonic.listen((value) {
      _mnemonicController.text = value;
    });
    _addressIndexController.text =
        _viewModel.streamAddressIndex.value.toString();

    switch (chainType) {
      case EvmChain.ethMainnet:
        coinType = CoinType.ETH;
        coinIcon =
            'https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png';
        break;
      case EvmChain.ethRopsten:
        coinType = CoinType.ETH;
        coinIcon =
            'https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png';
        break;
      case EvmChain.bscMainnet:
        coinType = CoinType.BNB;
        coinIcon =
            'https://s2.coinmarketcap.com/static/img/coins/64x64/1839.png';
        break;
      case EvmChain.bscTest:
        coinType = CoinType.BNB;
        coinIcon =
            'https://s2.coinmarketcap.com/static/img/coins/64x64/1839.png';
        break;
    }
    coinSymbol = coinType.toString().split('.').last;
  }

  @override
  Widget build(BuildContext context) {
    initChain(context);
    return Provider<EthWalletViewModel>.value(
      value: _viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('$coinSymbol WALLET'),
            actions: [
              IconButton(
                onPressed: _viewModel.getAccountBalance,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: StreamBuilder<String>(
                        stream: _viewModel.streamDerivePath,
                        initialData: _viewModel.streamDerivePath.value,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          return Text('Path: ${snapshot.data!}');
                        },
                      ),
                    ),

                    ///餘額及操作
                    ///ETH
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              coinIcon,
                              height: 24,
                              width: 24,
                            ),
                          ),
                          Flexible(
                            child: StreamBuilder<num>(
                                stream: _viewModel.streamBalance,
                                initialData: _viewModel.streamBalance.value,
                                builder: (context, snapshot) {
                                  return Text(
                                    '${snapshot.data} $coinSymbol',
                                    style: const TextStyle(fontSize: 20),
                                  );
                                }),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (!_viewModel.isWalletInit) return;

                              ///輸入轉帳資訊
                              final res = await showTransferDialog(coinType);
                              if (res == null) return;
                              final resultMap = res as Map;

                              ///確認交易
                              final confirm = await showConfirmTransferDialog(
                                coinType,
                                resultMap['to'],
                                resultMap['amount'],
                              ) as bool;
                              if (!confirm) return;

                              ///發送
                              await _viewModel.sendEth(
                                  toAddress: resultMap['to'],
                                  amount: resultMap['amount']);
                            },
                            icon: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ),

                    ///USDT
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              'https://s2.coinmarketcap.com/static/img/coins/64x64/825.png',
                              height: 24,
                              width: 24,
                            ),
                          ),
                          Flexible(
                            child: StreamBuilder<num>(
                                stream: _viewModel.streamUSDTBalance,
                                initialData: _viewModel.streamUSDTBalance.value,
                                builder: (context, snapshot) {
                                  return Text(
                                    '${snapshot.data} USDT',
                                    style: const TextStyle(fontSize: 20),
                                  );
                                }),
                          ),
                          IconButton(
                            // onPressed: () {},
                            onPressed: () async {
                              if (!_viewModel.isWalletInit) return;

                              ///輸入轉帳資訊
                              final res =
                                  await showTransferDialog(CoinType.USDT);
                              if (res == null) return;
                              final resultMap = res as Map;

                              // ///建立轉帳交易
                              // final unSignedTransaction = await _viewModel.createUSDTTransaction(
                              //     toAddress: resultMap['to'], amount: resultMap['amount']);
                              // if (unSignedTransaction == null) return;

                              ///簽署交易
                              final confirm = await showConfirmTransferDialog(
                                CoinType.USDT,
                                resultMap['to'],
                                resultMap['amount'],
                              ) as bool;
                              if (!confirm) return;

                              ///發送交易
                              await _viewModel.transferUSDT(
                                  toAddress: resultMap['to'],
                                  amount: resultMap['amount']);
                            },
                            icon: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ),

                    ///Address QRCode
                    StreamBuilder<String?>(
                        stream: _viewModel.streamHexAddress,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const SizedBox.shrink();
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: BarcodeWidget(
                                data: snapshot.data!,
                                barcode: Barcode.qrCode(),
                                width: 200,
                                height: 200,
                              ),
                            ),
                          );
                        }),

                    ///Input mnemonic
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Please input mnemonic:'),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Address Index:'),
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: 10, maxWidth: 100),
                              child: IntrinsicWidth(
                                child: TextField(
                                  controller: _addressIndexController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    TextField(
                      controller: _mnemonicController,
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () => _viewModel.createWallet(
                                addressIndex: _addressIndexController.text),
                            child: const Text('Create'),
                          ),
                          TextButton(
                            onPressed: () => _viewModel.importWallet(
                                _mnemonicController.text,
                                addressIndex: _addressIndexController.text),
                            child: const Text('Import'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text('Hex Address:'),
                    StreamBuilder<String?>(
                        stream: _viewModel.streamHexAddress,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const SizedBox.shrink();
                          return Text(snapshot.data!);
                        }),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text('Mnemonic:'),
                    StreamBuilder<String>(
                        stream: _viewModel.streamMnemonic,
                        initialData: _viewModel.streamMnemonic.value,
                        builder: (context, snapshot) {
                          return Text(snapshot.data!);
                        }),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text('PrivateKey:'),
                    StreamBuilder<String>(
                        stream: _viewModel.streamPrivateKey,
                        initialData: _viewModel.streamPrivateKey.value,
                        builder: (context, snapshot) {
                          return Text(snapshot.data!);
                        }),
                    const SizedBox(
                      height: 8,
                    ),
                    Visibility(
                      visible: chainType == EvmChain.ethRopsten,
                      child: TextButton(
                        child: const Text('My NFTs'),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return EthNftWalletPage(
                                viewModel: _viewModel,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // StreamBuilder<NFTMetadata?>(
                    //   stream: _viewModel.streamMyNFT,
                    //   builder: (context, snapshot) {
                    //     if (!snapshot.hasData) return const SizedBox.shrink();
                    //     return Container(
                    //       alignment: Alignment.center,
                    //       child: Column(
                    //         children: [
                    //           Image.network(
                    //             snapshot.data!.image,
                    //             height: 200,
                    //             fit: BoxFit.fitHeight,
                    //           ),
                    //           Text(snapshot.data!.name),
                    //           Text(snapshot.data!.description),
                    //         ],
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> showTransferDialog(CoinType type) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return TransferDialog(
          type: type,
        );
      },
    );
  }

  Future<dynamic> showConfirmTransferDialog(
      CoinType type, String toAddress, num amount) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ConfirmTransferDialog(
          amount: amount,
          address: toAddress,
          type: type,
        );
      },
    );
  }
}
