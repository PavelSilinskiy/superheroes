import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      body: CustomScrollView(
        slivers: [
          SuperheroAppBar(superhero: superhero),
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (superhero.powerstats.isNotNull())
                  PowerstatsWidget(powerstats: superhero.powerstats),
                BiographyWidget(biography: superhero.biography),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SuperheroAppBar extends StatelessWidget {
  const SuperheroAppBar({super.key, required this.superhero});

  final Superhero superhero;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      stretch: true,
      pinned: true,
      floating: true,
      expandedHeight: 348,
      backgroundColor: SuperheroesColors.background,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          textAlign: TextAlign.center,
          superhero.name,
          style: TextStyle(
            color: SuperheroesColors.whiteText,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        background: CachedNetworkImage(
          imageUrl: superhero.image.url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class PowerstatsWidget extends StatelessWidget {
  final Powerstats powerstats;
  const PowerstatsWidget({super.key, required this.powerstats});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class BiographyWidget extends StatelessWidget {
  final Biography biography;

  const BiographyWidget({super.key, required this.biography});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Text(
        biography.toJson.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: SuperheroesColors.whiteText,),
      ),
    );
  }
}
