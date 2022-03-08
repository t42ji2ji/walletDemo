// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      result: json['result'] as bool? ?? false,
    )
      ..code = json['code'] as String? ?? ''
      ..message = json['message'] as String? ?? '';

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'result': instance.result,
      'code': instance.code,
      'message': instance.message,
    };
