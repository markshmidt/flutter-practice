import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
  var favorites = <WordPair>[]; //the list can only ever contain word pairs: <WordPair>[]

  void toggleFavorite() { // either removes the current word pair from the list of favorites (if it's already there), or adds it (if it isn't there yet). I
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //center UI
          mainAxisSize: MainAxisSize.min,
          children: [
            BigCard(pair: pair),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                appState.toggleFavorite();
              },
              icon: Icon(icon),
              label: Text('Like'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: Text('Next'),
            ),
          ],

        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  final WordPair pair;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // code requests the app's current theme with Theme.of(context).
    final style = theme.textTheme.displayMedium!.copyWith( //displayMedium property is a large style meant for display text.
      // copywith - returns a copy of the text style with the changes you define
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Text(
        pair.asLowerCase,
        style: style,
        semanticsLabel: "${pair.first} ${pair.second}", //override the visual content of the text widget with a semantic content that is more appropriate for screen r
      ),
    );
  }
}