class MainBloc {
  Stream<MainPageState> observeMainPageState() {
    return Stream.periodic(
      Duration(seconds: 2),
      (tick) => tick,
    ).map((tick) => MainPageState.values[tick % MainPageState.values.length]);
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
