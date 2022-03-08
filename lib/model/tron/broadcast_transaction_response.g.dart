// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BroadcastTransactionResponse _$BroadcastTransactionResponseFromJson(
        Map<String, dynamic> json) =>
    BroadcastTransactionResponse(
      result: json['result'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      txid: json['txid'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );

Map<String, dynamic> _$BroadcastTransactionResponseToJson(
        BroadcastTransactionResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'code': instance.code,
      'txid': instance.txid,
      'message': instance.message,
    };
