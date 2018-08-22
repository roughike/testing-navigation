import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  static const popWithResultButtonKey = Key('popWithResult');

  DetailsPage(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            RaisedButton(
              key: popWithResultButtonKey,
              onPressed: () => Navigator.pop(context, 'I\'m a pirate.'),
              child: Text('Click me!'),
            ),
          ],
        ),
      ),
    );
  }
}
