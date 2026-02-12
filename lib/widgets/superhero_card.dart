import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resourses/superheroes_colors.dart';

class SuperheroCard extends StatelessWidget {
  final SuperheroInfo superheroInfo;
  final VoidCallback onTap;
  const SuperheroCard({
    super.key,
    required this.superheroInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: SuperheroesColors.cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: superheroInfo.imageUrl,
              httpHeaders: {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
                'Referer': 'https://www.superherodb.com/',
              },
              errorWidget: (context, url, error) => ErrorWidget(error),
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    superheroInfo.name.toUpperCase(),
                    style: TextStyle(
                      color: SuperheroesColors.whiteText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    superheroInfo.realName,
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
      ),
    );
  }
}
