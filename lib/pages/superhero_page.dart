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
import 'package:superheroes/widgets/action_button.dart';

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
    final superhero = Superhero(
      id: bloc.id,
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
                  child: PowerstatsWidget(powerstats: superhero.powerstats),
                ),
              const SizedBox(height: 36),
              BiographyWidget(biography: superhero.biography),
            ],
          ),
        ),
      ],
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
      return Color.lerp(Color(0xFFF97236), Color(0xFF019B2C), value * 2)!;
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
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Text(
        biography.toJson.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: SuperheroesColors.whiteText),
      ),
    );
  }
}
