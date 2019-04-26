import 'package:flutter/material.dart';

import '../authentication.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpScreenState();
  }
}

class SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("HikeLocator"),
        backgroundColor: Colors.green[700],
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Center(
                  child: new Form(
                key: formkey3,
                child: Center(
                  child: new ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      firstNameField(),
                      lastNameField(),
                      emailField(),
                      passwordField(),
                      confirmField(),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 3.5,
                              top: 8.0),
                          child: Row(
                            children: <Widget>[
                              OutlineButton(
                                  child: Text(
                                    "Register",
                                  ),
                                  onPressed: () {
                                    createUser(context);
                                  }),
                              SizedBox(
                                height: 18.0,
                                width: 18.0,
                              ),
                            ],
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
