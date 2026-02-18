import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/pages/main_page.dart';
import 'package:http/http.dart' as http;

import '../model/superhero.dart';

class SuperheroBloc {
  http.Client? client;
  String id;
  final _superheroSubject = BehaviorSubject<Superhero>();
  StreamSubscription? requestSubscription;

  SuperheroBloc({this.client, required this.id}) {
    requestSuperhero();
  }


  Stream<Superhero> observeSuperhero() => _superheroSubject.stream;


  void requestSuperhero() {
    requestSubscription?.cancel();
    requestSubscription = request(id).asStream().listen(
      (superhero) {
        _superheroSubject.add(superhero);
      },
      onError: (error, stackTrace) {
        print('Error happened in requestSuperhero(): $error, $stackTrace');
      }
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
      }
      else if (decoded['response'] == 'error') {
        throw ApiException("Client error happened");
      }
    }
    throw Exception('Unknown error happened');
  }

  void dispose() {
    requestSubscription?.cancel();
    _superheroSubject.close();
    client?.close();
  }
}
