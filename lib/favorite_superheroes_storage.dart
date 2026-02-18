import 'package:superheroes/model/superhero.dart';

class FavoriteSuperheroesStorage {

  Future<bool> addToFavorites(final Superhero superhero) async {
    //TODO:
    throw UnimplementedError();
  }

  Future<bool> removeFromFavorites(final String id) async {
    //TODO:
    throw UnimplementedError();
  }

  Future<Superhero> getSuperhero(final String id) async {
    //TODO:
    throw UnimplementedError();
  }

  Stream<List<Superhero>> observeFavoriteSuperheroes () {
    //TODO:
    throw UnimplementedError();
  }

  Stream<bool> observeIsFavorite (final String id) {
    //TODO:
    throw UnimplementedError();
  }


  
}