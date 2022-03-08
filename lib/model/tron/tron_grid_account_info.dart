import 'package:json_annotation/json_annotation.dart';
part 'tron_grid_account_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TronGridAccountInfo {
  @JsonKey(defaultValue: [])
  List<AccountData> data = [];
  @JsonKey(defaultValue: false)
  bool success = false;
  Meta? meta;

  TronGridAccountInfo({required this.data, required this.success, this.meta});

  factory TronGridAccountInfo.fromJson(Map<String, dynamic> json) => _$TronGridAccountInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TronGridAccountInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountData {
  OwnerPermission? ownerPermission;
  AccountResource? accountResource;
  @JsonKey(defaultValue: [])
  List<ActivePermission> activePermission = [];
  @JsonKey(defaultValue: '')
  String address = '';
  @JsonKey(defaultValue: 0)
  int balance = 0;
  @JsonKey(defaultValue: 0)
  int createTime;
  @JsonKey(defaultValue: [])
  List<Map<String, String>> trc20 = [];

  AccountData(
      {this.ownerPermission,
      this.accountResource,
      required this.activePermission,
      required this.address,
      required this.balance,
      required this.createTime,
      required this.trc20});

  factory AccountData.fromJson(Map<String, dynamic> json) => _$AccountDataFromJson(json);
  Map<String, dynamic> toJson() => _$AccountDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OwnerPermission {
  @JsonKey(defaultValue: [])
  List<Keys> keys = [];
  @JsonKey(defaultValue: 0)
  int threshold = 0;
  @JsonKey(defaultValue: '')
  String permissionName = '';

  OwnerPermission({required this.keys, required this.threshold, required this.permissionName});

  factory OwnerPermission.fromJson(Map<String, dynamic> json) => _$OwnerPermissionFromJson(json);
  Map<String, dynamic> toJson() => _$OwnerPermissionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Keys {
  @JsonKey(defaultValue: '')
  String address = '';
  @JsonKey(defaultValue: 0)
  int weight = 0;

  Keys({required this.address, required this.weight});

  factory Keys.fromJson(Map<String, dynamic> json) => _$KeysFromJson(json);
  Map<String, dynamic> toJson() => _$KeysToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountResource {
  AccountResource();

  factory AccountResource.fromJson(Map<String, dynamic> json) => _$AccountResourceFromJson(json);
  Map<String, dynamic> toJson() => _$AccountResourceToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ActivePermission {
  @JsonKey(defaultValue: '')
  String operations = '';
  @JsonKey(defaultValue: [])
  List<Keys> keys = [];
  @JsonKey(defaultValue: 0)
  int threshold = 0;
  @JsonKey(defaultValue: 0)
  int id = 0;
  @JsonKey(defaultValue: '')
  String type = '';
  @JsonKey(defaultValue: '')
  String permissionName = '';

  ActivePermission(
      {required this.operations,
      required this.keys,
      required this.threshold,
      required this.id,
      required this.type,
      required this.permissionName});

  factory ActivePermission.fromJson(Map<String, dynamic> json) => _$ActivePermissionFromJson(json);
  Map<String, dynamic> toJson() => _$ActivePermissionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Meta {
  @JsonKey(defaultValue: 0)
  int at = 0;
  @JsonKey(defaultValue: 0)
  int pageSize = 0;

  Meta({required this.at, required this.pageSize});

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
