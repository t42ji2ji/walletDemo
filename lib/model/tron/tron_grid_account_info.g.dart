// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tron_grid_account_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TronGridAccountInfo _$TronGridAccountInfoFromJson(Map<String, dynamic> json) =>
    TronGridAccountInfo(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => AccountData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      success: json['success'] as bool? ?? false,
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TronGridAccountInfoToJson(
        TronGridAccountInfo instance) =>
    <String, dynamic>{
      'data': instance.data,
      'success': instance.success,
      'meta': instance.meta,
    };

AccountData _$AccountDataFromJson(Map<String, dynamic> json) => AccountData(
      ownerPermission: json['owner_permission'] == null
          ? null
          : OwnerPermission.fromJson(
              json['owner_permission'] as Map<String, dynamic>),
      accountResource: json['account_resource'] == null
          ? null
          : AccountResource.fromJson(
              json['account_resource'] as Map<String, dynamic>),
      activePermission: (json['active_permission'] as List<dynamic>?)
              ?.map((e) => ActivePermission.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      address: json['address'] as String? ?? '',
      balance: json['balance'] as int? ?? 0,
      createTime: json['create_time'] as int? ?? 0,
      trc20: (json['trc20'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          [],
    );

Map<String, dynamic> _$AccountDataToJson(AccountData instance) =>
    <String, dynamic>{
      'owner_permission': instance.ownerPermission,
      'account_resource': instance.accountResource,
      'active_permission': instance.activePermission,
      'address': instance.address,
      'balance': instance.balance,
      'create_time': instance.createTime,
      'trc20': instance.trc20,
    };

OwnerPermission _$OwnerPermissionFromJson(Map<String, dynamic> json) =>
    OwnerPermission(
      keys: (json['keys'] as List<dynamic>?)
              ?.map((e) => Keys.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      threshold: json['threshold'] as int? ?? 0,
      permissionName: json['permission_name'] as String? ?? '',
    );

Map<String, dynamic> _$OwnerPermissionToJson(OwnerPermission instance) =>
    <String, dynamic>{
      'keys': instance.keys,
      'threshold': instance.threshold,
      'permission_name': instance.permissionName,
    };

Keys _$KeysFromJson(Map<String, dynamic> json) => Keys(
      address: json['address'] as String? ?? '',
      weight: json['weight'] as int? ?? 0,
    );

Map<String, dynamic> _$KeysToJson(Keys instance) => <String, dynamic>{
      'address': instance.address,
      'weight': instance.weight,
    };

AccountResource _$AccountResourceFromJson(Map<String, dynamic> json) =>
    AccountResource();

Map<String, dynamic> _$AccountResourceToJson(AccountResource instance) =>
    <String, dynamic>{};

ActivePermission _$ActivePermissionFromJson(Map<String, dynamic> json) =>
    ActivePermission(
      operations: json['operations'] as String? ?? '',
      keys: (json['keys'] as List<dynamic>?)
              ?.map((e) => Keys.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      threshold: json['threshold'] as int? ?? 0,
      id: json['id'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      permissionName: json['permission_name'] as String? ?? '',
    );

Map<String, dynamic> _$ActivePermissionToJson(ActivePermission instance) =>
    <String, dynamic>{
      'operations': instance.operations,
      'keys': instance.keys,
      'threshold': instance.threshold,
      'id': instance.id,
      'type': instance.type,
      'permission_name': instance.permissionName,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      at: json['at'] as int? ?? 0,
      pageSize: json['page_size'] as int? ?? 0,
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'at': instance.at,
      'page_size': instance.pageSize,
    };
