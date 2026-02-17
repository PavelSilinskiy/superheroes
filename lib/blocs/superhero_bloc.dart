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

  SuperheroBloc({this.client, required this.id});

  void dispose() {
    client?.close();
  }
}
