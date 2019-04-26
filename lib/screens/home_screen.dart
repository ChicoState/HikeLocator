import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

import '../authentication.dart';
import '../models/trail_model.dart';
import '../screens/map_screen.dart';

class MyApp extends StatefulWidget {
  final int loggedIn;

  MyApp(this.loggedIn);

  @override
  State<StatefulWidget> createState() {
    return HomeScreen(loggedIn);
  }
}

class HomeScreen extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  double userLat;
  double userLon;
  double distance = 10.0;
  double length = 1.0;
  double results = 10.0;
  int loggedIn;
  bool _isenabled = false;
  bool _canSwitch = true;
  String distFromUser = 'Distance From User: 10';
  String len = 'Minimum Length of Trail: 1';
  String num = 'Number of Results: 10';

  HomeScreen(this.loggedIn);

  List<TrailModel> trails = [];
  List<dynamic> finalTrails = [];

  Future<List<dynamic>> fetchData() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userLat = position.latitude;
    userLon = position.longitude;
    var response = await get(
        'https://www.hikingproject.com/data/get-trails?lat=$userLat&lon=$userLon&maxDistance=$distance&minLength=$length&maxResults=$results&key=200419778-6a46042e219d019001dd83b13d58aa59');
    var trailModel = TrailModel.fromJson(json.decode(response.body));
    trails.clear();
    finalTrails.clear();
    for (int i = 0; i < results; i++) {
      Object myText = json.encode(trailModel.trails);
      finalTrails.add(json.decode(myText));
    }
    return finalTrails;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("HikeLocator"),
          backgroundColor: Colors.green[700],
        ),
        body: Container(
            margin: EdgeInsets.all(20.0),
            child: Form(
              key: formkey,
              child: Column(
                children: <Widget>[
                      Container(
                        height: 200.0,
                        width: 300.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/hike.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                      distanceFromUser(),
                      lengthOfTrail(),
                      numOfResults(),
                      Container(
                        margin: EdgeInsets.only(top: 25.0),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(flex: 2, child: submitButton()),
                          Container(
                            margin: EdgeInsets.all(5.0),
                          ),
                          Expanded(flex: 2, child: filter()),
                        ],
                      )
                    ] +
                    (loggedIn == 0
                        ? []
                        : [
                            Row(
                              children: <Widget>[
                                Expanded(flex: 2, child: profile(context)),
                                Container(
                                  margin: EdgeInsets.all(5.0),
                                ),
                                Expanded(flex: 2, child: logoutButton(context)),
                              ],
                            )
                          ]),
              ),
            )),
      ),
    );
  }

  Widget distanceFromUser() {
    return TextFormField(
      enabled: _isenabled,
      decoration:
          InputDecoration(labelText: distFromUser, hintText: 'x mile(s)'),
      onSaved: (String value) {
        if (value.isEmpty && _isenabled == false) {
          distance = 10.0;
          setState(() {
            _canSwitch = true;
          });
        } else {
          if (value.isEmpty && _isenabled == true) {
            setState(() {
              _canSwitch = false;
            });
          } else {
            distance = double.parse(value);
            setState(() {
              _canSwitch = true;
            });
          }
        }
      },
    );
  }

  Widget lengthOfTrail() {
    return TextFormField(
      enabled: _isenabled,
      decoration: InputDecoration(labelText: len, hintText: 'x mile(s)'),
      onSaved: (String value) {
        if (value.isEmpty && _isenabled == false) {
          length = 10.0;
          setState(() {
            _canSwitch = true;
          });
        } else {
          if (value.isEmpty && _isenabled == true) {
            setState(() {
              _canSwitch = false;
            });
          } else {
            length = double.parse(value);
            setState(() {
              _canSwitch = true;
            });
          }
        }
      },
    );
  }

  Widget numOfResults() {
    return TextFormField(
      enabled: _isenabled,
      decoration: InputDecoration(labelText: num, hintText: 'top x results'),
      onSaved: (String value) {
        if (value.isEmpty && _isenabled == false) {
          results = 10.0;
          setState(() {
            _canSwitch = true;
          });
        } else {
          if (value.isEmpty && _isenabled == true) {
            setState(() {
              _canSwitch = false;
            });
          } else {
            results = double.parse(value);
            setState(() {
              _canSwitch = true;
            });
          }
        }
      },
    );
  }

  Widget submitButton() {
    return RaisedButton(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child:
            Text("Find trails near me", style: TextStyle(color: Colors.white)),
        onPressed: () async {
          formkey.currentState.save();
          if (_canSwitch == true) {
            final trails = await fetchData();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MapScreen(trails, userLat, userLon)),
            );
          } else {
            Fluttertoast.showToast(
                msg: "Please enter a search criteria.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                timeInSecForIos: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        });
  }

  Widget filter() {
    return RaisedButton(
      color: Color.fromRGBO(58, 66, 86, 1.0),
      child:
          Text("Edit Search Criteria", style: TextStyle(color: Colors.white)),
      onPressed: () async {
        if (_isenabled == false) {
          setState(() {
            _isenabled = true;
            distFromUser = 'Enter distance from you to search';
            len = 'Enter length of trail';
            num = 'Enter num of search results';
          });
        } else {
          setState(() {
            _isenabled = false;
            distFromUser = 'Distance From User: 10';
            len = 'Minimum Length of Trail: 1';
            num = 'Number of Results: 10';
          });
        }
      },
    );
  }
}
