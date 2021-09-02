import 'package:books/screens/book.dart';
import 'package:books/services/app_localization.dart';
import 'package:books/services/const.dart';
import 'package:books/services/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class SeeMore extends StatefulWidget {
  SeeMore({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _SeeMoreState createState() => _SeeMoreState();
}

class _SeeMoreState extends State<SeeMore> {
  int _selected = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder<List>(
        future: Request().getbooks(0, '0'),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.title,
                          style:  GoogleFonts.harmattan(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width*0.07
                          )
                          //TextStyle(fontWeight: FontWeight.bold)
                          )),
                  Container(
                      height: size.height * 0.17,
                      //color: Colors.blue,
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selected = index;
                                        });
                                      },
                                      child: Card(
                                          child: Container(
                                              width: _selected == index
                                                  ? size.width * 0.22
                                                  : size.width * 0.2,
                                              height: _selected == index
                                                  ? size.height * 0.14
                                                  : size.height * 0.12,
                                              // color: Colors.amber[100],
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                  image: DecorationImage(
                                  
                                                      image: NetworkImage(
                                                          server +
                                                              "/media/books/" +
                                                              snapshot.data[index]
                                                                  ["image"]),
                                                      fit: BoxFit.fill)))))
                                ]);
                          })),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data[_selected]['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.04)
                            ),
                            Container(
                                height: size.height * 0.03,
                                child: Row(children: [
                                  FlatButton.icon(
                                      onPressed: null,
                                      icon: Icon(Icons.list),
                                      label: Text(AppLocalizations.of(context)
                                              .translate('chapter') +
                                          ' :' +
                                          snapshot.data[_selected]['chapter'])),
                                  Chip(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      label: Text(
                                          snapshot.data[_selected]['category'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis))
                                ])),
                            Container(
                                padding: EdgeInsets.all(10),
                                //color: Colors.deepOrange,
                                width: double.infinity,
                                child: Text(
                                    snapshot.data[_selected]['description'],
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis)),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Book(
                                                        book: snapshot.data[_selected])));
                                    },
                                                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('read_more'),
                                        style: TextStyle(color: Colors.blue)),
                                  )
                                ])
                          ]))
                ]);
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
            return Container();
          }
        });
  }
}
