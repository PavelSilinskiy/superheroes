import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resourses/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';

import '../resourses/superheroes_images.dart';

class MainPage extends StatefulWidget {
  final http.Client? client;
  const MainPage({super.key, this.client});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainBloc bloc;
  late FocusNode textFieldFocusNode;

  @override
  Widget build(BuildContext context) {
    return Provider<MainBloc>.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: SuperheroesColors.background,
        body: SafeArea(child: MainPageContent(textFieldFocusNode: textFieldFocusNode)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    bloc = MainBloc(client: widget.client);
    textFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class MainPageContent extends StatelessWidget {
  final FocusNode textFieldFocusNode;

  const MainPageContent({super.key, required this.textFieldFocusNode});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return Stack(
      children: [
        Center(child: MainPageStateWidget(textFieldFocusNode: textFieldFocusNode)),
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: GestureDetector(
        //     onTap: () {
        //       bloc.nextState();
        //     },
        //     child: ActionButton(
        //       text: "Next state".toUpperCase(),
        //       onPressed: () {
        //         bloc.nextState();
        //       },
        //     ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12),
          child: SearchWidget(textFieldFocusNode: textFieldFocusNode),
        ),
      ],
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  final FocusNode textFieldFocusNode;

  MainPageStateWidget({super.key, required this.textFieldFocusNode});

  // final focus = FocusNode();

  // void focusSearch() {}

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
              return InfoWithButton(
                title: 'No favorites yet',
                subtitle: 'Search and add',
                buttonText: 'Search',
                assetImage: SuperheroesImages.ironman,
                imageHeight: 119,
                imageWidth: 108,
                imageTopPudding: 9,
                onTap: () {
                  FocusScope.of(context).requestFocus(textFieldFocusNode);
                },
              );

            case MainPageState.minSymbols:
              return MinSymbolsStateScreen();

            case MainPageState.loading:
              return LoadingIndicator();

            case MainPageState.nothingFound:
              return InfoWithButton(
                title: 'Nothing found',
                subtitle: 'Search for something else',
                buttonText: 'Search',
                assetImage: SuperheroesImages.hulk,
                imageHeight: 112,
                imageWidth: 84,
                imageTopPudding: 16,
                onTap: () {
                  FocusScope.of(context).requestFocus(textFieldFocusNode);
                },
              );

            case MainPageState.loadingError:
              return InfoWithButton(
                title: 'Error happened',
                subtitle: 'Please, try again',
                buttonText: 'Retry',
                assetImage: SuperheroesImages.superman,
                imageHeight: 106,
                imageWidth: 126,
                imageTopPudding: 24,
                onTap: bloc.retry,
              );

            case MainPageState.searchResults:
              return SearchResultsStateScreen();

            case MainPageState.favorites:
              return FavoritesStateScreen();
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

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key, required this.textFieldFocusNode});

  final FocusNode textFieldFocusNode;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final bloc = Provider.of<MainBloc>(context, listen: false);
      controller.addListener(() {
        bloc.updateText(controller.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder(
      stream: bloc.observeCurrentText().distinct(
        (a, b) => a.isEmpty == b.isEmpty,
      ),
      builder: (context, asyncSnapshot) {
        return TextField(
          focusNode: widget.textFieldFocusNode,
          controller: controller,
          onChanged: bloc.updateText,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: SuperheroesColors.whiteText,
          ),
          cursorColor: SuperheroesColors.focusedSearchText,
          textInputAction: TextInputAction.search,
          textCapitalization: TextCapitalization.words,
          //keyboardType: TextInputType.webSearch,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: SuperheroesColors.searchBarBackground,
            prefixIcon: Icon(
              Icons.search,
              color: SuperheroesColors.enabledSearchText,
              size: 24,
            ),
            suffix: GestureDetector(
              onTap: () {
                controller.clear();
              },
              child: Icon(
                Icons.clear,
                color: SuperheroesColors.whiteText,
                size: 24,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            enabledBorder:
                (asyncSnapshot.data != null && asyncSnapshot.data!.isNotEmpty)
                ? OutlineInputBorder(
                    borderSide: BorderSide(
                      color: SuperheroesColors.focusedSearchText,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  )
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: SuperheroesColors.enabledTextFieldBorder,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: SuperheroesColors.focusedSearchText,
                width: 2,
              ),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        );
      },
    );
  }
}

class MinSymbolsStateScreen extends StatelessWidget {
  const MinSymbolsStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}

class FavoritesStateScreen extends StatelessWidget {
  const FavoritesStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<MainBloc>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(top: 90, left: 16, right: 16),
      child: SuperheroesList(
        title: 'Your favorites',
        stream: bloc.observeFavorites(),
        ableToSwipe: true,
      ),
    );
  }
}

class SearchResultsStateScreen extends StatelessWidget {
  const SearchResultsStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<MainBloc>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(top: 90, left: 16, right: 16),
      child: SuperheroesList(
        title: 'Search results',
        stream: bloc.observeSearchedSuperheroes(),
      ),
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

class SuperheroesList extends StatelessWidget {
  final String title;
  final Stream<List<SuperheroInfo>> stream;
  final bool ableToSwipe;

  const SuperheroesList({super.key, required this.title, required this.stream, this.ableToSwipe = false});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SuperheroInfo>>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        } else {
          return ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: snapshot.data!.length + 1,
            itemBuilder: (context, i) {
              if (i == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    textAlign: TextAlign.left,
                    title,
                    style: TextStyle(
                      color: SuperheroesColors.whiteText,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                );
              } else {
                final item = snapshot.data![i - 1];
                return ListTile(superheroInfo: item, ableToSwipe: ableToSwipe);
              }
            },
            separatorBuilder: (context, index) => SizedBox(height: 8),
          );
        }
      },
    );
  }
}

class ListTile extends StatelessWidget {
  const ListTile({super.key, required this.superheroInfo, this.ableToSwipe = false});

  final SuperheroInfo superheroInfo;
  final bool ableToSwipe;


  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<MainBloc>(context, listen: false);
    return Dismissible(
      key: ValueKey(superheroInfo.id),
      direction: ableToSwipe ? DismissDirection.horizontal : DismissDirection.none,
      background: Container(
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: SuperheroesColors.removeFromFavoritesBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Remove from favorites'.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            color: SuperheroesColors.whiteText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      onDismissed: (direction) {bloc.removeFromFavorites(superheroInfo.id);},
      child: SuperheroCard(
        superheroInfo: superheroInfo,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SuperheroPage(id: superheroInfo.id),
            ),
          );
        },
      ),
    );
  }
}
