import 'package:books/screens/home.dart';
import 'package:books/services/app_localization.dart';
import 'package:books/services/requests.dart';
import 'package:books/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _password2, _name;
  //var authHandler = new Auth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Theme.of(context).primaryColor, Colors.green[200]],
                    begin: const FractionalOffset(0.0, 1.0),
                    end: const FractionalOffset(1.0, 0.0))),
            /*  decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images.jpeg"),
                    fit: BoxFit.fill)),*/
            child: ListView(children: [
              Form(
                  key: _formKey,
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2),
                        Text(
                            AppLocalizations.of(context)
                                .translate('new_account'),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06)),
                        SizedBox(height: 20),
                        TextFormField(
                            decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.white),
                                labelText: AppLocalizations.of(context)
                                    .translate('email'),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .primaryColorLight))),
                            onChanged: (value) {
                              _email = value;
                            },
                            validator: (String value) {
                              Pattern pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = new RegExp(pattern);
                              return (!regex.hasMatch(value))
                                  ? AppLocalizations.of(context)
                                      .translate('wrong')
                                  : null;
                            }),
                        TextFormField(
                            decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.white),
                                labelText: AppLocalizations.of(context)
                                    .translate('user_name'),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .primaryColorLight))),
                            onChanged: (value) {
                              _name = value;
                            },
                            validator: (String value) {
                              return (value.length < 4)
                                  ? AppLocalizations.of(context)
                                      .translate('wrong')
                                  : null;
                            }),
                        TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.white),
                                labelText: AppLocalizations.of(context)
                                    .translate('password'),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .primaryColorLight))),
                            onChanged: (value) {
                              _password = value;
                            },
                            validator: (String value) {
                              return (value.length < 4)
                                  ? AppLocalizations.of(context)
                                      .translate('wrong')
                                  : null;
                            }),
                        TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.white),
                                labelText: AppLocalizations.of(context)
                                    .translate('confirm_password'),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .primaryColorLight))),
                            onChanged: (value) {
                              _password2 = value;
                            },
                            validator: (String value) {
                              return (_password != _password2)
                                  ? AppLocalizations.of(context)
                                      .translate('wrong')
                                  : null;
                            }),
                        SizedBox(height: 40),
                        TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.fromLTRB(25, 15, 25, 15)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(29.0),
                                        side: BorderSide(color: Colors.red)))),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                var l = await Request()
                                    .signup(_name, _password, _email);
                                if (l == null) {
                                  showDialog<void>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Wrong(
                                          login: false
                                        );
                                      });
                                } else {
                                  print(l.toString());
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  pref.setInt("id", l);
                                  pref.setString('user', _name);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyHomePage(ind: 0)));
                                }
                              }
                            },
                            child: Text(AppLocalizations.of(context).translate('signup')))
                      ])))
            ])));
  }
}
