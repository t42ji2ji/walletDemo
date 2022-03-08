import 'package:json_annotation/json_annotation.dart';
part 'validate_address_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ValidateAddressResponse {
  @JsonKey(defaultValue: false)
  bool result = false;
  @JsonKey(defaultValue: 'false')
  String message = '';

  ValidateAddressResponse({required this.result, required this.message});

  factory ValidateAddressResponse.fromJson(Map<String, dynamic> json) => _$ValidateAddressResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ValidateAddressResponseToJson(this);
}