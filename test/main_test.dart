import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hike_locator/main.dart';
import 'package:hike_locator/screens/home_screen.dart';


void main() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.
//  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
//    // Create the Widget tell the tester to build it
//    await tester.pumpWidget(MyApp(loggedIn: 0));
//
//    // Create our Finders
//    final titleFinder = find.text('T');
//    final messageFinder = find.text('M');
//
//    // Use the `findsOneWidget` matcher provided by flutter_test to verify our
//    // Text Widgets appear exactly once in the Widget tree
//    expect(titleFinder, findsOneWidget);
//    expect(messageFinder, findsOneWidget);
//  });

  testWidgets('finds a Text Widget', (WidgetTester tester) async {
    // Build an App with a Text Widget that displays the letter 'H'
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Text('Find trails near me'),
      ),
    ));

    // Find a Widget that displays the letter 'H'
    expect(find.text('Find trails near me'), findsOneWidget);
  });

  testWidgets('finds a specific instance', (WidgetTester tester) async {
    final childWidget = Padding(padding: EdgeInsets.zero);

    // Provide our childWidget to the Container
    await tester.pumpWidget(Container(child: childWidget));

    // Search for the childWidget in the tree and verify it exists
    expect(find.byWidget(childWidget), findsOneWidget);
  });
}