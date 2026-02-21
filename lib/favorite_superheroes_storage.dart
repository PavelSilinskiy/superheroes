import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteSuperheroesStorage {
  static const _key = "favorite_superheroes";

  final PublishSubject updater = PublishSubject<Null>();

  static FavoriteSuperheroesStorage? _instance;

  factory FavoriteSuperheroesStorage.getInstance() {
    return _instance ??= FavoriteSuperheroesStorage._internal();
  }

  FavoriteSuperheroesStorage._internal();


  Future<List<String>> _getRawSuperheroes() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getStringList(_key) ?? [];
  }

  Future<bool> _setRawSuperheroes(List<String> rawSuperheroes) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final result = sp.setStringList(_key, rawSuperheroes);
    updater.add(null);
    return result;
  }

  Future<List<Superhero>> _getSuperheroes() async {
    final rawSuperheroes = await _getRawSuperheroes();
    final List<Superhero> superheroes = rawSuperheroes
        .map<Superhero>(
          (rawSuperhero) => Superhero.fromJson(json.decode(rawSuperhero)),
        )
        .toList();
    return superheroes;
  }

  Future<bool> _setSuperheroes(List<Superhero> superheroes) async {
    final List<String> rawSuperheroes = superheroes
        .map<String>((superhero) => json.encode(superhero.toJson()))
        .toList();
    return _setRawSuperheroes(rawSuperheroes);
  }

  Future<bool> addToFavorites(final Superhero superhero) async {
    final rawSuperheroes = await _getRawSuperheroes();
    rawSuperheroes.add(json.encode(superhero.toJson()));
    return await _setRawSuperheroes(rawSuperheroes);
  }

  Future<bool> tryToUpdateFavorite(final Superhero superhero) async {
    List<Superhero> superheroes = await _getSuperheroes();
    bool found = false;
    superheroes = superheroes.map<Superhero>((e) {
      if (e.id == superhero.id) {
        found = true;
        return superhero;
      } else {return e;}
    }).toList();
    return (found && await _setSuperheroes(superheroes));
  }

  Future<bool> removeFromFavorites(final String id) async {
    final superheroes = await _getSuperheroes();
    superheroes.removeWhere((item) => (item.id == id));
    return await _setSuperheroes(superheroes);
  }

  Future<Superhero?> getSuperhero(final String id) async {
    final List<Superhero> superheroes = await _getSuperheroes();
    for (var superhero in superheroes) {
      if (superhero.id == id) {
        return superhero;
      }
    }
    return null;
  }

  Future<bool> isFavorite(final String id) async {
    return (await getSuperhero(id) != null);
  }

  Stream<List<Superhero>> observeFavoriteSuperheroes() async* {
    yield await _getSuperheroes();
    await for (var _ in updater) {
      yield await _getSuperheroes();
    }
  }

  Stream<bool> observeIsFavorite(final String id) async* {
    yield await isFavorite(id);
    await for (var _ in updater) {
      yield await isFavorite(id);
    } 
  }
}
