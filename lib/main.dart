import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ads plugin performance',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const ListScreen(),
    );
  }
}

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ads plugin performance'),
      ),
      body: ListView.builder(
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, top: 4.0, right: 10.0, bottom: 4.0),
                child: Card(
                  elevation: 2.0,
                  child: ListTile(
                    title: Text('Element $index'),
                  ),
                ),
              )),
    );
  }
}
