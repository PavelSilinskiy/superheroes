import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:superheroes/pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.openSansTextTheme(textTheme)),
      home: MainPage(),
    );
  }
}
