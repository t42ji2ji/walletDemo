import 'package:crypto_wallet/model/tron/result.dart';
import 'package:crypto_wallet/model/tron/transaction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionResponse {
  Result? result;
  Transaction? transaction;

  TransactionResponse({this.result, this.transaction});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) => _$TransactionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);
}
