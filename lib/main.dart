import 'screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication.dart';
import 'screens/signup_screen.dart';
void main() async{
  Widget _defaultHome = new LogInScreen();
  FirebaseUser user = await getSignedInUser();

  if (user != null) {
    _defaultHome = new HomeScreen(1);
  }
  else{
    _defaultHome = new LogInScreen();
  }
  runApp(
      MaterialApp(
      home: _defaultHome,
        routes: <String, WidgetBuilder>{
          // Set routes for using the Navigator.
          '/login': (BuildContext context) => new LogInScreen(),
          '/signup': (BuildContext context) => new SignUpScreen(),
          //'/home': (BuildContext context) => new MyApp(1)

        },
  ),
  );
}





