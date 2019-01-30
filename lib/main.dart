// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// See https://developers.google.com/identity/sign-in/android/start-integrating
// for configuring GoogleSignIn OAuth client.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'types/Shift.dart';
import 'widgets/shift_list.dart';
import 'widgets/user_profile_page.dart';

// TODO: finish layout of shifts list
// TODO: add firebase analytics
// TODO: fix permissions on shifts collection

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static Firestore _firestore = Firestore();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driving Log',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppHomePage(
        title: 'Driving Log',
        googleSignIn: _googleSignIn,
        auth: _auth,
        firestore: _firestore,
      ),
    );
  }
}

class AppHomePage extends StatefulWidget {
  AppHomePage({Key key, this.title, this.auth, this.googleSignIn, this.firestore})
      : super(key: key);

  final String title;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;
  final Firestore firestore;

  @override
  _AppHomePageState createState() => _AppHomePageState(auth, googleSignIn, firestore);
}

class _AppHomePageState extends State<AppHomePage> {
  _AppHomePageState(this._auth, this._googleSignIn, this._firestore);

  final Firestore _firestore;
  final GoogleSignIn _googleSignIn;
  GoogleSignInAccount _googleUser;
  final FirebaseAuth _auth;
  FirebaseUser _firebaseUser;
  String _message = '';
  List<Shift> _shifts = [];


  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  void signInWithGoogle() async {
    _handleSignIn()
//        .then((FirebaseUser user) => print("Firebase user: " + user.toString()))
        .catchError((e) => print(e));
  }

  Future<FirebaseUser> _handleSignIn() async {
    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      setState(() {
        _googleUser = googleUser;
      });
    } catch (Exception, e) {
      setState(() {
        _message = "Error signing in with Google.\n"+e.toString();
      });
      print(_message);
    }
    if (_googleUser == null) {
      throw Exception("Error authenticating with Google.");
    }
    GoogleSignInAuthentication googleAuth = await _googleUser.authentication;
    print("Google user: "+_googleUser.toString());
    try {
      FirebaseUser user = await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      setState(() {
        _firebaseUser = user;
      });
    } catch (Exception, e) {
      setState(() {
        _message = _message + "Error authenticating to firebase with Google User: "+
            _googleUser.displayName.toString()+" \n"
            +e.toString();
      });
//      print("Google sign in error: "+e.toString());
      print(_message);
    }
    _getData();
    print("signed in firebase user " + _firebaseUser.toString());
    return _firebaseUser;
  }

  void signOut() {

    setState(() {
      _googleUser = null;
      _firebaseUser = null;
      _message = "";
      _shifts = [];
    });
  }

  Future<void> _getData() async {
    await _firestore.settings(timestampsInSnapshotsEnabled:true);
    QuerySnapshot query = await Firestore.instance.collection('shifts')
        .orderBy('startTime', descending: true)
        .getDocuments();
    List<Shift> shifts = [];

    query.documents.forEach((DocumentSnapshot doc){
      shifts.add(Shift.fromDocumentSnapshot(doc));
    });

    setState(() {
//      _message = ('"shifts" collection: '+result);

        // TODO: Add collection onUpdate listener
        _shifts = shifts;
    });
    print('"shifts" collection: '+shifts.toString());
  }

  void _itemSelected(choice){
    print("Item selected: "+ choice.toString());
    if (choice=='sign_out') signOut();
    if (choice=='user_profile') {
      Navigator.of(context).push(MaterialPageRoute<UserProfilePage>(
        settings: const RouteSettings(name: UserProfilePage.routeName),
        builder: (BuildContext context) {
          return UserProfilePage(_firebaseUser, _googleUser, signOut);
        }));
    }
  }

  @override
  Widget build(BuildContext context) {
//    print("FirebaseUser: "+_firebaseUser.toString());
    if (_firebaseUser == null || _firebaseUser.isAnonymous) {
      return Scaffold(
        appBar: AppBar(
          title:(Text("Welcome to Driving Log")),
        ),
        body:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: RaisedButton(
                  child: const Text('Sign In With Google'),
                  onPressed: signInWithGoogle,
                ),
              ),
              Text(_message,
                  style: const TextStyle(color: Color.fromARGB(255, 0, 155, 0))
              ),
            ],
          ),
        ),
      );
    } else
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon:Icon(Icons.update),
            onPressed: _getData,
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.person),
            onSelected:_itemSelected,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: "user_profile",
                  child: Text("User Profile"),
                ),
                PopupMenuItem<String>(
                  value:'sign_out',
//                  height: 100,
                  child: Text("Sign Out"),
//                  child: Row(
//                    children: <Widget>[
//                      ClipRRect(
//                        child: Image.network(_firebaseUser.photoUrl),
////                        radius: 40,
//                        borderRadius: BorderRadius.all(Radius.circular(50)),
//                      ),
//                      RaisedButton(child: Text("Sign Out")),
//                    ],
//                  ),
              )];
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          print("FloatingActionButton pressed.");
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
//          Padding(
//            padding: EdgeInsets.all(7),
//            child: Image.network(_firebaseUser.photoUrl),
//          ),
//          Text("Hello "+_firebaseUser.displayName),
//          RaisedButton(
//            child: const Text('Sign Out'),
//            onPressed: signOut,
//          ),
//          RaisedButton(
//            child: const Text('Test Get Data'),
//            onPressed: _getData,
//          ),
          ShiftList(shifts: _shifts),
//          Text(_message,
//              style: const TextStyle(color: Color.fromARGB(255, 0, 155, 0))
//          ),
        ],
      ),
    );
  }
}