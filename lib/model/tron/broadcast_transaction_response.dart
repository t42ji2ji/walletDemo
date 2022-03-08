import 'package:json_annotation/json_annotation.dart';

part 'broadcast_transaction_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BroadcastTransactionResponse {
  @JsonKey(defaultValue: false)
  bool result = false;
  @JsonKey(defaultValue: '')
  String code = '';
  @JsonKey(defaultValue: '')
  String txid = '';
  @JsonKey(defaultValue: '')
  String message = '';

  BroadcastTransactionResponse({required this.result, required this.code, required this.txid, required this.message});

  factory BroadcastTransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$BroadcastTransactionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BroadcastTransactionResponseToJson(this);
}
