import 'package:flutter/material.dart';
import 'package:superheroes/resourses/superheroes_colors.dart';

class SuperheroCard extends StatelessWidget {
  final String name;
  final String realName;
  final String imageUrl;
  const SuperheroCard({
    super.key,
    required this.name,
    required this.realName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: SuperheroesColors.cardColor,
      child: Row(
        children: [
          Image.network(imageUrl, width: 70, height: 70, fit: BoxFit.cover),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.toUpperCase(),
                  style: TextStyle(
                    color: SuperheroesColors.whiteText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  
                ),
                Text(
                  realName,
                  style: TextStyle(
                    color: SuperheroesColors.whiteText,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
