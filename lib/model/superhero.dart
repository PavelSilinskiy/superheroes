import 'biography.dart';
import 'server_image.dart';

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

  factory Superhero.fromJson(Map<String, dynamic> json) {
    return Superhero(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      //powerstats: PowerStats.fromJson(json['powerstats'] ?? {}),
      biography: Biography.fromJson(json['biography'] ?? {}),
      //appearance: Appearance.fromJson(json['appearance'] ?? {}),
      //work: Work.fromJson(json['work'] ?? {}),
      //connections: Connections.fromJson(json['connections'] ?? {}),
      image: ServerImage.fromJson(json['image'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        //'powerstats': powerstats.toJson(),
        'biography': biography.toJson(),
        //'appearance': appearance.toJson(),
        //'work': work.toJson(),
        //'connections': connections.toJson(),
        'image': image.toJson(),
      };
}