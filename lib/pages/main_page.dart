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
      body: SafeArea(child: MainPageContent()),
    );
  }

  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class MainPageContent extends StatelessWidget {
  const MainPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final _MainPageState state = context
        .findAncestorStateOfType<_MainPageState>()!;
    final MainBloc bloc = state.bloc;
    return Stack(
      children: [
        Center(child: MainPageStateWidget()),
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
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  const MainPageStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _MainPageState state = context
        .findAncestorStateOfType<_MainPageState>()!;
    final MainBloc bloc = state.bloc;
    return StreamBuilder<MainPageState>(
      stream: bloc.observeMainPageState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return SizedBox();
        } else {
          final state = snapshot.data!;
          switch (state) {
            //case MainPageState.noFavorites:
            // TODO: Handle this case.

            //case MainPageState.minSymbols:
            // TODO: Handle this case.

            case MainPageState.loading:
              return LoadingIndicator();

            //case MainPageState.nothingFound:
            // TODO: Handle this case.

            //case MainPageState.loadingError:
            // TODO: Handle this case.

            //case MainPageState.searchResults:
            // TODO: Handle this case.

            //case MainPageState.favorites:
            // TODO: Handle this case.

            default:
              return Text(
                state.toString(),
                style: TextStyle(color: SuperheroesColors.whiteText),
              );
          }
        }
      },
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 110),
      child: Align(
        alignment: AlignmentGeometry.topCenter,
        child: CircularProgressIndicator(
          color: SuperheroesColors.progressIndicator,
          strokeWidth: 4,
        ),
      ),
    );
  }
}
