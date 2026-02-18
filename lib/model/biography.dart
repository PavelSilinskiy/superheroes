import 'package:json_annotation/json_annotation.dart';
import 'package:superheroes/model/alignmentInfo.dart';

part 'biography.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class Biography {
  final String fullName;
  // final String alterEgos;
  final List<String> aliases;
  final String placeOfBirth;
  // final String firstAppearance;
  // final String publisher;
  final String alignment;

  Biography({
    required this.fullName,
    // required this.alterEgos,
    required this.aliases,
    required this.placeOfBirth,
    // required this.firstAppearance,
    // required this.publisher,
    required this.alignment,
  });

  AlignmentInfo? get alignmentInfo => AlignmentInfo.fromAlignment(alignment);

  factory Biography.fromJson(Map<String, dynamic> json) => _$BiographyFromJson(json);

  Map<String, dynamic> toJson() => _$BiographyToJson(this);


}