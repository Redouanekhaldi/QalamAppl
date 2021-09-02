import 'package:books/screens/read.dart';
import 'package:books/screens/user.dart';
import 'package:books/services/app_localization.dart';
import 'package:books/services/const.dart';
import 'package:books/services/requests.dart';
import 'package:books/services/services.dart';
import 'package:books/widgets/book_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Book extends StatefulWidget {
  final Map book;

  const Book({Key key, this.book}) : super(key: key);
  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  IconData _icon = Icons.add;
  int _number = 1;
  bool _reading = false;
  SharedPreferences pref;
  int _id = -1;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        pref = value;
        if (pref.containsKey('id')) {
          _id = pref.getInt('id');
          Request().getbooks(4, _id.toString()).then((value) {
            List b = value;
            if (b != null) {
              b.forEach((element) {
                if (element['id_book'] == widget.book['id_book']) {
                  setState(() {
                    _number = int.parse(element['chapter_num']);
                    _icon = Icons.check;
                    _reading = true;
                  });
                }
              });
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.book['name'])),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Stack(alignment: Alignment.topCenter, children: <Widget>[
                Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: BoxDecoration(
                        color: Colors.green[50],
                        image: DecorationImage(
                            image: NetworkImage(server +
                                "/media/books/" +
                                widget.book["image"]),
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.55),
                                BlendMode.luminosity),
                            fit: BoxFit.cover))),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.1,
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.2,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.green[100],
                            image: DecorationImage(
                                image: NetworkImage(server +
                                    "/media/books/" +
                                    widget.book["image"]),
                                fit: BoxFit.fill),
                            // color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[300],
                                  offset: new Offset(10.0, 10.0),
                                  blurRadius: 30.0)
                            ])))
              ])),
          SizedBox(height: 10),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(widget.book['name'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)))),
          FutureBuilder<List>(
              future: Request().getuser(int.parse(widget.book['users_id'])),
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => User(
                                      id: int.parse(widget.book['users_id']),
                                    )));
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                                backgroundImage: NetworkImage(server +
                                    "/media/books/" +
                                    snapshot.data[0]["image"])),
                            SizedBox(width: 10),
                            Text(snapshot.data[0]['user'])
                          ]));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return SpinKitWave(
                      itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                        decoration: BoxDecoration(
                            color: index.isEven
                                ? Theme.of(context).primaryColor
                                : Colors.white));
                  });
                } else {
                  return Scaffold(appBar: AppBar());
                }
              }),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColorLight,
                          width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(18.0))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FlatButton.icon(
                            onPressed: null,
                            icon: Icon(Icons.list,
                                color: Theme.of(context).primaryColor),
                            label: Text(Services()
                                .convert(int.parse(widget.book['chapter'])))),
                        FlatButton.icon(
                            onPressed: null,
                            icon: Icon(Icons.favorite,
                                color: Theme.of(context).primaryColor),
                            label: Text(//widget.book['rate']+' '+
                                widget.book['rate'] == null
                                    ? ''
                                    : Services().convert(
                                            int.parse(widget.book['rate'])) +
                                        ' ' +
                                        AppLocalizations.of(context)
                                            .translate('votes'))),
                        FlatButton.icon(
                            onPressed: null,
                            icon: Icon(Icons.remove_red_eye_outlined,
                                color: Theme.of(context).primaryColor),
                            label: Text(Services().convert(
                                    int.parse(widget.book['read_time'])) +
                                ' ' +
                                AppLocalizations.of(context)
                                    .translate('reads'))),
                      ]))),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            InkWell(
                onTap: _id == -1
                    ? () {
                        showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Dialog();
                            });
                      }
                    : _reading
                        ? () {}
                        : () async {
                            await Request()
                                .addreading(int.parse(widget.book['id_book']));
                            setState(() {
                              _icon = Icons.check;
                            });
                          },
                child: CircleAvatar(
                    backgroundColor: Theme.of(context).accentColor,
                    child: Icon(_icon))),
            SizedBox(width: 10),
            RaisedButton(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Read(
                                id: int.parse(widget.book['id_book']),
                                number: _number,
                                title:widget.book['name'] ,
                              )));
                },
                child: Text(
                    '        ' +
                        AppLocalizations.of(context).translate('start') +
                        '        ',
                    style: TextStyle(color: Colors.white)))
          ]),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('     ' + widget.book['description'],
                  style: TextStyle(fontSize: 16, letterSpacing: 1.5))),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Divider(),
          BookList(
              title: AppLocalizations.of(context).translate('may_like'),
              option: 3,
              id: int.parse(widget.book['categories_id']))
        ])));
  }
}
