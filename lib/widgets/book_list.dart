import 'package:books/screens/book.dart';
import 'package:books/services/const.dart';
import 'package:books/services/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookList extends StatefulWidget {
  BookList({Key key, this.title, this.option, this.id}) : super(key: key);

  final String title;
  //final List books;
  final int option;
  final int id;

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  int _id = 0;
  // int _selected = 0;
  SharedPreferences pref;

  void initState() {
    super.initState();
    _id = widget.id;
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
    return FutureBuilder<List>(
        future: Request().getbooks(widget.option, _id.toString()),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.title,

                          style: GoogleFonts.harmattan(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width*0.07
                          )
                         /* TextStyle(fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width*0.05
                          )*/
                          )),
                  Container(
                      height: size.height * 0.22,
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Book(
                                              book: snapshot.data[index])));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    Card(
                                      elevation: 1.5,
                                        child: Container(
                                            width: size.width * 0.2,
                                            height: size.height * 0.11,
                                            // color: Colors.amber[100],
                                            decoration: BoxDecoration(
                                                color: Colors.green[50],
                                                image: DecorationImage(
                                                    image: NetworkImage(server +
                                                        "/media/books/" +
                                                        snapshot.data[index]
                                                            ["image"]),
                                                    fit: BoxFit.fill)))),
                                    Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Chip(
                                            backgroundColor:
                                                Theme.of(context).accentColor,
                                            label: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                child: Center(
                                                  child: Text(
                                                      snapshot.data[index]['name'],
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis),
                                                ))))
                                  ]),
                                ));
                          }))
                ]);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitWave(
                itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                  decoration: BoxDecoration(
                      color: index.isEven
                          ? Theme.of(context).primaryColor
                          : Colors.white));
            });
          } else {
            return Container();
          }
        });
  }
}
