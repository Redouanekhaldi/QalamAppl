import 'package:books/services/app_localization.dart';
import 'package:books/services/requests.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Chapter extends StatefulWidget {
  final int id;
  final bool comp;
  final bool edit;
  final Map chapter;

  const Chapter({Key key, this.id, this.comp, this.edit, this.chapter})
      : super(key: key);
  @override
  _ChapterState createState() => _ChapterState();
}

class _ChapterState extends State<Chapter> {
  final _formKey = GlobalKey<FormState>();
  String title, des;
  void initState() {
    super.initState();
    if(widget.edit){
title=widget.chapter['title'];
des=widget.chapter['content'];

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                      initialValue: widget.edit ? widget.chapter['title'] : '',
                      onChanged: (value) {
                        title = value;
                      },
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.grey),
                          labelText: widget.comp
                              ? AppLocalizations.of(context).translate('title')
                              : AppLocalizations.of(context)
                                  .translate('chapter_title'),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorLight))),
                      validator: (String value) {
                        return (value.length < 1)
                            ? AppLocalizations.of(context).translate('error')
                            : null;
                      }),
                  TextFormField(
                      initialValue:
                          widget.edit ? widget.chapter['content'] : '',
                      onChanged: (value) {
                        des = value;
                      },
                      maxLines: null,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText:
                            AppLocalizations.of(context).translate('error'),
                      ),
                      validator: (String value) {
                        return (value.length < 1)
                            ? AppLocalizations.of(context).translate('error')
                            : null;
                      }),
                  Spacer(),
                  Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /* RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: (){

                  },
                  child:Text(AppLocalizations.of(context).translate('add_chapter'),style: TextStyle(color: Colors.white))
                  ),*/
                        RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                if (widget.comp) {
                                   SharedPreferences pref =
                                        await SharedPreferences.getInstance();

                                    int id = pref.getInt('id');
                                   Request().addCompeete(
                                        id, title, widget.id, des);
                                } else {
                                  if (widget.edit) {
                                   await Request().updateChapter(
                                        widget.id, title, des);
                                  } else {
                                   
                                    Request().addChapter(
                                      widget.id, title, 1, des, 1);
                                   
                                  }
                                }
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyHomePage(ind: 0)));
                              }
                            },
                            child: Text(
                                widget.comp
                                    ? AppLocalizations.of(context)
                                        .translate('send')
                                    : AppLocalizations.of(context)
                                        .translate('save'),
                                style: TextStyle(color: Colors.white))),
                        /*  widget.comp?Container():
               RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        if(widget.comp){
                        Request().addChapter(widget.id, title, 1, content, 1);
                        }else{
                          if(widget.edit){
Request().updateChapter(widget.id, title, content);
                          }else{
                                SharedPreferences pref = await SharedPreferences.getInstance();

                            int id= pref.getInt('id');
Request().addCompeete(id, title, widget.id, content);
                          }
                        }
                         Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => MyHomePage(ind: 0)));
                      }
                    },
                    child: Text(
                        AppLocalizations.of(context).translate('save_publish'),
                        style: TextStyle(color: Colors.white)))*/
                      ]),
                  SizedBox(height: 30)
                ]))));
  }
}
