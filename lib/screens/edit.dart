import 'dart:convert';
import 'dart:io';

import 'package:books/screens/chapter.dart';
import 'package:books/services/app_localization.dart';
import 'package:books/services/const.dart';
import 'package:books/services/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Edit extends StatefulWidget {
  final Map book;

  const Edit({Key key, this.book}) : super(key: key);
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  bool _des = false,_tit=false;
  String _description,_title;
  Future<File> file;
  String statu = '',
      base64Image,
      fileName ; // store image as default
  File tmpFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
              showImage(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width:MediaQuery.of(context).size.width*0.2),
                  InkWell(
                    onTap: (){
                       setState(() {
                      _tit = !_tit;
                    });
                    },
                    child: Icon(Icons.edit,size: 15)),
                  SizedBox(width:5),
                 // Text(widget.book["name"])
                 Expanded(
                                    child: TextFormField(
                      enabled: _tit,
                      maxLines: null,
                      initialValue: widget.book["name"],
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorLight))),
                      onChanged: (value) {
                          _title = value;
                      },
                      validator: (String value) {
                        return (value.length < 1)
                            ? AppLocalizations.of(context)
                                .translate('error') //'ce numéro est incorrect'
                            : null;
                      }),
                 ),
                  SizedBox(width:10),
                  _tit?IconButton(icon: Icon(Icons.check_circle), 
                  onPressed: () async {
                    if(_title.length>1){
                      
                      await Request().updatebook(int.parse(widget.book["id_book"]), 1, _title);
                      setState(() {
                        _tit=!_tit;
                      });
                      
                    }

                  }):Container()

                ]
              ),
              FlatButton.icon(
                  onPressed: () {
                    setState(() {
                      _des = !_des;
                    });
                  },
                  icon: Icon(Icons.edit),
                  label: Text(
                      AppLocalizations.of(context).translate('description'))),
              Card(
                  child: Column(children: [
                TextFormField(
                    enabled: _des,
                    maxLines: null,
                    initialValue: widget.book["description"],
                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColorLight))),
                    onChanged: (value) {
                        _description = value;
                    },
                    validator: (String value) {
                      return (value.length < 1)
                          ? AppLocalizations.of(context)
                              .translate('error') //'ce numéro est incorrect'
                          : null;
                    }),
                _des
                    ? RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                        onPressed: () {
                          if(_description.length>1){
                    
                      Request().updatebook(int.parse(widget.book["id_book"]), 0, _description);
                      setState(() {
                        _des = !_des;
                      });
                      
                    }
                        },
                        child: Text(
                            AppLocalizations.of(context).translate('save')))
                    : Container()
              ])),
              FlatButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Chapter(
                                comp: false,
                                edit: false,
                                id: int.parse(widget.book["id_book"]))));
                  },
                  icon: Icon(Icons.add_circle),
                  label: Text(
                      AppLocalizations.of(context).translate('add_chapter'))),
              FutureBuilder<List>(
                  future: Request()
                      .getchapters(int.parse(widget.book["id_book"]), 0),
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.hasData) {
                      // print('==== ' + snapshot.data.toString());
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: double.infinity,
                          child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: snapshot.data.length,
                              // scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Chapter(
                                                comp: false,
                                                edit: true,
                                                id: int.parse(
                                                    widget.book["id_book"]),
                                                chapter:
                                                    snapshot.data[index])));
                                  },
                                  child: Card(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(children: [
                                            Icon(Icons.edit),
                                            SizedBox(width: 10),
                                            Text(snapshot.data[index]['title'])
                                          ])))
                                );
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
                      });
                    } else {
                      return Center(
                          child: Column(
                              //  mainAxisAlignment: MainAxisAlignment.center,
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05),
                            Icon(
                              Icons.format_list_bulleted_outlined,
                              size: MediaQuery.of(context).size.width * 0.3,
                              color: Theme.of(context).primaryColor
                            ),
                            Text(AppLocalizations.of(context)
                                .translate('no_books'))
                          ]));
                    }
                  })
            ])));
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
                          child: Container(
                                 margin: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.2,
                                  
                                  child: Image.file(
                        snapshot.data, // should be store image as default
                        fit: BoxFit.cover)
                                 )
            );
 
          } else {
            return Center(
                  child: InkWell(
                    onTap:chooseImage,
                                      child: Container(
                        margin: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.2,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.green[100],
                            image: DecorationImage(
                                image: NetworkImage(server +
                                    "/media/books/" +
                                    widget.book["image"]),
                                fit: BoxFit.fill),
                            // color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[300],
                                  offset: new Offset(10.0, 10.0),
                                  blurRadius: 30.0)
                            ])),
                  ));
          }
        });
  }
  
  static final String uploadEndPoint =
      server+'/media/books/upload_image.php';
  chooseImage() async {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
      startUpload();
    });
    await Request().updatebook(int.parse(widget.book["id_book"]), 2, fileName);

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
}
