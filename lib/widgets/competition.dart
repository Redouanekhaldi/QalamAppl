import 'package:books/screens/participate.dart';
import 'package:books/services/app_localization.dart';
import 'package:books/services/const.dart';
import 'package:books/services/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class Competition extends StatefulWidget {
  @override
  _CompetitionState createState() => _CompetitionState();
}

class _CompetitionState extends State<Competition> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder<List>(
        future: Request().getcompetitions(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      //  child:Text("current"),
                      child: Text(
                          AppLocalizations.of(context).translate('current'),
                          style:  GoogleFonts.harmattan(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width*0.07
                          )
                         // TextStyle(fontWeight: FontWeight.bold)
                          )),
                  Container(
                      height: size.height * 0.2,
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                    width: size.width - 50,
                                    child: Row(
                                        // crossAxisAlignment: CrossAxisAlignment.,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          CircleAvatar(
                                            radius: 60.0,
                                            backgroundImage:
                                               NetworkImage(
                                                          server +
                                                              "/media/books/" +
                                                              snapshot.data[index]
                                                                  ["image"]),
                                          ),
                                          SizedBox(width: 5),
                                          Flexible(
                                              child: Column(children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    snapshot.data[index]
                                                        ['title'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            Text(
                                                snapshot.data[index]
                                                    ['description'],
                                                maxLines: 3,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            Spacer(),
                                            RaisedButton(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                onPressed: () {

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Participate(
                                                                id: int.parse(snapshot.data[index]['id_competition']),
                                                              )));
                                                },
                                                child: Text('Participate',
                                                    style: TextStyle(
                                                        color: Colors.white)))
                                          ]))
                                        ])));
                          }))
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
