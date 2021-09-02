import 'package:books/screens/edit.dart';
import 'package:books/screens/read.dart';
import 'package:books/services/app_localization.dart';
import 'package:books/services/const.dart';
import 'package:books/services/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Library extends StatefulWidget {
  Library({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  int _selected = 0, _id = -1;
  SharedPreferences pref;
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        pref = value;
        if (pref.containsKey('id')) _id = pref.getInt('id');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        InkWell(
          onTap: () {
            setState(() {
              _selected = 0;
            });
          },
          child: Container(
              margin: EdgeInsets.all(15),
              // padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: _selected == 0
                              //index==selected
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).primaryColorLight,
                          width: 3.0))),
              child: Text(AppLocalizations.of(context).translate('reading'))),
        ),
        InkWell(
            onTap: () {
              setState(() {
                _selected = 1;
              });
            },
            child: Container(
                margin: EdgeInsets.all(15),
                // padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: _selected == 1
                                //index==selected
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).primaryColorLight,
                            width: 3.0))),
                child: Text(AppLocalizations.of(context).translate('books'))))
      ]),
      _selected == 0
          ?
          // _reading(size, context):
          _myBooks(size, context, 4)
          : _myBooks(size, context, 2)
    ]);
  }

  Widget _myBooks(var size, BuildContext context, int option) {
    return FutureBuilder<List>(
        future: Request().getbooks(option, _id.toString()),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        childAspectRatio: 0.5,
                        children: List.generate(snapshot.data.length, (index) {
                          return InkWell(
                              onTap: () {
                                //  if(option==2){
                                if (option == 2) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Read(
                                              id: int.parse(snapshot.data[index]
                                                  ['id_book']),
                                              number: int.parse(
                                                  snapshot.data[index]
                                                      ['chapter_num']))));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Edit(
                                              book: snapshot.data[index])));
                                }
                              },
                              child: Column(children: [
                                Card(
                                    child: Container(
                                        width: size.width * 0.25,
                                        height: size.height * 0.15,
                                        // color: Colors.amber[100],
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(server +
                                                    "/media/books/" +
                                                    snapshot.data[index]
                                                        ["image"]),
                                                fit: BoxFit.fill)))),
                                Padding(
                                  padding: const EdgeInsets.only(right: 9),
                                  child: Text(snapshot.data[index]["name"],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                )
                              ]));
                        }))));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitRotatingPlain(
                itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                  decoration: BoxDecoration(
                      color: index.isEven
                          ? Theme.of(context).primaryColor
                          : Colors.white));
            });
          } else {
            return Container(
                margin: EdgeInsets.all(15),
                height: size.height * 0.15,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                      color: Colors.grey[200],
                      //Theme.of(context).primaryColorLight,
                      width: 2.0),
                  top: BorderSide(
                      color: Colors.grey[200],
                      //color: Theme.of(context).primaryColorLight,
                      width: 2.0),
                  left: BorderSide(
                      // color: Theme.of(context).primaryColorLight,
                      color: Colors.grey[200],
                      width: 2.0),
                  right: BorderSide(
                      // color: Theme.of(context).primaryColorLight,
                      color: Colors.grey[200],
                      width: 2.0),
                )),
                child: FlatButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.menu_book,
                        size: size.width * 0.15,
                        color: Theme.of(context).primaryColor),
                    label: option == 2
                        ? Text(AppLocalizations.of(context)
                            .translate('note_books'))
                        : Text(AppLocalizations.of(context)
                            .translate('note_stories'))));
          }
        });
  }
}
