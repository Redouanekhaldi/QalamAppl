import 'package:books/screens/category.dart';
import 'package:books/services/app_localization.dart';
import 'package:books/services/const.dart';
import 'package:books/services/requests.dart';
import 'package:books/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Search extends StatefulWidget {
  Search({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
 // Widget _screen ;
  String _sr='a';
  @override
  Widget build(BuildContext context) {
    final double itemHeight = MediaQuery.of(context).size.height * 0.1;
    final double itemWidth = MediaQuery.of(context).size.width / 2;
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _search(context),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppLocalizations.of(context).translate('brows'))
          ),
           _sr.length>2?_find(_sr):
          Expanded(
              child: FutureBuilder<List>(
                  future: Request().getcategories(),
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.hasData) {
                      return GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (itemWidth / itemHeight),
                          children:
                              List.generate(snapshot.data.length, (index) {
                            return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Category(
                                            id: int.parse(snapshot.data[index]['id_category']),
                                            category: snapshot.data[index]['category'],
                                          )));
                                },
                                child: Container(
                                    //height: 100,
                                    //MediaQuery.of(context).size.height* 0.2,
                                    child: Card(
                                        //color: Colors.blue,
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(snapshot.data[index]
                                                      ['category']),
                                                  Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.07,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.15,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                          server +
                                                              "/media/books/" +
                                                              snapshot.data[index]
                                                                  ["image"]),
                                                              fit:
                                                                  BoxFit.fill)))
                                                ])))));
                          }));
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SpinKitRotatingPlain(
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                              decoration: BoxDecoration(
                                  color: index.isEven
                                      ? Theme.of(context).primaryColor
                                      : Colors.white));
                        },
                      );
                    } else {
                      return Container();
                    }
                  }))
        ]);
  }

_find(String sr){
  return Expanded(child: BookCard(option: 7, id: sr));
}
  _search(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(50), boxShadow: [
          BoxShadow(
              color: Colors.grey[300],
              offset: new Offset(20.0, 10.0),
              blurRadius: 30.0)
        ]),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.white),
            child: TextField(
                onChanged: (value){
                 setState(() {
                    _sr=value;
                  });
                },
                style: Theme.of(context).textTheme.bodyText2,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
                    suffixIcon: Icon(Icons.search,
                        color: Theme.of(context).primaryColor),
                    border: InputBorder.none,
                    hintText:
                        AppLocalizations.of(context).translate('search_by')))));
  }
}
