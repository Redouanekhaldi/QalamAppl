import 'package:books/screens/book.dart';
import 'package:books/services/app_localization.dart';
import 'package:books/services/const.dart';
import 'package:books/services/requests.dart';
import 'package:books/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BookCard extends StatelessWidget {
  final int option;
 // final int id;
final String id;
  const BookCard({Key key, this.option, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder<List>(
        future: Request().getbooks(option, id),
        builder:
            (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                //scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: Row(children: [
                    Container(
                     // margin: EdgeInsets.all(2),
                        width: size.width * 0.3,
                        height: size.height * 0.13,
                        // color: Colors.amber[100],
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                            image: DecorationImage(
                                image: NetworkImage(
                                                          server +
                                                              "/media/books/" +
                                                              snapshot.data[index]
                                                                  ["image"]),
                                fit: BoxFit.fill))),
                    Flexible(
                        child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                          SizedBox(height: 10),
                          Text(snapshot.data[index]['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.035)),
                          Row(
                            children: [
                              FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.list),
                              label: Text(Services().convert(int.parse(
                                  snapshot.data[index]['chapter'])))),
                              FlatButton.icon(
                onPressed: null,
                icon: Icon(Icons.favorite),
                label: Text(//widget.book['rate']+' '+
                 snapshot.data[index]['rate']==null?''
                   : Services().convert(int.parse(
                                  snapshot.data[index]['rate'])))),
            FlatButton.icon(
                onPressed: null,
                icon: Icon(Icons.remove_red_eye_outlined),
                label: Text(
                Services().convert(int.parse(
                                  snapshot.data[index]['read_time']))
                    ))
                            ]
                          ),
                          
                          Text(snapshot.data[index]['description'],
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis),
                          Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.end,
                              children: [
                                Padding(
                                    padding:
                                        const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Book(
                                                        book: snapshot
                                                                .data[
                                                            index])));
                                      },
                                      child: Text(
                                          AppLocalizations.of(context)
                                              .translate('read_more'),
                                          style: TextStyle(
                                              color: Colors.blue)),
                                    ))
                                // Icon(Icons.arrow_forward_ios)
                              ])
                        ]))
                  ]));
                });
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
            return Center(
              child: Column(
              //  mainAxisAlignment: MainAxisAlignment.center,
             //   crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.05,
                  ),
                  Icon(Icons.menu_book_outlined,
                  size: MediaQuery.of(context).size.width*0.3,
                  color: Theme.of(context).primaryColor,),
                  Text(AppLocalizations.of(context).translate('no_books'))
                ]
              )
            );
          }
        });
  }
}