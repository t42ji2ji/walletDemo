import 'package:crypto_wallet/model/eth/nft_metadata.dart';
import 'package:crypto_wallet/pages/eth_wallet/view_model/eth_wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EthNftWalletPage extends StatefulWidget {
  static const String route = '/eth_wallet/my_nft';

  final EthWalletViewModel viewModel;

  const EthNftWalletPage({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<EthNftWalletPage> createState() => _EthNftWalletPageState();
}

class _EthNftWalletPageState extends State<EthNftWalletPage> {
  late TextEditingController _tokenIdController;

  @override
  void initState() {
    _tokenIdController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My NFTs'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text('Token ID'),
          SizedBox(
            width: 30,
            child: TextField(
              textAlign: TextAlign.center,
              controller: _tokenIdController,
              keyboardType: const TextInputType.numberWithOptions(),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          TextButton(
            onPressed: () => widget.viewModel.addNftToken(
              tokenId: int.tryParse(_tokenIdController.text) ?? 0,
            ),
            child: const Text('Add Token'),
          ),
          StreamBuilder<List<NFTMetadata>>(
            stream: widget.viewModel.streamMyMetadata,
            initialData: widget.viewModel.streamMyMetadata.value,
            builder: (context, snapshot) {
              return Flexible(
                child: ListView.separated(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Image.network(
                            snapshot.data![index].image,
                            height: 200,
                            fit: BoxFit.fitHeight,
                          ),
                          Text(snapshot.data![index].name),
                          Text(snapshot.data![index].description),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
