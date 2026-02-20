import 'package:json_annotation/json_annotation.dart';
import 'package:superheroes/model/powerstats.dart';

import 'biography.dart';
import 'server_image.dart';

part 'superhero.g.dart';


@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class Superhero {
  final String id;
  final String name;
  final Powerstats powerstats;
  final Biography biography;
  //final Appearance appearance;
  //final Work work;
  //final Connections connections;
  final ServerImage image;

  Superhero({
    required this.id,
    required this.name,
    required this.powerstats,
    required this.biography,
    //required this.appearance,
    //required this.work,
    //required this.connections,
    required this.image,
  });

  @override
  bool operator ==(Object other) {
    bool th = (identical(this, other) ||
        other is Superhero &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            powerstats == other.powerstats &&
            biography == other.biography &&
            image == other.image);
    return th;
    // return (identical(this, other) ||
    //     other is Superhero &&
    //         runtimeType == other.runtimeType &&
    //         id == other.id &&
    //         name == other.name &&
    //         powerstats == other.powerstats &&
    //         biography == other.biography &&
    //         image == other.image);
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        powerstats,
        biography,
        image,
      );

  factory Superhero.fromJson(Map<String, dynamic> json) => _$SuperheroFromJson(json);

  Map<String, dynamic> toJson() => _$SuperheroToJson(this);
}