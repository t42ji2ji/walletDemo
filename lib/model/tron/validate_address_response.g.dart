// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validate_address_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidateAddressResponse _$ValidateAddressResponseFromJson(
        Map<String, dynamic> json) =>
    ValidateAddressResponse(
      result: json['result'] as bool? ?? false,
      message: json['message'] as String? ?? 'false',
    );

Map<String, dynamic> _$ValidateAddressResponseToJson(
        ValidateAddressResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'message': instance.message,
    };
