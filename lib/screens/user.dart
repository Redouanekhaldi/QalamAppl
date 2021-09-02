import 'package:books/services/app_localization.dart';
import 'package:books/services/const.dart';
import 'package:books/services/requests.dart';
import 'package:books/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User extends StatefulWidget {
  final int id;

  const User({Key key, this.id}) : super(key: key);
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  List _user;
  @override
  void initState() {
    super.initState();
    Request().getuser(widget.id).then((value) {
      setState(() {
        _user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
          floating: true,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Center(
                  child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Column(children: [
                        Container(
                            padding: EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height * 0.39,
                            width: double.infinity,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _user == null
                                      ? Container()
                                      : CircleAvatar(
                                          radius: 50,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          backgroundImage: NetworkImage(server +
                                              "/media/users/" +
                                              _user[0]["image"])),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: _user == null
                                          ? Container()
                                          : Text(_user[0]['user'],
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
                                                  color: Colors.white))),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  RaisedButton(

                                        color: Colors.white,
                                      textColor: Theme.of(context).primaryColor,
                                      padding: EdgeInsets.all(8),
                                      onPressed: _user == null
                                          ? null
                                          : () async {
                                              int id = int.parse(
                                                  _user[0]["id_user"]);
                                              SharedPreferences pref =
                                                  await SharedPreferences
                                                      .getInstance();
                                              int me = pref.getInt('id_user');
                                              if (_user[0]['following'] ==
                                                  'yes') {
                                                await Request()
                                                    .unfollow(id, me);
                                                setState(() {
                                                  _user[0]['following'] = 'no';
                                                });
                                              } else {
                                                await Request().follow(id, me);
                                                setState(() {
                                                  _user[0]['following'] = 'yes';
                                                });
                                              }
                                            },
                                      child: _user == null ||
                                              _user[0]['following'] == 'yes'
                                          ? Text(AppLocalizations.of(context)
                                              .translate('follow'))
                                          : Text(AppLocalizations.of(context)
                                              .translate('unfollow'))),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      // crossAxisAlignment: CrossAxisAlignment.,
                                      children: [
                                        Column(children: [
                                          Text(
                                              AppLocalizations.of(context)
                                                  .translate('works'),
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          _user == null
                                              ? Container()
                                              : Text(_user[0]['books'],
                                                  style: TextStyle(
                                                      color: Colors.white))
                                        ]),
                                        Column(children: [
                                          Text(
                                              AppLocalizations.of(context)
                                                  .translate('followers'),
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          _user == null
                                              ? Container()
                                              : Text(_user[0]['nb'],
                                                  style: TextStyle(
                                                      color: Colors.white))
                                        ])
                                      ])
                                ]))
                      ])))),
          expandedHeight: MediaQuery.of(context).size.height * 0.35),
      SliverList(
          delegate: SliverChildListDelegate([
        Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(AppLocalizations.of(context).translate('my_profile'),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.04)),
        )),
        Card(
            margin: EdgeInsets.all(10),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _user == null
                    ? Container()
                    : Text(_user[0]['biography'],
                        style: TextStyle(
                            height:
                                MediaQuery.of(context).size.height * 0.00155,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.038)))),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppLocalizations.of(context).translate('book'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.04))),
        Container(
            width: double.infinity,
            height: 600,
            //  color: Colors.black,
            child: BookCard(option: 2, id: widget.id.toString()))
      ]))
    ]));
  }
}
