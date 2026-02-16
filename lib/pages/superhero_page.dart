import 'package:flutter/material.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/server_image.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/resourses/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';

class SuperheroPage extends StatelessWidget {
  final String id;
  const SuperheroPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final superhero = Superhero(
      id: id,
      name: 'Batman',
      biography: Biography(
        fullName: 'Bruce Wayne',
        alignment: 'good',
        aliases: ['ManMan'],
        placeOfBirth: 'Gotham',
      ),
      image: ServerImage(
        url: 'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
      ),
      powerstats: Powerstats(
        intelligence: "100",
        strength: "26",
        speed: "27",
        durability: "50",
        power: "47",
        combat: "100",
      ),
    );
    return Scaffold(
      backgroundColor: SuperheroesColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Text(
                superhero.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: SuperheroesColors.whiteText,
                ),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.bottomCenter,
              child: ActionButton(
                text: 'Back',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
