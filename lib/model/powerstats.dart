import 'package:json_annotation/json_annotation.dart';

part 'powerstats.g.dart';

@JsonSerializable()
class Powerstats {
  final String? intelligence;
  final String? strength;
  final String? speed;
  final String? durability;
  final String? power;
  final String? combat;

  Powerstats({
    this.intelligence,
    this.strength,
    this.speed,
    this.durability,
    this.power,
    this.combat,
  });

  bool isNotNull() =>
      !(intelligence == null ||
          intelligence == 'null' ||
          strength == null ||
          strength == 'null' ||
          speed == null ||
          speed == 'null' ||
          durability == null ||
          durability == 'null' ||
          power == null ||
          power == 'null' ||
          combat == null ||
          combat == 'null');

  factory Powerstats.fromJson(Map<String, dynamic> json) =>
      _$PowerstatsFromJson(json);

  Map<String, dynamic> toJson() => _$PowerstatsToJson(this);
}
