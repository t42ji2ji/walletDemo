import 'package:crypto_wallet/pages/qr_scanner/qr_scanner_page.dart';
import 'package:crypto_wallet/utilly/showtoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CoinType { TRX, USDT, ETH, BNB, BUSD }

class TransferDialog extends StatefulWidget {
  final CoinType type;

  const TransferDialog({Key? key, required this.type}) : super(key: key);

  @override
  _TransferDialogState createState() => _TransferDialogState();
}

class _TransferDialogState extends State<TransferDialog> {
  late TextEditingController _toAddressController;
  late TextEditingController _toAmountController;

  @override
  void initState() {
    _toAddressController = TextEditingController();
    _toAmountController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Transfer'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Text(widget.type.toString()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('To:'),
                IconButton(
                  onPressed: () async {
                    final code = await Navigator.pushNamed(context, QRCodeScannerPage.route) as String?;
                    if (code == null) return;
                    _toAddressController.text = code;
                  },
                  icon: const Icon(Icons.photo_camera),
                ),
              ],
            ),
            TextField(
              controller: _toAddressController,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text('Amount:'),
            TextField(
              controller: _toAmountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(
              height: 16,
            ),
            // const Text('Gas:'),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Confirm'),
          onPressed: () {
            if (_toAddressController.text.isEmpty) {
              showToast(msg: 'Please input the address of receiver.');
              return;
            }
            if (_toAmountController.text.isEmpty) {
              showToast(msg: 'Please input the amount.');
              return;
            }
            final amount = double.tryParse(_toAmountController.text);
            if (amount == null) {
              showToast(msg: 'Amount parse error.');
              return;
            }
            Navigator.of(context).pop<Map<String, dynamic>>(
              {
                'to': _toAddressController.text,
                'amount': amount,
              },
            );
          },
        ),
      ],
    );
  }
}
