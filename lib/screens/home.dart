import 'package:books/services/app_localization.dart';
import 'package:flutter/material.dart';

import 'library.dart';
import 'navigate.dart';
import 'search.dart';
import 'write.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.ind}) : super(key: key);
  final int ind;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex=widget.ind;
  }


  @override
  Widget build(BuildContext context) {
    String title=AppLocalizations.of(context).translate('home');
    //String home=AppLocalizations.of(context).translate('home');
    List titles =[AppLocalizations.of(context).translate('home'),
    AppLocalizations.of(context).translate('search'),
    AppLocalizations.of(context).translate('library'),
    AppLocalizations.of(context).translate('story')];
    return Scaffold(
      appBar: AppBar(
        title: //FlatButton.icon(onPressed: null, icon: Icon(Icons.lo), label: Text(title),)
        Text(title)
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'الرئيسية'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'بحث'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'مكتبتي'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_outlined),
            label: 'كتابة قصة'
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).primaryColorLight,
      iconSize: MediaQuery.of(context).size.width * 0.07,
       onTap: (int index){
         setState(() {
           _selectedIndex = index;
           title=titles[index];
         });
       }
      ),
      body: _screen()
    );
  }

  Widget _screen() {
    switch (_selectedIndex) {
      case 1:
        return Search();
        break;
      case 2:
        return Library();
        break;
      case 3:
        return Write();
        break;
      default:
        return Navigate();
    }
  }
}
