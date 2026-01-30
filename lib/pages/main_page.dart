import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resourses/superheroes_colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainBloc bloc = MainBloc();

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
                  bloc.nextState();
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

  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
