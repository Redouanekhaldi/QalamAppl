import 'package:books/screens/chapter.dart';
import 'package:books/services/app_localization.dart';
import 'package:books/services/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Participate extends StatefulWidget {
  final int id;

  const Participate({Key key, this.id}) : super(key: key);
  @override
  _ParticipateState createState() => _ParticipateState();
}

class _ParticipateState extends State<Participate> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: Request().getcompetition(widget.id),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                    title: Text(
                        AppLocalizations.of(context).translate('competition'))),
                body: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: Stack(
                                      alignment: Alignment.topCenter,
                                      children: <Widget>[
                                        Container(
                                            width: double.infinity,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.25,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/bk.jpeg"),
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            Colors.black
                                                                .withOpacity(
                                                                    0.55),
                                                            BlendMode
                                                                .luminosity),
                                                    fit: BoxFit.cover))),
                                        Positioned(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/bk.jpeg"),
                                                      fit: BoxFit.fill),
                                                  color: Colors.white
                                                      .withOpacity(0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey[300],
                                                        offset: new Offset(
                                                            10.0, 10.0),
                                                        blurRadius: 30.0)
                                                  ]),
                                              /*  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row()])*/
                                            ))
                                      ])),
                              Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Text(AppLocalizations.of(context)
                                        .translate('closing')+" : "+snapshot.data[0]['end_date']),
                                  )),
                              Divider(),
                              Text(
                                  AppLocalizations.of(context)
                                      .translate('competition'),
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.055)),
                                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '     ' + snapshot.data[0]['description'],
                                  style: TextStyle(                             
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.0014,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.045, letterSpacing: 1.5)
                                )
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('conditions'),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500,
                                        fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.055))
                              ),
                              Divider(),
                              Text('      ' +
                                  snapshot.data[0]['terms'],
                                  style:TextStyle(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.0014,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.045)
                                  
                                  ),
                                  
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Center(
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RaisedButton(
                                          color: Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0)),
                                          onPressed: () {
                                            Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Chapter(
            comp: true,
            edit:false,
            id: int.parse(snapshot.data[0]['id_competition'])
          )));
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate('participate'),
                                            style:
                                                TextStyle(color: Colors.white,
                                                fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.045
                                                )
                                          ))))
                            ]))));
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
            return Scaffold(
                appBar: AppBar(),
                body: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Icon(
                        Icons.menu_book_outlined,
                        color: Theme.of(context).primaryColor
                      ),
                      Text('no book')
                    ])));
          }
        });
  }
}
