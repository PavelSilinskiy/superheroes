import 'package:flutter/material.dart';
import 'package:superheroes/resourses/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';

class InfoWithButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final String assetImage;
  final double imageHeight;
  final double imageWidth;
  final double imageTopPudding;

  const InfoWithButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.assetImage,
    required this.imageHeight,
    required this.imageWidth,
    required this.imageTopPudding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  height: 108,
                  width: 108,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: SuperheroesColors.foregroundColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: imageTopPudding),
                  child: Image.asset(
                    assetImage,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              color: SuperheroesColors.whiteText,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 20),
          Text(
            subtitle.toUpperCase(),
            style: TextStyle(
              color: SuperheroesColors.whiteText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 30),
          ActionButton(text: buttonText, onPressed: () {}),
        ],
      ),
    );
  }
}
