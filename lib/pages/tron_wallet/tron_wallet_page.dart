import 'dart:async';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:crypto_wallet/pages/tron_wallet/view_model/tron_wallet_view_model.dart';
import 'package:crypto_wallet/widgets/dialogs/confirm_transfer_dialog.dart';
import 'package:crypto_wallet/widgets/dialogs/transfer_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TronWalletPage extends StatefulWidget {
  static const String route = '/tron_wallet';

  const TronWalletPage({Key? key}) : super(key: key);

  @override
  _TronWalletPageState createState() => _TronWalletPageState();
}

class _TronWalletPageState extends State<TronWalletPage> {
  late TextEditingController _addressIndexController;
  late TextEditingController _mnemonicController;
  late TronWalletViewModel _viewModel;
  late StreamSubscription _mnemonicSubscription;

  @override
  void initState() {
    _viewModel = TronWalletViewModel();
    _mnemonicController = TextEditingController();
    _mnemonicController.text = _viewModel.streamMnemonic.value;
    _mnemonicSubscription = _viewModel.streamMnemonic.listen((value) {
      _mnemonicController.text = value;
    });
    _addressIndexController = TextEditingController();
    _addressIndexController.text = _viewModel.streamAddressIndex.value.toString();
    super.initState();
  }

  @override
  void dispose() {
    _mnemonicController.dispose();
    _mnemonicSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TRON WALLET'),
        actions: [
          IconButton(
            onPressed: _viewModel.getAccountInfo,
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
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Text('Path: ${snapshot.data!}');
                    },
                  ),
                ),

                ///餘額及操作
                ///TRX
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          'https://s2.coinmarketcap.com/static/img/coins/64x64/1958.png',
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
                                '${snapshot.data} TRX',
                                style: const TextStyle(fontSize: 20),
                              );
                            }),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (!_viewModel.isWalletInit) return;

                          ///輸入轉帳資訊
                          final res = await showTransferDialog(CoinType.TRX);
                          if (res == null) return;
                          final resultMap = res as Map;

                          ///確認交易
                          final confirm = await showConfirmTransferDialog(
                            CoinType.TRX,
                            resultMap['to'],
                            resultMap['amount'],
                          ) as bool;
                          if (!confirm) return;

                          ///發送
                          await _viewModel.sendTRX(toAddress: resultMap['to'], amount: resultMap['amount']);
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
                        onPressed: () async {
                          if (!_viewModel.isWalletInit) return;

                          ///輸入轉帳資訊
                          final res = await showTransferDialog(CoinType.USDT);
                          if (res == null) return;
                          final resultMap = res as Map;

                          ///建立轉帳交易
                          final unSignedTransaction = await _viewModel.createUSDTTransaction(
                              toAddress: resultMap['to'], amount: resultMap['amount']);
                          if (unSignedTransaction == null) return;

                          ///簽署交易
                          final confirm = await showConfirmTransferDialog(
                            CoinType.USDT,
                            resultMap['to'],
                            resultMap['amount'],
                          ) as bool;
                          if (!confirm) return;
                          final signedTransaction = await _viewModel.signTransaction(unSignedTransaction);
                          if (signedTransaction == null) return;

                          ///發送交易
                          await _viewModel.broadcastTransaction(signedTransaction);
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),

                ///Address QRCode
                StreamBuilder<String?>(
                    stream: _viewModel.streamTronAddress,
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
                          constraints: const BoxConstraints(minWidth: 10, maxWidth: 100),
                          child: IntrinsicWidth(
                            child: TextField(
                              controller: _addressIndexController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                        onPressed: () => _viewModel.createWallet(addressIndex: _addressIndexController.text),
                        child: const Text('Create'),
                      ),
                      TextButton(
                        onPressed: () => _viewModel.importWallet(_mnemonicController.text,
                            addressIndex: _addressIndexController.text),
                        child: const Text('Import'),
                      ),
                    ],
                  ),
                ),
                const Text('Base58 Address:'),
                StreamBuilder<String?>(
                    stream: _viewModel.streamTronBase58Address,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();
                      return Text(snapshot.data!);
                    }),
                const SizedBox(
                  height: 8,
                ),
                const Text('Hex Address:'),
                StreamBuilder<String?>(
                    stream: _viewModel.streamTronAddress,
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
              ],
            ),
          ),
        ),
      ),
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

  Future<dynamic> showConfirmTransferDialog(CoinType type, String toAddress, num amount) async {
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
