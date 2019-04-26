import 'package:flutter/material.dart';
class ProfileScreen extends StatefulWidget {
  final firstName;
  final lastName;
  final email;
  final _widgets;
  final list;
  ProfileScreen(this.firstName, this.lastName, this.email, this._widgets, this.list);
  State<StatefulWidget> createState() {
    return ProfileScreenState(firstName, lastName, email, _widgets, list);
  }
}
class ProfileScreenState extends State <ProfileScreen> {
  var firstName;
  var lastName;
  var email;
  var _widgets;
  var list;
  ProfileScreenState(this.firstName, this.lastName, this.email, this._widgets, this.list);
  Widget build(BuildContext context) {
    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          "First Name: $firstName",
          style: TextStyle(color: Colors.white, ),
        ),
        Text(
          "Last Name: $lastName",
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.white,),
        ),
        Text(
          "Email: $email",
          style: TextStyle(color: Colors.white, ),
        ),
      ]
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.30,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Favorite Trails\n",
              style: TextStyle(fontSize: 20.0, decoration: TextDecoration.underline),
            ),
          )
        ]
    );

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            topContent,
            bottomContentText,
            Expanded(
            child: ListView.builder(
              itemCount: _widgets.length,
              itemBuilder: (context, int index) {
                if(_widgets.length > index) {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 25.0),
                    leading: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      padding: EdgeInsets.all(5.0),
                      margin: EdgeInsets.all(20.0),
                      child: _widgets[index]
                    ),
                  );
                }
              },
//            ))]),
            ))]),
      )
    );
  }
}
