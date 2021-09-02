import 'package:books/screens/home.dart';
import 'package:books/screens/signup.dart';
import 'package:books/services/app_localization.dart';
import 'package:books/services/requests.dart';
import 'package:books/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  AnimationController animationController;
  String _email, _password;
  // var authHandler = new Auth();
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  Animatable<Color> background = TweenSequence<Color>([
    TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(begin: Colors.blueAccent, end: Colors.greenAccent)),
    TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(begin: Colors.greenAccent, end: Colors.pinkAccent)),
    TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(begin: Colors.pinkAccent, end: Colors.orangeAccent)),
    TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(begin: Colors.orangeAccent, end: Colors.blueAccent)),
  ]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            constraints: BoxConstraints.expand(),
            color: background
                .evaluate(AlwaysStoppedAnimation(animationController.value)),
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2),
                        Text(AppLocalizations.of(context).translate('login'),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.07)),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),
                        Form(
                            key: _formKey,
                            child: Column(children: [
                              TextFormField(
                                  decoration: InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      labelText: AppLocalizations.of(context)
                                          .translate('user_name'),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColorLight))),
                                  onChanged: (value) {
                                    _email = value;
                                  },
                                  validator: (String value) {
                                    return (value.length < 1)
                                        ? AppLocalizations.of(context)
                                            .translate('wrong')
                                        : null;
                                  }),
                              TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Colors.white),
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
                                    return (value.length < 1)
                                        ? AppLocalizations.of(context)
                                            .translate('wrong')
                                        : null;
                                  }),
                              SizedBox(height: 40),
                              TextButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(
                                          Colors.white),
                                      padding: MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.all(13)),
                                      foregroundColor: MaterialStateProperty.all<Color>(
                                          background.evaluate(AlwaysStoppedAnimation(
                                              animationController.value))),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(29.0),
                                          side: BorderSide(color: Colors.red)))),
                                  child: Text(AppLocalizations.of(context).translate('login')),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      List l = await Request()
                                          .login(_email, _password);
                                      if (l != null) {
                                        SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();
                                        pref.setInt(
                                            "id", int.parse(l[0]["id_user"]));
                                        pref.setString('user', _email);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyHomePage(ind: 0)));
                                      } else {
showDialog<void>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Wrong(
                                          login: true
                                        );
                                      });

                                      }
                                    }
                                  }),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Signup()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .translate('signup_now'),
                                        style: TextStyle(color: Colors.white,
                                        decoration: TextDecoration.underline
                                        ))
                                  ))
                            ]))
                      ])
                ]))));
  }
}
