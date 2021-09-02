import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:books/screens/chapter.dart';
import 'package:books/services/app_localization.dart';
import 'package:books/services/const.dart';
import 'package:books/services/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class Write extends StatefulWidget {
  Write({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WriteState createState() => _WriteState();
}

class _WriteState extends State<Write> {
  final _formKey = GlobalKey<FormState>();
  Future<File> file;
  String statu = '',name,desc,
      base64Image,
      fileName ; // store image as default
  File tmpFile;
 
  String dropdownValue;
  Map map = Map();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  showImage(size),
                  Divider(),
                  Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(children: [
                          TextFormField(
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.grey),
                                  labelText: AppLocalizations.of(context)
                                      .translate('title'),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .primaryColorLight))),
                              onChanged: (value) {
                                name = value;
                              },
                              validator: (String value) {
                                return (value.length < 1)
                                    ? AppLocalizations.of(context).translate(
                                        'error') //'ce numéro est incorrect'
                                    : null;
                              }),
                          SizedBox(height: 30),
                          Row(children: [
                            Text(AppLocalizations.of(context)
                                    .translate('category') +
                                " :"),
                            SizedBox(width: 30),
                            FutureBuilder<List>(
                                future: Request().getcategories(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List> snapshot) {
                                  if (snapshot.hasData) {
                                    List<String> list = List();
                                    snapshot.data.forEach((element) {
                                      list.add(element['category']);
                                      map[element['category']] =
                                          element['id_category'];
                                    });
                                    // String dropdownValue = list[0];
                                    return DropdownButton<String>(
                                      value: dropdownValue == null
                                          ? list[0]
                                          : dropdownValue,
                                      iconSize: 24,
                                      elevation: 16,
                                      underline: Container(
                                          height: 2,
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                      onChanged: (newValue) {
                                        setState(() {
                                          dropdownValue = newValue;
                                        });
                                      },
                                      items: list.map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    );
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SpinKitRotatingPlain(itemBuilder:
                                        (BuildContext context, int index) {
                                      return DecoratedBox(
                                          decoration: BoxDecoration(
                                              color: index.isEven
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.white));
                                    });
                                  } else {
                                    return Container();
                                  }
                                })
                          ]),
                          SizedBox(height: 30),
                          TextFormField(
                              maxLines: null,
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.grey),
                                  labelText: AppLocalizations.of(context)
                                      .translate('description'),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .primaryColorLight))),
                              onChanged: (value) {
                                desc = value;
                              },
                              validator: (String value) {
                                return (value.length < 1)
                                    ? AppLocalizations.of(context).translate(
                                        'error') //'ce numéro est incorrect'
                                    : null;
                              })
                        ]),
                      ),
                    ],
                  ),
                  //Spacer(),
                  SizedBox(height: 30),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    RaisedButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {

                            int cat = int.parse(map[dropdownValue]);
                            startUpload();
                            var l = await Request()
                                .addBook(name, cat, desc,fileName);
                              Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Chapter(
            comp: false,
            edit:false,
            id: l,
          )));
                          }
                        },
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('start_writing'),
                            style: TextStyle(color: Colors.white)))
                  ])
                ])));
  }
static final String uploadEndPoint =
      server+'/media/books/upload_image.php';
  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
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
      print(result.statusCode.toString());
      // setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      print(error.toString());
      //setStatus(error);
     // Error(AppLocalizations.of(context).translate('error_image'));
    });
  }
  
   Widget showImage(var size) {
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
                                  padding: EdgeInsets.all(1),
                                  height: size.height * 0.2,
                                  width: size.width * 0.3,
                                  
                                  child: Image.file(
                        snapshot.data, // should be store image as default
                        fit: BoxFit.cover),
                                 )
            );
 
          } else {
            return Container(
                height: size.height * 0.2,
                child: InkWell(
                    child: Icon(Icons.photo_camera,
                        size: 100, color: Colors.grey.withOpacity(0.7)),
                    focusColor: Colors.grey,
                    onTap: chooseImage));
          }
        });
  }
}

