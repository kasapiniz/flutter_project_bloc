import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math show Random;

import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.blue),
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  ));
}

const names = [
  'Mehmet',
  'Ali',
  'Veli',
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

/*
 A [Cubit] is similar to [Bloc] but has no notion of events and relies on methods to [emit] new states.

Every [Cubit] requires an initial state which will be the state of the [Cubit] before [emit] has been called.

The current state of a [Cubit] can be accessed via the [state] getter.
 */
class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

// emit =Updates the [state] to the provided [state]. [emit] does nothing if the [state] being emitted is equal to the current [state].
  void pickRandomName() => emit(names.getRandomElement());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubit cubit;
  @override
  void initState() {
    cubit = NamesCubit();
    super.initState();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Flutter Bloc Test")),
        body: StreamBuilder<String?>(
            stream: cubit.stream,
            builder: (context, snapshot) {
              final button = TextButton(
                onPressed: () => cubit.pickRandomName(),
                child: Text("Pick a random name"),
              );

              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return button;
                case ConnectionState.waiting:
                  return button;
                case ConnectionState.active:
                  return Column(
                    children: [
                      Text(snapshot.data ?? ''),
                      button,
                    ],
                  );
                case ConnectionState.done:
                  return const SizedBox();
              }
            }));
  }
}
