
import 'package:books/widgets/book_card.dart';
import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  final int id;
  final String category;

  const Category({Key key, this.id, this.category}) : super(key: key);
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  //int _id=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: //FlatButton.icon(onPressed: null, icon: Icon(Icons.lo), label: Text(title),)
                Text(widget.category)),
        body: Container(
          child: BookCard(
            option: 1,
            id: widget.id.toString()
          )
        ));
  }
}
