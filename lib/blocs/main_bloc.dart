import 'dart:async';

import 'package:rxdart/subjects.dart';

class MainBloc {
  static const minSymbols = 3;
  final BehaviorSubject<MainPageState> _stateSubject = BehaviorSubject();
  final BehaviorSubject<List<SuperHeroInfo>> _favoritesInfoSubject =
      BehaviorSubject.seeded(SuperHeroInfo.mocked);
  final BehaviorSubject<List<SuperHeroInfo>> _searchedInfoSubject =
      BehaviorSubject();
  final BehaviorSubject<String> _currentTextSubject = BehaviorSubject.seeded(
    '',
  );

  StreamSubscription? _searchTextSubscription;

  MainBloc() {
    _stateSubject.sink.add(MainPageState.noFavorites);
    _searchTextSubscription = _currentTextSubject.listen((text) {
      if (text.isEmpty) {
        _stateSubject.add(MainPageState.favorites);
      } else if (text.length < minSymbols) {
        _stateSubject.add(MainPageState.minSymbols);
      } else {
        searchForSuperheroes(text);
      }
    });
  }

  Stream<MainPageState> observeMainPageState() {
    return _stateSubject;
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
    _searchTextSubscription?.cancel();
    _stateSubject.close();
    _favoritesInfoSubject.close();
    _searchedInfoSubject.close();
    _currentTextSubject.close();
  }

  void searchForSuperheroes(String text) {}
}

class SuperHeroInfo {
  final String name;
  final String realName;
  final String imageURL;

  const SuperHeroInfo({
    required this.name,
    required this.realName,
    required this.imageURL,
  });

  @override
  String toString() {
    return 'SuperHeroInfo{name: $name, realName: $realName, imageURL: $imageURL}';
  }

  @override
  bool operator ==(Object other) {
    return (identical(this, other) ||
        other is SuperHeroInfo &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            realName == other.realName &&
            imageURL == other.imageURL);
  }

  @override
  int get hashCode => name.hashCode ^ realName.hashCode ^ imageURL.hashCode;

  static const mocked = [
    SuperHeroInfo(
      name: 'Batman',
      realName: 'Bruce Wayne',
      imageURL:
          'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
    ),
    SuperHeroInfo(
      name: 'Ironman',
      realName: 'Tony Stark',
      imageURL: 'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg',
    ),
    SuperHeroInfo(
      name: 'Venom',
      realName: 'Eddie Brock',
      imageURL: 'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg',
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
