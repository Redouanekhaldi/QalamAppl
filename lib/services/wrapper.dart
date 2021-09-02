/*
import 'package:books/screens/home.dart';
import 'package:books/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Wrapper  {

  handleAuth() {
    return FutureBuilder(
        future: Firebase.initializeApp(),
    builder: (context, snap) {
    // Check for errors
    if (snap.hasError) {
    return Container();
    }else{
      return  StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return MyHomePage(ind: 0) ;
            } else {
              return Login();
            }
          });
    }});
  }
}*/