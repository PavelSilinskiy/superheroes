import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';

class MainPage extends StatelessWidget {
  final MainBloc bloc = MainBloc();

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<MainPageState>(
          stream: bloc.observeMainPageState(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return SizedBox();
            } else {
              return Center(
                child: Text(snapshot.data.toString()),
              );
            }
          },
        ),
      ),
    );
  }
}
