import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resourses/superheroes_colors.dart';

class MainPage extends StatelessWidget {
  final MainBloc bloc = MainBloc();

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SuperheroesColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            StreamBuilder<MainPageState>(
              stream: bloc.observeMainPageState(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return SizedBox();
                } else {
                  return Center(
                    child: Text(
                      snapshot.data.toString(),
                      style: TextStyle(color: SuperheroesColors.whiteText),
                    ),
                  );
                }
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  print('tapped');
                },
                child: Text(
                  "Next state".toUpperCase(),
                  style: TextStyle(
                    color: SuperheroesColors.whiteText,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
