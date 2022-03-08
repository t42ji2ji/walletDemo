// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      signature: (json['signature'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      txID: json['txID'] as String? ?? '',
      rawData: json['raw_data'] == null
          ? null
          : RawData.fromJson(json['raw_data'] as Map<String, dynamic>),
      rawDataHex: json['raw_data_hex'] as String? ?? '',
    )..visible = json['visible'] as bool? ?? false;

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'visible': instance.visible,
      'signature': instance.signature,
      'txID': instance.txID,
      'raw_data': instance.rawData,
      'raw_data_hex': instance.rawDataHex,
    };

RawData _$RawDataFromJson(Map<String, dynamic> json) => RawData(
      contract: (json['contract'] as List<dynamic>?)
              ?.map((e) => Contract.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      refBlockBytes: json['ref_block_bytes'] as String? ?? '',
      refBlockHash: json['ref_block_hash'] as String? ?? '',
      expiration: json['expiration'] as int? ?? 0,
      feeLimit: json['fee_limit'] as int? ?? 0,
      timestamp: json['timestamp'] as int? ?? 0,
    );

Map<String, dynamic> _$RawDataToJson(RawData instance) => <String, dynamic>{
      'contract': instance.contract,
      'ref_block_bytes': instance.refBlockBytes,
      'ref_block_hash': instance.refBlockHash,
      'expiration': instance.expiration,
      'fee_limit': instance.feeLimit,
      'timestamp': instance.timestamp,
    };

Contract _$ContractFromJson(Map<String, dynamic> json) => Contract(
      parameter: json['parameter'] == null
          ? null
          : Parameter.fromJson(json['parameter'] as Map<String, dynamic>),
      type: json['type'] as String? ?? '',
    );

Map<String, dynamic> _$ContractToJson(Contract instance) => <String, dynamic>{
      'parameter': instance.parameter,
      'type': instance.type,
    };

Parameter _$ParameterFromJson(Map<String, dynamic> json) => Parameter(
      value: json['value'] == null
          ? null
          : Value.fromJson(json['value'] as Map<String, dynamic>),
      typeUrl: json['type_url'] as String? ?? '',
    );

Map<String, dynamic> _$ParameterToJson(Parameter instance) => <String, dynamic>{
      'value': instance.value,
      'type_url': instance.typeUrl,
    };

Value _$ValueFromJson(Map<String, dynamic> json) => Value(
      data: json['data'] as String? ?? '',
      ownerAddress: json['owner_address'] as String? ?? '',
      contractAddress: json['contract_address'] as String? ?? '',
    )
      ..amount = json['amount'] as int? ?? 0
      ..toAddress = json['to_address'] as String? ?? ''
      ..callValue = json['call_value'] as int? ?? 0;

Map<String, dynamic> _$ValueToJson(Value instance) => <String, dynamic>{
      'amount': instance.amount,
      'data': instance.data,
      'owner_address': instance.ownerAddress,
      'contract_address': instance.contractAddress,
      'to_address': instance.toAddress,
      'call_value': instance.callValue,
    };
