import 'package:books/screens/profile.dart';
import 'package:books/services/app_localization.dart';
import 'package:books/services/const.dart';
import 'package:books/widgets/book_list.dart';
import 'package:books/widgets/competition.dart';
import 'package:books/widgets/see_more.dart';
import 'package:books/widgets/winners.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navigate extends StatefulWidget {
  Navigate({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NavigateState createState() => _NavigateState();
}

class _NavigateState extends State<Navigate> {

  SharedPreferences pref;
  String _user='@';
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        pref = value;
        if (pref.containsKey('user')) _user = _user+pref.getString('user');
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

  
    return
        // Column
        ListView(children: [
      Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(5),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(AppLocalizations.of(context).translate('hello') + _user,
                style:  GoogleFonts.harmattan(
                            fontWeight: FontWeight.bold,
                            fontSize:size.width*0.07
                          )
                //TextStyle(fontWeight: FontWeight.bold, fontSize: size.width * 0.05)
                    ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
              child: CircleAvatar(
             
                  backgroundColor: Theme.of(context).primaryColor,
                  child: _user.length==1?Container():
                  Text(_user.substring(1,3), style: TextStyle(color: Colors.white))
                  )
            )
          ])),
      Divider(),
      Competition(),
      Winners(),
      Card(
          child: BookList(
              title: AppLocalizations.of(context).translate('new'),
              option: 3,
              id: 0)),
      BookList(
          title: AppLocalizations.of(context).translate('trending'),
          option: 5,
          id: 0),
      Card(
          child: BookList(
              title: AppLocalizations.of(context).translate('follow'),
              option: 6,
              id: 0)),
      Card(
          child:
              SeeMore(title: AppLocalizations.of(context).translate('explore')))
    ]);
  }
}
