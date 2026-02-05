import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:superheroes/pages/main_page.dart';

class MainBloc {
  static const minSymbols = 3;
  final BehaviorSubject<MainPageState> _stateSubject = BehaviorSubject();
  // final BehaviorSubject<List<SuperheroInfo>> _favoritesInfoSubject =
  //     BehaviorSubject.seeded(SuperheroInfo.mocked);
  final BehaviorSubject<List<SuperheroInfo>> _favoritesInfoSubject =
      BehaviorSubject.seeded([]);
  final BehaviorSubject<List<SuperheroInfo>> _searchedInfoSubject =
      BehaviorSubject();
  final BehaviorSubject<String> _currentTextSubject = BehaviorSubject.seeded(
    '',
  );

  StreamSubscription? _currentTextSubscription;

  StreamSubscription? _searchSubscription;

  MainBloc() {
    _stateSubject.sink.add(MainPageState.noFavorites);
    _currentTextSubscription =
        Rx.combineLatest2<String, List<SuperheroInfo>, MainPageStateInfo>(
          _currentTextSubject.distinct().debounceTime(
            Duration(milliseconds: 500),
          ),
          _favoritesInfoSubject,
          (searchText, favorites) {
            return MainPageStateInfo(
              searchText: searchText,
              haveFavorites: favorites.isNotEmpty,
            );
          },
        ).listen((value) {
          _searchSubscription?.cancel();
          if (value.searchText.isEmpty) {
            if (value.haveFavorites) {
              _stateSubject.add(MainPageState.favorites);
            } else {
              _stateSubject.add(MainPageState.noFavorites);
            }
          } else if (value.searchText.length < minSymbols) {
            _stateSubject.add(MainPageState.minSymbols);
          } else {
            searchForSuperheroes(value.searchText);
          }
        });
  }

  Stream<MainPageState> observeMainPageState() {
    return _stateSubject;
  }

  Stream<List<SuperheroInfo>> observeFavorites() {
    return _favoritesInfoSubject;
  }

  void nextState() {
    final currentState = _stateSubject.value;
    final nextState = MainPageState
        .values[(currentState.index + 1) % MainPageState.values.length];
    _stateSubject.sink.add(nextState);
  }

  void updateText(String text) {
    _currentTextSubject.add(text);
  }

  void dispose() {
    _currentTextSubscription?.cancel();
    _stateSubject.close();
    _favoritesInfoSubject.close();
    _searchedInfoSubject.close();
    _currentTextSubject.close();
  }

  Stream<List<SuperheroInfo>> observeSearchedSuperheroes() {
    return _searchedInfoSubject;
  }

  void searchForSuperheroes(String text) {
    _stateSubject.add(MainPageState.loading);
    _searchSubscription?.cancel();
    _searchSubscription = search(text).asStream().listen(
      (searchResults) {
        if (searchResults.isEmpty) {
          _stateSubject.add(MainPageState.nothingFound);
        } else {
          _searchedInfoSubject.add(searchResults);
          _stateSubject.add(MainPageState.searchResults);
        }
      },
      onError: (error, stackTrace) {
        _stateSubject.add(MainPageState.loadingError);
      },
    );
  }

  Future<List<SuperheroInfo>> search(String query) async {
    await Future.delayed(Duration(seconds: 1));
    return SuperheroInfo.mocked
        .where(
          (element) =>
              (element.name.toLowerCase().contains(query.toLowerCase())),
        )
        .toList();
  }
}

class SuperheroInfo {
  final String name;
  final String realName;
  final String imageUrl;

  const SuperheroInfo({
    required this.name,
    required this.realName,
    required this.imageUrl,
  });

  @override
  String toString() {
    return 'SuperHeroInfo{name: $name, realName: $realName, imageUrl: $imageUrl}';
  }

  @override
  bool operator ==(Object other) {
    return (identical(this, other) ||
        other is SuperheroInfo &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            realName == other.realName &&
            imageUrl == other.imageUrl);
  }

  @override
  int get hashCode => name.hashCode ^ realName.hashCode ^ imageUrl.hashCode;

  static const mocked = [
    SuperheroInfo(
      name: 'Batman',
      realName: 'Bruce Wayne',
      imageUrl:
          'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
    ),
    SuperheroInfo(
      name: 'Ironman',
      realName: 'Tony Stark',
      imageUrl: 'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg',
    ),
    SuperheroInfo(
      name: 'Venom',
      realName: 'Eddie Brock',
      imageUrl: 'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg',
    ),
  ];
}

enum MainPageState {
  noFavorites,
  minSymbols,
  loading,
  nothingFound,
  loadingError,
  searchResults,
  favorites,
}

class MainPageStateInfo {
  final String searchText;
  final bool haveFavorites;

  const MainPageStateInfo({
    required this.searchText,
    required this.haveFavorites,
  });

  @override
  bool operator ==(Object other) {
    return (identical(this, other) ||
        other is MainPageStateInfo &&
            runtimeType == other.runtimeType &&
            searchText == other.searchText &&
            haveFavorites == other.haveFavorites);
  }

  @override
  int get hashCode => searchText.hashCode ^ haveFavorites.hashCode;

  @override
  String toString() {
    return 'MainPageStateInfo{searchText: $searchText, haveFavorites: $haveFavorites}';
  }
}
