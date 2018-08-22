import 'package:flutter/material.dart';
import 'details_page.dart';

class MainPage extends StatefulWidget {
  static const navigateToDetailsButtonKey = Key('navigateToDetails');

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _popResult;

  void _navigateToDetailsPage(BuildContext context) async {
    final route = MaterialPageRoute(builder: (_) => DetailsPage('Hello!'));
    final result = await Navigator.of(context).push(route);

    setState(() {
      _popResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing navigation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Pop result: $_popResult'),
            RaisedButton(
              key: MainPage.navigateToDetailsButtonKey,
              onPressed: () => _navigateToDetailsPage(context),
              child: Text('Navigate to details page!'),
            ),
          ],
        ),
      ),
    );
  }
}
