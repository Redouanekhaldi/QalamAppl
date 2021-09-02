import 'package:books/screens/login.dart';
import 'package:books/services/app_localization.dart';
import 'package:flutter/material.dart';

class Dialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
        title: Center(
            child: Text(AppLocalizations.of(context).translate('login_dia'),
                maxLines: 2)),
        actions: <Widget>[
          FlatButton(
              child: Text(AppLocalizations.of(context).translate('login')),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          FlatButton(
              child: Text(AppLocalizations.of(context).translate('cancel')),
              onPressed: () {
                 Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login()));
              })
        ]
      
    );
  }
}

class Wrong extends StatelessWidget {
  final bool login;

  const Wrong({Key key, this.login}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
        title: Center(
            child: Text(login?AppLocalizations.of(context).translate('cant_signup')
              :AppLocalizations.of(context).translate('cant_signup'),
                maxLines: 2,
                style: TextStyle(
                  fontWeight: FontWeight.normal
                )
                )),
        actions: <Widget>[
         login?Container(): FlatButton(
              child: Text(AppLocalizations.of(context).translate('login')),
              onPressed: () {
                 Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login()));
              }),
          FlatButton(
              child: Text(AppLocalizations.of(context).translate('ok')),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          
        ]
      
    );
  }
}