import 'package:json_annotation/json_annotation.dart';

part 'nft_metadata.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NFTMetadata {
  int? tokenId;
  @JsonKey(defaultValue: [])
  List<Attributes> attributes;
  @JsonKey(defaultValue: '')
  String description = '';
  @JsonKey(defaultValue: '')
  String image = '';
  @JsonKey(defaultValue: '')
  String name = '';

  NFTMetadata({required this.attributes, required this.description, required this.image, required this.name});

  factory NFTMetadata.fromJson(Map<String, dynamic> json) => _$NFTMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$NFTMetadataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Attributes {
  @JsonKey(defaultValue: '')
  String type = '';
  @JsonKey(defaultValue: '')
  String value = '';

  Attributes({required this.type, required this.value});

  factory Attributes.fromJson(Map<String, dynamic> json) => _$AttributesFromJson(json);
  Map<String, dynamic> toJson() => _$AttributesToJson(this);
}
