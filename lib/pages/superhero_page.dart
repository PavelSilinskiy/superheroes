import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/superhero_bloc.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/server_image.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/resourses/superheroes_colors.dart';
import 'package:superheroes/resourses/superheroes_icons.dart';
import 'package:superheroes/resourses/superheroes_images.dart';
import 'package:superheroes/widgets/action_button.dart';

import '../model/alignmentInfo.dart';

class SuperheroPage extends StatefulWidget {
  final String id;
  final http.Client? client;
  const SuperheroPage({super.key, required this.id, this.client});

  @override
  State<SuperheroPage> createState() => _SuperheroPageState();
}

class _SuperheroPageState extends State<SuperheroPage> {
  late SuperheroBloc bloc;
  late FocusNode textFieldFocusNode;

  @override
  void initState() {
    super.initState();
    bloc = SuperheroBloc(id: widget.id, client: widget.client);
  }

  @override
  Widget build(BuildContext context) {
    return Provider<SuperheroBloc>.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: SuperheroesColors.background,
        body: SuperheroPageContent(),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class SuperheroPageContent extends StatelessWidget {
  const SuperheroPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);
    // final superhero = Superhero(
    //   id: bloc.id,
    //   name: 'Batman',
    //   biography: Biography(
    //     fullName: 'Bruce Wayne',
    //     alignment: 'good',
    //     aliases: ['ManMan'],
    //     placeOfBirth: 'Gotham',
    //   ),
    //   image: ServerImage(
    //     url: 'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
    //   ),
    //   powerstats: Powerstats(
    //     intelligence: "100",
    //     strength: "26",
    //     speed: "27",
    //     durability: "50",
    //     power: "47",
    //     combat: "100",
    //   ),
    // );
    return StreamBuilder(
      stream: bloc.observeSuperhero(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return SizedBox();
        } else {
          final superhero = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SuperheroAppBar(superhero: superhero),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    if (superhero.powerstats.isNotNull())
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: PowerstatsWidget(
                          powerstats: superhero.powerstats,
                        ),
                      ),
                    const SizedBox(height: 36),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: BiographyWidget(biography: superhero.biography),
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ],
          );
        }
      },
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
      foregroundColor: Colors.white,
      backgroundColor: SuperheroesColors.background,
      actions: [StarWidget()],
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
          placeholder: (context, str) {
            return Container(
              color: SuperheroesColors.superheroPageImageBackground,
            );
          },
          errorWidget: (context, str, error) {
            return Container(
              alignment: Alignment.center,
              color: SuperheroesColors.superheroPageImageBackground,
              child: Image.asset(SuperheroesImages.unknownHero, height: 264),
            );
          },
        ),
      ),
    );
  }
}

class StarWidget extends StatelessWidget {
  const StarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);
    return StreamBuilder<bool>(
      stream: bloc.observeIsFavorite(),
      builder: (context, snapshot) {
        final bool favorite =
            snapshot.hasData && snapshot.data != null && snapshot.data == true;
        return GestureDetector(
          onTap: favorite ? bloc.removeFromFavorites : bloc.addToFavorites,
          child: Container(
            height: 52,
            width: 52,
            alignment: Alignment.center,
            child: Image.asset(
              favorite ? SuperheroesIcons.starFill : SuperheroesIcons.starEmpty,
              height: 32,
              width: 32,
            ),
          ),
        );
      },
    );
  }
}

class PowerstatsWidget extends StatelessWidget {
  final Powerstats powerstats;
  const PowerstatsWidget({super.key, required this.powerstats});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 292,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Powerstats'.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: SuperheroesColors.whiteText,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Center(
                  child: PowerstatWidget(
                    title: 'intelligence',
                    value: powerstats.intelligencePersent,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: PowerstatWidget(
                    title: 'strength',
                    value: powerstats.strengthPersent,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: PowerstatWidget(
                    title: 'speed',
                    value: powerstats.speedPersent,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Center(
                  child: PowerstatWidget(
                    title: 'durability',
                    value: powerstats.durabilityPersent,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: PowerstatWidget(
                    title: 'power',
                    value: powerstats.powerPersent,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: PowerstatWidget(
                    title: 'combat',
                    value: powerstats.combatPersent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PowerstatWidget extends StatelessWidget {
  String title;
  double value;
  final canvas = Canvas(PictureRecorder());
  //CustomPaint paint = CustomPaint();

  PowerstatWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //CustomPaint(painter: Paint),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            ArcWidget(color: calculateColorByValue(value), value: value),
            Padding(
              padding: const EdgeInsets.only(top: 17),
              child: Text(
                '${(value * 100).toInt()}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: calculateColorByValue(value),
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        Text(
          title.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: SuperheroesColors.whiteText,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Color calculateColorByValue(double value) {
    if (value >= 0.0 && value <= 0.5) {
      return Color.lerp(Color(0xFFF10C0C), Color(0xFFF97236), value * 2)!;
    } else if (value <= 1.0) {
      return Color.lerp(Color(0xFFF97236), Color(0xFF019B2C), value * 2 - 1)!;
    }
    {
      return Colors.black;
    }
  }
}

class ArcWidget extends StatelessWidget {
  final double value;
  final Color color;

  const ArcWidget({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ArcCustomPainter(color: color, value: value),
      size: Size(66, 33),
    );
  }
}

class ArcCustomPainter extends CustomPainter {
  final double value;
  final Color color;

  ArcCustomPainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final backgroundPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;
    canvas.drawArc(rect, pi, pi, false, backgroundPaint);
    canvas.drawArc(rect, pi, pi * value, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return !(oldDelegate is ArcCustomPainter &&
        oldDelegate.value == value &&
        oldDelegate.color == color);
  }
}

class BiographyWidget extends StatelessWidget {
  final Biography biography;

  const BiographyWidget({super.key, required this.biography});

  @override
  Widget build(BuildContext context) {
    final AlignmentInfo? alignmentInfo = AlignmentInfo.fromAlignment(
      biography.alignment,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: AlignmentGeometry.topEnd,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            //height: 300,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: SuperheroesColors.superheroPageImageBackground,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Bio'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    //height: 1.2,
                    fontSize: 18,
                    color: SuperheroesColors.whiteText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                BioElement(title: 'Full Name', text: biography.fullName),
                const SizedBox(height: 20),
                BioElement(
                  title: 'Alliases',
                  text: biography.aliases.join(', '),
                ),
                const SizedBox(height: 20),
                BioElement(
                  title: 'Place of Birth',
                  text: biography.placeOfBirth,
                ),
              ],
            ),
          ),
          if (alignmentInfo != null)
            AlignmentMark(alignmentInfo: alignmentInfo),
        ],
      ),
    );
  }
}

class AlignmentMark extends StatelessWidget {
  final AlignmentInfo alignmentInfo;
  const AlignmentMark({super.key, required this.alignmentInfo});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Container(
        height: 24,
        width: 70,
        //color: alignmentInfo.color,
        decoration: BoxDecoration(
          color: alignmentInfo.color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        //padding: EdgeInsets.symmetric(vertical: 6),
        alignment: Alignment.center,
        child: Text(
          alignmentInfo.name.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Roboto',
            color: SuperheroesColors.whiteText,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class BioElement extends StatelessWidget {
  final String title;
  final String text;
  const BioElement({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          textAlign: TextAlign.left,
          style: TextStyle(
            // height: 1.3,
            fontSize: 12,
            color: SuperheroesColors.biographyTitle,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
            // height: 1.3,
            fontSize: 16,
            color: SuperheroesColors.whiteText,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
