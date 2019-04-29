import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

FirebaseUser mCurrentUser;
final FirebaseAuth _auth = FirebaseAuth.instance;
final formkey = GlobalKey<FormState>();
final formkey2 = GlobalKey<FormState>();
final formkey3 = GlobalKey<FormState>();
String _email;
String _password;

String _firstname = '';
String _lastname = '';
String _confirm = "";


Widget emailField() {
  return TextFormField(
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
        labelText: "Email Address", hintText: 'me@example.com'),
    validator: (String value) {
      if (!value.contains('@')) {
        return 'Please enter a valid email';
      }
    },
    onSaved: (String value) {
      _email = value;
      print(_email);
    },
  );
}

Widget passwordField() {
  return TextFormField(
    obscureText: true,
    decoration: InputDecoration(labelText: "Password", hintText: 'Password'),
    validator: (String value) {
      if (value.length < 6) {
        return "Password must be at least 6 characters";
      }
    },
    onSaved: (String value) {
      _password = value;
    },
  );
}

addUserToDatabase(String uid, fname, lname, email) async{
  Firestore.instance
      .collection('users')
      .document(uid)
      .setData({
    'First Name': fname,
    'Last Name': lname,
    'Email': email
  })
.catchError((e) {
    Fluttertoast.showToast(
        msg: "User creation failed: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  });
}
addTrailToDatabase(trailId, trailName, trailLoc, trailUrl, trailLat, trailLon) async{
  var user = await getSignedInUser();
  Firestore.instance
      .collection('users')
      .document(user.uid)
      .collection('trails')
      .document(trailId)
      .setData({
    'Trail ID': trailId,
    'Trail Name': trailName,
    'Trail Location': trailLoc,
    'Image Url': trailUrl,
    'Latitude': trailLat,
    'Longitude': trailLon
  }).then((onValue) {
    Fluttertoast.showToast(
        msg: "trail successfully added",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  })
      .catchError((e) {
    Fluttertoast.showToast(
        msg: "Trail could not be added: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  });
}
loginUser(context) async {
  formkey2.currentState.save();
  if (formkey2.currentState.validate()) {
    await _auth
        .signInWithEmailAndPassword(email: _email, password: _password)
        .catchError((e) {
      Fluttertoast.showToast(
          msg: "Invalid email and/or password. Please try again",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }).then((newUser) {
      var now = new DateTime.now();
      Firestore.instance
          .collection('users')
          .document(newUser.uid)
          .collection('userInfo')
          .document('userInfo')
          .setData({
        'Last login': now,
      }).catchError((e) {
        Fluttertoast.showToast(
            msg: "Update user failed: $e",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      });
      welcomeUser(newUser);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp(1)));
    });
  }
}
welcomeUser(newUser) async{
  DocumentSnapshot result = await Firestore.instance.collection('users')
      .document(newUser.uid).get();
  String myResult = result['First Name'];
  Fluttertoast.showToast(
      msg: "Welcome $myResult!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}
 getSignedInUser() async {
  mCurrentUser = await FirebaseAuth.instance.currentUser();
  if(mCurrentUser == null || mCurrentUser.isAnonymous){
    return null;
  }
  else{
    return mCurrentUser;
  }
}
createUser(context) async {
  formkey3.currentState.save();
  if (formkey3.currentState.validate()) {
    await _auth
        .createUserWithEmailAndPassword(email: _email, password: _password)
        .then((newUser) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp(1)));
      welcomeUser(newUser);
      addUserToDatabase(newUser.uid, _firstname, _lastname, newUser.email);
    }).catchError((e) {
      formkey3.currentState.reset();
      Fluttertoast.showToast(
          msg: "Email address already exists",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
  }
}

signOutUser () async{
  await _auth.signOut();
}

Widget confirmField() {
  return TextFormField(
    obscureText: true,
    decoration: InputDecoration(labelText: "Confirm Password"),
    validator: (String value) {
      if (value.length < 6 ) {
        return "Password must be at least 6 characters";
      }

      if (_password != _confirm){
        return "Passwords do not match.";
      }
    },
    onSaved: (String value) {
      _confirm = value;
    },
  );
}

Widget firstNameField() {
  return TextFormField(
    decoration: InputDecoration(
        labelText: "First Name"),
    validator: (String value) {
      if (value.isEmpty) {
        return 'Input cannot be blank';
      }
    },
    onSaved: (String value) {
      _firstname = value;
    },
  );
}
Widget lastNameField() {
  return TextFormField(
    decoration: InputDecoration(
        labelText: "Last Name"),
    validator: (String value) {
      if (value.isEmpty) {
        return 'Input cannot be blank';
      }
    },
    onSaved: (String value) {
      _lastname = value;
    },
  );
}

Widget profile(context) {
  return RaisedButton(
    color: Color.fromRGBO(58, 66, 86, 1.0),
    child: Text("Profile", style: TextStyle(color: Colors.white)),
    onPressed: () async{
      var user = await getSignedInUser();
      DocumentReference doc = Firestore.instance.collection("users").document(user.uid);
      QuerySnapshot querySnapshot = await Firestore.instance.collection("users").document(user.uid).collection("trails").getDocuments();
      var list = querySnapshot.documents;
      List<Widget> _widgets = list.map((doc) =>
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 2, child: Image.network(doc.data["Image Url"].toString() , fit: BoxFit.cover)),
                  Expanded(flex: 1, child: Text(""),),
                  Expanded(flex: 3, child: Text(
                    "${doc.data["Trail Name"].toString()}  \n"
                        "${doc.data["Trail Location"].toString()}",
                    style: TextStyle(color: Colors.black,),
                  ),),
                  IconButton(
                  //color: Color.fromRGBO(58, 66, 86, 1.0),
                  //child: Text("Route Trail", style: TextStyle(color: Colors.white)),
                    icon: Icon(Icons.directions),
                  onPressed: () async {
                      _launchURL(doc.data["Latitude"], doc.data["Longitude"]);
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogInScreen()));
      }

      )
                  ,

                ],
              ),
            ],)
      ).toList();
      var firstName = "doesn't exist";
      var lastName = "doesn't exist";
      var email = "doesn't exist";
      await doc.get().then((onValue){
        if(onValue.exists){
          firstName = onValue.data['First Name'];
          lastName = onValue.data['Last Name'];
          email = onValue.data['Email'];
        }
      });
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(firstName, lastName, email, _widgets, list),
          )
      );
    },
  );
}

Widget logoutButton(context){
  return RaisedButton(
      color: Color.fromRGBO(58, 66, 86, 1.0),
      child: Text("Log Out", style: TextStyle(color: Colors.white)),
      onPressed: () async {
        signOutUser();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogInScreen()));
      }
  );
}

_launchURL(latitude, longitude) async {
  String url = 'google.navigation:q=$latitude,$longitude';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}