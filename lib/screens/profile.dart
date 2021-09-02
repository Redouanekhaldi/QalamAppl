import 'dart:convert';
import 'dart:io';

import 'package:books/services/app_localization.dart';
import 'package:books/services/const.dart';
import 'package:books/services/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:books/screens/login.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _id = -1;
  Widget _screen;
  Future<File> file;
  String statu = '', base64Image, fileName; // store image as default
  File tmpFile;
  // String _user='.';
  List _user;

  SharedPreferences pref;

  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        pref = value;
        if (pref.containsKey('id')) {
          _id = pref.getInt('id');
          Request().getuser(_id).then((res) {
            setState(() {
              _user = res;
            });
          });
        }
        //  if (pref.containsKey('user')) _user = pref.getString('user');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context).translate('profile'))),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              padding: EdgeInsets.all(10),
              color: Colors.black87,
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    showImage(),
               /* CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: _user == null
                      ? NetworkImage(server + "/media/users/logo.jpeg")
                      : NetworkImage(
                          server + "/media/users/" + _user[0]["image"]),
                  // child: Text('US', style: TextStyle(color: Colors.white))
                ),*/
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _user == null
                        ? Container()
                        : Text(_user[0]['user'],
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06,
                                color: Colors.white))),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        Text(AppLocalizations.of(context).translate('reading'),
                            style: TextStyle(color: Colors.white)),
                        _user == null
                            ? Container()
                            : Text(_user[0]['books'],
                                style: TextStyle(color: Colors.white))
                      ]),
                      Column(children: [
                        Text(
                            AppLocalizations.of(context).translate('followers'),
                            style: TextStyle(color: Colors.white)),
                        _user == null
                            ? Container()
                            : Text(_user[0]['nb'],
                                style: TextStyle(color: Colors.white))
                      ])
                    ])
              ])),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: _screen != null
                  ? _screen
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Card(
                              elevation: 1,
                              child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(5),
                                  child: Row(children: [
                                    Icon(Icons.import_contacts,
                                        color: Theme.of(context).primaryColor),
                                    SizedBox(width: 10),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            _screen = _bio();
                                          });
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)
                                                .translate('profile'),
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05)))
                                  ]))),
                          Card(
                              elevation: 1,
                              child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(5),
                                  child: Row(children: [
                                    Icon(Icons.people_rounded,
                                        color: Theme.of(context).primaryColor),
                                    SizedBox(width: 10),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            _screen = _following();
                                          });
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)
                                                .translate('following'),
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05)))
                                  ]))),
                          SizedBox(height: 1),
                          Card(
                              elevation: 1,
                              child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(5),
                                  child: Row(children: [
                                    Icon(Icons.star,
                                        color: Theme.of(context).primaryColor),
                                    SizedBox(width: 10),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            _screen = _competition();
                                          });
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)
                                                .translate('competitions'),
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05)))
                                  ]))),
                          SizedBox(height: 1),
                        /*  Card(
                              elevation: 1,
                              child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(5),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _screen = _terms();
                                        });
                                      },
                                      child: Row(children: [
                                        Icon(Icons.book,
                                            color:
                                                Theme.of(context).primaryColor),
                                        SizedBox(width: 10),
                                        Text(
                                            AppLocalizations.of(context)
                                                .translate('terms'),
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05))
                                      ])))),
                         */
                          SizedBox(height: 1),
                          Card(
                              elevation: 1,
                              child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(5),
                                  child: Row(children: [
                                    Icon(Icons.exit_to_app,
                                        color: Theme.of(context).primaryColor),
                                    SizedBox(width: 10),
                                    InkWell(
                                        onTap: () {
                                          pref.clear();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Login()));
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)
                                                .translate('logout'),
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05)))
                                  ])))
                        ]))
        ])));
  }

  Widget _competition() {
    return Expanded(
        child: FutureBuilder<List>(
            future: Request().getmycomp(_id),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            _screen = null;
                          });
                        },
                        child: Row(children: [
                          Icon(Icons.arrow_forward_ios_rounded),
                          Text(AppLocalizations.of(context).translate('back'))
                        ])),
                    ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                              child: Container(
                                  margin: EdgeInsets.all(5),
                                  width: double.infinity,
                                  child: Row(
                                      // crossAxisAlignment: CrossAxisAlignment.,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        CircleAvatar(
                                            radius: 60.0,
                                            backgroundImage: NetworkImage(
                                                server +
                                                    "/media/users/" +
                                                    snapshot.data[index]
                                                        ["image"])),
                                        SizedBox(width: 5),
                                        Flexible(
                                            child: Column(children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  snapshot.data[index]['comp'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          Text(snapshot.data[index]['content'],
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis)
                                        ]))
                                      ])));
                        }),
                  ],
                );
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
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              _screen = null;
                            });
                          },
                          child: Row(children: [
                            Icon(Icons.arrow_forward_ios_rounded),
                            Text(AppLocalizations.of(context).translate('back'))
                          ])),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2),
                      Center(
                          child: Icon(Icons.star_border,
                              color: Theme.of(context).primaryColor,
                              size: MediaQuery.of(context).size.width * 0.4)),
                      Center(
                          child: Text(AppLocalizations.of(context)
                              .translate('nothing')))
                    ]);
              }
            }));
  }

  Widget _following() {
    return FutureBuilder<List>(
        future: Request().getfollowing(_id),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: Column(
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          _screen = null;
                        });
                      },
                      child: Row(children: [
                        Icon(Icons.star_border),
                        Text(AppLocalizations.of(context).translate('back'))
                      ])),
                  ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            child: Row(children: [
                          CircleAvatar(
                              radius: 30,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text('user',
                                  style: TextStyle(color: Colors.white))),
                          Text(snapshot.data[index]['user']),
                          FlatButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.edit_outlined),
                              label: snapshot.data[index]['books']),
                          snapshot.data[index]['rate'] == null
                              ? Container()
                              : FlatButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.favorite),
                                  label: snapshot.data[index]['rate'])
                        ]));
                      }),
                ],
              ),
            );
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
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          _screen = null;
                        });
                      },
                      child: Row(children: [
                        Icon(Icons.arrow_back_ios),
                        Text(AppLocalizations.of(context).translate('back'))
                      ])),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Center(
                      child: Icon(Icons.person_pin_circle_outlined,
                          color: Theme.of(context).primaryColor,
                          size: MediaQuery.of(context).size.width * 0.4)),
                  Center(
                    child:
                        Text(AppLocalizations.of(context).translate('nothing')),
                  )
                ]);
          }
        });
  }

  Widget showImage() {
    return FutureBuilder<File>(
        future: file,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              null != snapshot.data) {
            tmpFile = snapshot.data;
            base64Image = base64Encode(snapshot.data.readAsBytesSync());
            return InkWell(
                onTap: chooseImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage:FileImage(snapshot.data),
                  // child: Text('US', style: TextStyle(color: Colors.white))
                ));
          } else {
            return InkWell(
                onTap: chooseImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: _user == null
                      ? NetworkImage(server + "/media/users/logo.jpeg")
                      : NetworkImage(
                          server + "/media/users/" + _user[0]["image"]),
                  // child: Text('US', style: TextStyle(color: Colors.white))
                ));
          }
        });
  }

  static final String uploadEndPoint = server + '/media/users/upload_image.php';
  chooseImage() async {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
      startUpload();
    });
    await Request().updatebio(int.parse(_user[0]['id_user']), fileName, 0);
  }

  startUpload() {
    if (null == tmpFile) {
      // Error(AppLocalizations.of(context).translate('error_image'));
      return;
    }
    fileName = tmpFile.path.split('/').last;
    upload();
  }

  upload() {
    http.post(uploadEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((result) {
      // setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      //setStatus(error);
      // Error(AppLocalizations.of(context).translate('error_image'));
    });
  }

  Widget _terms() {}
  Widget _bio() {
    String content;
    return Column(children: [
      InkWell(
          onTap: () {
            setState(() {
              _screen = null;
            });
          },
          child: Row(children: [
            Icon(Icons.arrow_forward_ios_outlined),
            Text(AppLocalizations.of(context).translate('back'))
          ])),
      Divider(),
      TextFormField(
          initialValue: _user[0]['biography'],
          onChanged: (value) {
            content = value;
            // print('=== '+content);
          },
          maxLines: null,
          decoration: InputDecoration(
            labelStyle: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.05),
            labelText: AppLocalizations.of(context).translate('my_profile'),
          ),
          validator: (String value) {
            return (value.length < 1)
                ? AppLocalizations.of(context).translate('error')
                : null;
          }),
      RaisedButton(
          onPressed: () async {
            if (content != null) {
              await Request().updatebio(int.parse(_user[0]['id_user']), content, 1);
            }
            setState(() {
              _screen = null;
            });
          },
          color: Theme.of(context).primaryColor,
          child: Text(AppLocalizations.of(context).translate('save'),
              style: TextStyle(color: Colors.white)))
    ]);
  }
}
