import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/favorite_superheroes_storage.dart';
import 'package:superheroes/pages/main_page.dart';
import 'package:http/http.dart' as http;

import '../model/superhero.dart';

class SuperheroBloc {
  http.Client? client;
  String id;
  final _superheroSubject = BehaviorSubject<Superhero>();
  //final _storage = FavoriteSuperheroesStorage();
  StreamSubscription? requestSubscription;
  StreamSubscription? getFromFavoritesSubscription;
  StreamSubscription? addToFavoritesSubscription;
  StreamSubscription? removeFromFavoritesSubscription;

  SuperheroBloc({this.client, required this.id}) {
    getFromFavorites();
    requestSuperhero();
  }

  Stream<Superhero> observeSuperhero() => _superheroSubject.stream;

  Stream<bool> observeIsFavorite() =>
      FavoriteSuperheroesStorage.getInstance().observeIsFavorite(id);

  void requestSuperhero() {
    requestSubscription?.cancel();
    requestSubscription = request(id).asStream().listen(
      (superhero) {
        _superheroSubject.add(superhero);
      },
      onError: (error, stackTrace) {
        print('Error happened in requestSuperhero(): $error, $stackTrace');
      },
    );
  }

  void getFromFavorites() async {
    getFromFavoritesSubscription?.cancel();
    getFromFavoritesSubscription = FavoriteSuperheroesStorage.getInstance().getSuperhero(id).asStream().listen(
      (superhero) {
        if (superhero != null) {
          _superheroSubject.add(superhero);
        } else {
          print('Superhero with id $id is not in favorites');
        }
      },
      onError: (error, stackTrace) {
        print('Error happened in getFromFavorites(): $error, $stackTrace');
      },
    );
  }

  void addToFavorites() async {
    final value = _superheroSubject.valueOrNull;
    addToFavoritesSubscription?.cancel();
    if (value == null) {
      print('ERROR: No superhero to add to favorites');
      return;
    } else {
      addToFavoritesSubscription = FavoriteSuperheroesStorage.getInstance()
          .addToFavorites(value)
          .asStream()
          .listen(
            (result) {
              if (result) {
                print(
                  'Superhero ${value.name} added to favorites successfully',
                );
              } else {
                print('Failed to add superhero ${value.name} to favorites');
              }
            },
            onError: (error, stackTrace) {
              print('Error happened in addToFavorites(): $error, $stackTrace');
            },
          );
    }
  }

  void removeFromFavorites() async {
    removeFromFavoritesSubscription?.cancel();
    removeFromFavoritesSubscription = FavoriteSuperheroesStorage.getInstance()
        .removeFromFavorites(id)
        .asStream()
        .listen(
          (result) {
            if (result) {
              print(
                'Superhero with id $id removed from favorites successfully',
              );
            } else {
              print('Failed to remove superhero with id $id from favorites');
            }
          },
          onError: (error, stackTrace) {
            print(
              'Error happened in removeFromFavorites(): $error, $stackTrace',
            );
          },
        );
  }

  Future<Superhero> request(String id) async {
    final token = dotenv.env["SUPERHERO_TOKEN"];
    final response = await (client ??= http.Client()).get(
      //Uri.parse('https://superheroapi.com/api/fgbme/search/$text'),
      Uri.parse('https://superheroapi.com/api/$token/$id'),
    );
    if (400 <= response.statusCode && response.statusCode <= 499) {
      throw ApiException("Client error happened");
    }
    if (500 <= response.statusCode && response.statusCode <= 599) {
      throw ApiException("Server error happened");
    }
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['response'] == 'success') {
        return Superhero.fromJson(decoded);
      } else if (decoded['response'] == 'error') {
        throw ApiException("Client error happened");
      }
    }
    throw Exception('Unknown error happened');
  }

  void dispose() {
    getFromFavoritesSubscription?.cancel();
    addToFavoritesSubscription?.cancel();
    removeFromFavoritesSubscription?.cancel();
    requestSubscription?.cancel();
    _superheroSubject.close();
    client?.close();
  }
}
