import 'package:books/screens/user.dart';
import 'package:books/services/app_localization.dart';
import 'package:books/services/const.dart';
import 'package:books/services/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Read extends StatefulWidget {
  final int id;
  final int number;
  final String title;

  const Read({Key key, this.id, this.number, this.title}) : super(key: key);
  @override
  _ReadState createState() => _ReadState();
}

class _ReadState extends State<Read> {
  int _counter = 0;
  int _number, _id = -1;
  bool _liked = false;
  SharedPreferences pref;
  ScrollController _hideButtonController;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  var _isVisible;
  @override
  initState() {
    super.initState();
    _number = widget.number;
    // _isVisible = true;
    _isVisible = false;
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
    SharedPreferences.getInstance().then((value) {
      setState(() {
        pref = value;
        if (pref.containsKey('id')) {
          _id = pref.getInt('id');
          Request().isLiked(_id, widget.id).then((value) {
            List res = value;
            if (res == null)
              _liked = false;
            else
              _liked = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: Request().getchapters(widget.id, _number),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text(widget.title)
                ),
                bottomNavigationBar: Visibility(
                    visible: !_isVisible,
                    child: BottomNavigationBar(
                        //currentIndex: -1,
                        type: BottomNavigationBarType.fixed,
                        selectedItemColor: Colors.black54,
                        onTap: (int index) async {
                          switch (index) {
                            case 0:
                              setState(() {
                                _number = _number + 1;
                              });
                              break;
                            case 1:
                              _showComments(
                                  int.parse(snapshot.data[0]['id_chapter']));
                              break;
                            case 2:
                              if (_liked) {
                                Request().like(_id, widget.id, 0);
                                setState(() {
                                  _liked = false;
                                });
                              } else {
                                Request().like(_id, widget.id, 1);
                                setState(() {
                                  _liked = true;
                                });
                              }
                              break;
                            default:
                              if (_number > 1) {
                                setState(() {
                                  _number = _number - 1;
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)
                                        .translate('no_previous'),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                          }
                        },
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                              icon: Icon(Icons.skip_next), label: 'التالي'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.comment_outlined),
                              label: 'تعليق'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.favorite,
                                  color: _liked == true
                                      ? Colors.red
                                      : Colors.black54),
                              label: 'اعجبني'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.skip_previous), label: 'السابق')
                        ])),
                body: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(15),
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.black87,
                        border: Border.all(
                            color: Theme.of(context).primaryColorLight,
                            width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(18.0))),
                    child: CustomScrollView(
                        controller: _hideButtonController,
                        shrinkWrap: true,
                        slivers: <Widget>[
                          new SliverPadding(
                              padding: EdgeInsets.all(20.0),
                              sliver: new SliverList(
                                  delegate:
                                      new SliverChildListDelegate(<Widget>[
                                Text(snapshot.data[0]['content'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.0016,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.06))
                              ])))
                        ])));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitCubeGrid(
                itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                  decoration: BoxDecoration(
                      color: index.isEven
                          ? Theme.of(context).primaryColor
                          : Colors.green[200]));
            });
          } else {
            return Scaffold(
                appBar: AppBar(),
                body: Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Icon(Icons.library_books_outlined,
                          color: Colors.grey[300]
                          //Theme.of(context).primaryColor
                          ,
                          size: MediaQuery.of(context).size.width * 0.3),
                      Text(AppLocalizations.of(context).translate('no_chapter'),
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05)),
                      Divider(),
                      FlatButton.icon(
                          onPressed: () {
                            setState(() {
                              _number = _number - 1;
                            });
                          },
                          icon: Icon(
                            Icons.skip_previous,
                            color: Theme.of(context).primaryColor,
                          ),
                          label: Text('السابق'))
                    ])));
          }
        });
  }

  void _showComments(int id) {
    String comment;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // set this to true
        builder: (_) {
          return DraggableScrollableSheet(
              expand: false,
              minChildSize: 0.2,
              maxChildSize: 0.6,
              initialChildSize: 0.4,
              builder: (_, controller) {
                return Column(children: [
                  FutureBuilder<List>(
                      future: Request().getcomments(id),
                      builder:
                          (BuildContext context, AsyncSnapshot<List> snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                              child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  //    controller: controller,
                                  itemBuilder: (_, i) {
                                    return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) => User(
                                                                    id: int.parse(
                                                                        snapshot.data[i]
                                                                            [
                                                                            'users_id']),
                                                                  )));
                                                },
                                                child: Row(children: [
                                                  CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(server +
                                                              "/media/users/" +
                                                              snapshot.data[i]
                                                                  ["image"])),
                                                  SizedBox(width: 10),
                                                  Text(
                                                      snapshot.data[i]['user']),
                                                  Spacer(),
                                                  /*   Text(
                                                  AppLocalizations.of(context)
                                                      .translate('report'),
                                                  style: TextStyle(
                                                      color: Colors.grey)
                                                )*/
                                                ]),
                                              ),
                                              Text(snapshot.data[i]['comment']),
                                              Divider()
                                            ]));
                                  }));
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1),
                                Icon(
                                  Icons.menu_book_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: MediaQuery.of(context).size.width * 0.3,
                                ),
                                Text(AppLocalizations.of(context)
                                    .translate('no_comment'))
                              ]));
                        }
                      }),
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(children: [
                        Expanded(
                            child: TextField(
                                onChanged: (value) {
                                  comment = value;
                                },
                                decoration: InputDecoration(
                                    labelStyle: TextStyle(color: Colors.grey),
                                    hintText: AppLocalizations.of(context)
                                        .translate('comment'),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColorLight))))),
                        InkWell(
                            onTap: () async {
                              if (_id != -1) {
                                if (comment.replaceAll(' ', '').length > 1) {
                                  await Request()
                                      .addComment(comment, _id, widget.id);
                                  setState(() {
                                    print('comment added');
                                    _showComments(widget.id);
                                  });
                                }
                              } else {
                                showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Dialog();
                                    });
                              }
                            },
                            child: Icon(
                              Icons.send,
                              color: Theme.of(context).primaryColor,
                            ))
                      ])),
                  SizedBox(height: 20)
                ]);
              });
        });
  }
}
