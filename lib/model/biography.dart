import 'package:flutter/foundation.dart';
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

  @override
  bool operator ==(Object other) {
    bool th =
        (identical(this, other) ||
        other is Biography &&
            runtimeType == other.runtimeType &&
            fullName == other.fullName &&
            // alterEgos == other.alterEgos &&
            listEquals(aliases, other.aliases) &&
            placeOfBirth == other.placeOfBirth &&
            // firstAppearance == other.firstAppearance &&
            // publisher == other.publisher &&
            alignment == other.alignment);
    return th;
  }

  @override
  int get hashCode => Object.hash(
        fullName,
        aliases,
        placeOfBirth,
        alignment,
      );

  AlignmentInfo? get alignmentInfo => AlignmentInfo.fromAlignment(alignment);

  factory Biography.fromJson(Map<String, dynamic> json) =>
      _$BiographyFromJson(json);

  Map<String, dynamic> toJson() => _$BiographyToJson(this);
}
