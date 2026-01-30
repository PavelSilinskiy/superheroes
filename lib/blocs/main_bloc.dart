import 'dart:async';

import 'package:rxdart/subjects.dart';

class MainBloc {
  final BehaviorSubject<MainPageState> _stateSubject = BehaviorSubject();

  MainBloc() {
    _stateSubject.sink.add(MainPageState.noFavorites);
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

  void dispose() {
    _stateSubject.close();
  }
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
