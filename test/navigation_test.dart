import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:testing_navigation/details_page.dart';
import 'package:testing_navigation/main_page.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('Navigation tests', () {
    NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    Future<Null> _buildMainPage(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MainPage(),

        /// This mocked observer will now receive all navigation events
        /// that happen in our app.
        navigatorObservers: [mockObserver],
      ));

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(typed(any), typed(any)));
    }

    Future<Null> _navigateToDetailsPage(WidgetTester tester) async {
      /// Tap the button which should navigate to the details page.
      /// By calling tester.pumpAndSettle(), we ensure that all animations
      /// have completed before we continue further.
      await tester.tap(find.byKey(MainPage.navigateToDetailsButtonKey));
      await tester.pumpAndSettle();
    }

    testWidgets(
        'when tapping "navigate to details" button, should navigate to details page',
        (WidgetTester tester) async {
      await _buildMainPage(tester);
      await _navigateToDetailsPage(tester);

      /// By tapping the button, we should've now navigated to the details
      /// page. The didPush() method should've been called...
      verify(mockObserver.didPush(typed(any), typed(any)));

      /// ...and there should be a DetailsPage present in the widget tree...
      expect(find.byType(DetailsPage), findsOneWidget);

      /// ...with the message we sent from main page.
      expect(find.text('Hello!'), findsOneWidget);
    });

    testWidgets('tapping "click me" should pop with a result',
        (WidgetTester tester) async {
      /// We'll build the main page and navigate to details first.
      await _buildMainPage(tester);
      await _navigateToDetailsPage(tester);

      /// Then we'll verify that the details route was pushed again, but
      /// this time, we'll capture the route.
      final Route pushedRoute =
          verify(mockObserver.didPush(typed<Route>(captureAny), typed(any)))
              .captured
              .single;

      /// We declare a popResult variable and assign the result to it
      /// when the details route is popped.
      String popResult;
      pushedRoute.popped.then((result) => popResult = result);

      /// Pop the details route with a result by tapping the button.
      await tester.tap(find.byKey(DetailsPage.popWithResultButtonKey));
      await tester.pumpAndSettle();

      /// popResult should now contain whatever the details page sent when
      /// calling `Navigator.pop()`. In this case, "I'm a pirate".
      expect(popResult, 'I\'m a pirate.');
    });
  });
}
