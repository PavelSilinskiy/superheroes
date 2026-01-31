import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resourses/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainBloc bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return Provider<MainBloc>.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: SuperheroesColors.background,
        body: SafeArea(child: MainPageContent()),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class MainPageContent extends StatelessWidget {
  const MainPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return Stack(
      children: [
        Center(child: MainPageStateWidget()),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              bloc.nextState();
            },
            child: ActionButton(
              text: "Next state".toUpperCase(),
              onPressed: () {
                bloc.nextState();
              },
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
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder<MainPageState>(
      stream: bloc.observeMainPageState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return SizedBox();
        } else {
          final state = snapshot.data!;
          switch (state) {
            case MainPageState.noFavorites:
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
                            padding: const EdgeInsets.only(top: 9.0),
                            child: Image.asset(
                              'assets/images/ironman.png',
                              width: 108,
                              height: 119,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No favorites yet',
                      style: TextStyle(
                        color: SuperheroesColors.whiteText,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Search and add'.toUpperCase(),
                      style: TextStyle(
                        color: SuperheroesColors.whiteText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 30),
                    ActionButton(text: 'Search', onPressed: () {}),
                  ],
                ),
              );

            case MainPageState.minSymbols:
              return Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 110.0),
                  child: Text(
                    "Enter at least 3 symbols",
                    style: TextStyle(
                      color: SuperheroesColors.whiteText,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );

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
          color: SuperheroesColors.foregroundColor,
          strokeWidth: 4,
        ),
      ),
    );
  }
}
