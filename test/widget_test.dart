import 'package:flutter/material.dart';
import 'package:hike_locator/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hike_locator/screens/signup_screen.dart';

void main() {
  Widget makeTestableWidgetBlank(Widget child){
    return MaterialApp(
      home: Scaffold(
        body: child

      ),
    );
  }
  testWidgets('4 fields blank', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidgetBlank(SignUpScreen()));
    final Finder first_name = find.widgetWithText(TextFormField, 'First Name');
    final Finder last_name = find.widgetWithText(TextFormField, 'Last Name');
    final Finder password = find.widgetWithText(TextFormField, 'Password');
    final Finder confirm = find.widgetWithText(TextFormField, 'Confirm Password');
    await tester.enterText(first_name, '');
    await tester.enterText(last_name, '');
    await tester.enterText(password, '');
    await tester.enterText(confirm, '');
    await tester.tap(find.widgetWithText(OutlineButton, 'Register'));
    await tester.pump();

    expect(find.text('Input cannot be blank'), findsWidgets);
  });
  testWidgets('Email blank', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidgetBlank(SignUpScreen()));
    final Finder email = find.widgetWithText(TextFormField, 'Email Address');
    await tester.enterText(email, '');
    await tester.tap(find.widgetWithText(OutlineButton, 'Register'));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
  });
  testWidgets('Invalid email', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidgetBlank(SignUpScreen()));
    final Finder email = find.widgetWithText(TextFormField, 'Email Address');
    await tester.enterText(email, 'hello');
    await tester.tap(find.widgetWithText(OutlineButton, 'Register'));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
  });
  testWidgets('Short password', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidgetBlank(SignUpScreen()));
    final Finder password = find.widgetWithText(TextFormField, 'Password');
    final Finder confirm = find.widgetWithText(TextFormField, 'Confirm Password');
    await tester.enterText(password, '123');
    await tester.enterText(confirm, '123');
    await tester.tap(find.widgetWithText(OutlineButton, 'Register'));
    await tester.pump();

    expect(find.text('Password must be at least 6 characters'), findsWidgets);
  });

  testWidgets('Passwords do not match', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidgetBlank(SignUpScreen()));
    final Finder password = find.widgetWithText(TextFormField, 'Password');
    final Finder confirm = find.widgetWithText(TextFormField, 'Confirm Password');
    await tester.enterText(password, 'hello321');
    await tester.enterText(confirm, 'hello123');
    await tester.tap(find.widgetWithText(OutlineButton, 'Register'));
    await tester.pump();

    expect(find.text('Passwords do not match.'), findsWidgets);
  });
}
