import 'package:json_annotation/json_annotation.dart';

part 'result.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Result {
  @JsonKey(defaultValue: false)
  bool result = false;
  @JsonKey(defaultValue: '')
  String code = '';
  @JsonKey(defaultValue: '')
  String message = '';

  Result({required this.result});

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
