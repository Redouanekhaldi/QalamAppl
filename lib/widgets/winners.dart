import 'package:books/screens/user.dart';
import 'package:books/services/app_localization.dart';
import 'package:books/services/const.dart';
import 'package:books/services/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class Winners extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder<List>(
        future: Request().getwinners(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      //  child:Text("current"),
                      child: Text(
                          AppLocalizations.of(context).translate('winners'),
                          style:  GoogleFonts.harmattan(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width*0.07
                          )
                         // TextStyle(fontWeight: FontWeight.bold)
                          )),
                  Container(
                     height: size.height * 0.25,
                      child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: snapshot.data.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: (){
                                
                                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                     User(id:int.parse(snapshot.data[index]
                                    ['users_id']))));
                                },
                                    child: Card(
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                        width: size.width *0.3,
                                        child: Column(
                                            // crossAxisAlignment: CrossAxisAlignment.,
                                            mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                                            children: [
                      Padding(
                            padding:
                                const EdgeInsets.all(8.0),
                            child: Text(
                                snapshot.data[index]
                                    ['title'],
                                style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold))), 
                      CircleAvatar(
                        radius: 40.0,
                        backgroundImage:
                            NetworkImage(
                                    server +
                                        "/media/users/" +
                                        snapshot.data[index]
                                            ["image"]),
                      ),
                                            //  SizedBox(width: 5),
                                            Text(snapshot.data[index]
                                    ['user'])
                                      
                                            ]))),
                              );
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