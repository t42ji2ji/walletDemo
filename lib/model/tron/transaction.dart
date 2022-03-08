import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Transaction {
  @JsonKey(defaultValue: false)
  bool visible = false;
  @JsonKey(defaultValue: [])
  List<String> signature = [];
  @JsonKey(defaultValue: '', name: 'txID')
  String txID = '';
  RawData? rawData;
  @JsonKey(defaultValue: '')
  String rawDataHex = '';

  Transaction({required this.signature, required this.txID, this.rawData, required this.rawDataHex});

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RawData {
  @JsonKey(defaultValue: [])
  List<Contract> contract = [];
  @JsonKey(defaultValue: '')
  String refBlockBytes = '';
  @JsonKey(defaultValue: '')
  String refBlockHash = '';
  @JsonKey(defaultValue: 0)
  int expiration = 0;
  @JsonKey(defaultValue: 0)
  int feeLimit = 0;
  @JsonKey(defaultValue: 0)
  int timestamp = 0;

  RawData(
      {required this.contract,
      required this.refBlockBytes,
      required this.refBlockHash,
      required this.expiration,
      required this.feeLimit,
      required this.timestamp});

  factory RawData.fromJson(Map<String, dynamic> json) => _$RawDataFromJson(json);
  Map<String, dynamic> toJson() => _$RawDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Contract {
  Parameter? parameter;
  @JsonKey(defaultValue: '')
  String type = '';

  Contract({this.parameter, required this.type});

  factory Contract.fromJson(Map<String, dynamic> json) => _$ContractFromJson(json);
  Map<String, dynamic> toJson() => _$ContractToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Parameter {
  Value? value;
  @JsonKey(defaultValue: '')
  String typeUrl = '';

  Parameter({this.value, required this.typeUrl});

  factory Parameter.fromJson(Map<String, dynamic> json) => _$ParameterFromJson(json);
  Map<String, dynamic> toJson() => _$ParameterToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Value {
  @JsonKey(defaultValue: 0)
  int amount = 0;
  @JsonKey(defaultValue: '')
  String data = '';
  @JsonKey(defaultValue: '')
  String ownerAddress = '';
  @JsonKey(defaultValue: '')
  String contractAddress = '';
  @JsonKey(defaultValue: '')
  String toAddress = '';
  @JsonKey(defaultValue: 0)
  int callValue = 0;

  Value({required this.data, required this.ownerAddress, required this.contractAddress});

  factory Value.fromJson(Map<String, dynamic> json) => _$ValueFromJson(json);
  Map<String, dynamic> toJson() => _$ValueToJson(this);
}
