import 'package:json_annotation/json_annotation.dart';

import 'biography.dart';
import 'server_image.dart';

part 'superhero.g.dart';


@JsonSerializable(fieldRename: FieldRename.kebab)
class Superhero {
  final String id;
  final String name;
  //final PowerStats powerstats;
  final Biography biography;
  //final Appearance appearance;
  //final Work work;
  //final Connections connections;
  final ServerImage image;

  Superhero({
    required this.id,
    required this.name,
    //required this.powerstats,
    required this.biography,
    //required this.appearance,
    //required this.work,
    //required this.connections,
    required this.image,
  });

  factory Superhero.fromJson(Map<String, dynamic> json) => _$SuperheroFromJson(json);

  Map<String, dynamic> toJson() => _$SuperheroToJson(this);
}