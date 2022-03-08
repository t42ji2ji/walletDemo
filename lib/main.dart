import 'package:crypto_wallet/pages/eth_wallet/eth_wallet_page.dart';
import 'package:crypto_wallet/pages/qr_scanner/qr_scanner_page.dart';
import 'package:crypto_wallet/pages/tron_wallet/tron_wallet_page.dart';
import 'package:crypto_wallet/pages/tron_wallet/view_model/tron_wallet_view_model.dart';
import 'package:crypto_wallet/service/eth_wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/provider.dart';

import 'config/config_local.dart';
import 'pages/eth_wallet/view_model/eth_wallet_view_model.dart';

void main() {
  loadConfig();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoWallet',
      theme: ThemeData.light(),
      home: const MyHomePage(title: 'CryptoWallet'),
      routes: {
        EthWalletPage.route: (context) => const EthWalletPage(),
        TronWalletPage.route: (context) => const TronWalletPage(),
        QRCodeScannerPage.route: (context) => const QRCodeScannerPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List _walletModels = [];
  bool isReady = false;

  getAddressWithDot(String wallet, int dotLength) {
    String dot = '.';
    final int walletLength = wallet.length;
    for (int i = 0; i < dotLength; i++) {
      dot += '.';
    }
    return wallet.substring(0, 6) +
        dot +
        wallet.substring(walletLength - 6, walletLength);
  }

  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  Future<int> asyncInit() async {
    if (_walletModels.isEmpty) {
      _walletModels.add(EthWalletViewModel(EvmChain.ethRopsten));
      _walletModels.add(EthWalletViewModel(EvmChain.bscTest));
      _walletModels.add(TronWalletViewModel());
      // _walletModels.add(TronWalletViewModel());
      for (int i = 0; i < _walletModels.length; i++) {
        await _walletModels[i]
            .importWallet(_walletModels[i].streamMnemonic.value);
      }
      isReady = true;
      setState(() {});
    }
    return 1;
  }

  List<String> walletTye = ['Eth Ropsten', 'BSC', 'Tron'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 34, 33, 33),
      body: MultiProvider(
        providers: [
          Provider.value(value: _walletModels),
        ],
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 61, 61, 192),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            walletTye[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isReady && (_walletModels[index] != null))
                            Column(
                              children: [
                                StreamBuilder<String?>(
                                    stream: _walletModels[index]
                                            is EthWalletViewModel
                                        ? _walletModels[index]?.streamHexAddress
                                        : _walletModels[index]
                                            .streamTronBase58Address,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          getAddressWithDot(
                                              snapshot.data ?? '', 7),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        );
                                      }
                                      return const Text(
                                        '',
                                        style: TextStyle(color: Colors.white),
                                      );
                                    }),
                              ],
                            )
                        ],
                      ),
                    );
                  },
                  viewportFraction: 0.8,
                  scale: 0.9,
                  // transformer: PageTransitionsBuilder,
                  itemCount: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
