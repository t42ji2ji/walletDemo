import 'package:crypto_wallet/widgets/dialogs/transfer_dialog.dart';
import 'package:flutter/material.dart';

class ConfirmTransferDialog extends StatefulWidget {
  final CoinType type;
  final String address;
  final num amount;

  const ConfirmTransferDialog({Key? key, required this.type, required this.address, required this.amount})
      : super(key: key);

  @override
  _TransferDialogState createState() => _TransferDialogState();
}

class _TransferDialogState extends State<ConfirmTransferDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm the Transaction'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Text(widget.type.toString()),
            ),
            const Text('To:'),
            Text(widget.address),
            const SizedBox(
              height: 16,
            ),
            const Text('Amount:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.amount.toString()),
                Text(widget.type.toString().split('.').last),
              ],
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
            Navigator.of(context).pop<bool>(false);
          },
        ),
        TextButton(
          child: const Text('Sign to transfer'),
          onPressed: () {
            Navigator.of(context).pop<bool>(true);
          },
        ),
      ],
    );
  }
}
