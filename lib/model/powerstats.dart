import 'package:json_annotation/json_annotation.dart';

part 'powerstats.g.dart';

@JsonSerializable()
class Powerstats {
  final String intelligence;
  final String strength;
  final String speed;
  final String durability;
  final String power;
  final String combat;

  Powerstats({
    required this.intelligence,
    required this.strength,
    required this.speed,
    required this.durability,
    required this.power,
    required this.combat,
  });

  @override
  bool operator ==(Object other) {
    bool th = (identical(this, other) ||
        other is Powerstats &&
            runtimeType == other.runtimeType &&
            intelligence == other.intelligence &&
            strength == other.strength &&
            speed == other.speed &&
            durability == other.durability &&
            power == other.power &&
            combat == other.combat);
    return th;
  }

  @override
  int get hashCode => Object.hash(
        intelligence,
        strength,
        speed,
        durability,
        power,
        combat,
      );

  bool isNotNull() =>
      !(intelligence == 'null' ||
          strength == 'null' ||
          speed == 'null' ||
          durability == 'null' ||
          power == 'null' ||
          combat == 'null');

  double get intelligencePersent => convertStringToPercent(intelligence);
  double get strengthPersent => convertStringToPercent(strength);
  double get speedPersent => convertStringToPercent(speed);
  double get durabilityPersent => convertStringToPercent(durability);
  double get powerPersent => convertStringToPercent(power);
  double get combatPersent => convertStringToPercent(combat);

  double convertStringToPercent(final String value) {
    final intValue = int.tryParse(value);
    if (intValue == null) return 0;
    return intValue / 100;
  }

  factory Powerstats.fromJson(Map<String, dynamic> json) =>
      _$PowerstatsFromJson(json);

  Map<String, dynamic> toJson() => _$PowerstatsToJson(this);
}
