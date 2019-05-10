import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../authentication.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LogInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LogInScreenState();
  }
}

class LogInScreenState extends State<LogInScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
            height: 250.0,
            width: 300.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/HikeLocatorLogo.png'),
                  fit: BoxFit.cover),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Center(
                  child: Form(
                key: formkey2,
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      emailField(),
                      SizedBox(
                        width: 20.0,
                        height: 20.0,
                      ),
                      passwordField(),
                      new Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: OutlineButton(
                                          child: Text("Login"),
                                          onPressed: () => loginUser(context)),
                                      flex: 2,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(""),
                                    ),
                                    Expanded(
                                      child: OutlineButton(
                                        child: Text("Sign Up"),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignUpScreen()),
                                          );
                                        },
                                      ),
                                      flex: 2,
                                    ),
                                    SizedBox(
                                      height: 18.0,
                                      width: 18.0,
                                    ),
                                    SizedBox(
                                      height: 18.0,
                                      width: 18.0,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.0),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: OutlineButton(
                                        child: Text("Continue as Guest"),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => HomeScreen(0),
                                              ));
                                        },
                                      ),
                                      flex: 2,
                                    ),
                                    SizedBox(
                                      height: 18.0,
                                      width: 18.0,
                                    ),
                                    SizedBox(
                                      height: 18.0,
                                      width: 18.0,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(width: 5.0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
