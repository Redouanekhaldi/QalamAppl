import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'const.dart';
import 'package:http/http.dart' as http;

class Request {

  Future<List> getbooks(int opt , String id) async {
    var url = server + '/books.php?case='+opt.toString()+'&id='+id;
    http.Response response = await http.get(url);
    List books = jsonDecode(response.body);
    return books;
  }
  Future<List> getcompetition(int id) async {
    var url = server + '/competition.php?id='+id.toString();
    http.Response response = await http.get(url);
    List comp = jsonDecode(response.body);
    return comp;
  }
  Future<int> updatebio(int id,String bio,int cas) async {
    var url = server + '/bio.php?id='+id.toString()+'&bio='+bio+'&case='+cas.toString();
    http.Response response = await http.get(url);
    var comp = jsonDecode(response.body);
    return comp;
  }
  Future<List> getwinners() async {
    var url = server + '/winners.php';
    http.Response response = await http.get(url);
    List w = jsonDecode(response.body);
    return w;
  }

  Future<List> getcategories() async {
    var url = server + '/categories.php';
    http.Response response = await http.get(url);
    List cat = jsonDecode(response.body);
    return cat;
  }

  Future<List> getcompetitions() async {
    var url = server + '/competitions.php';
    http.Response response = await http.get(url);
    List comp = jsonDecode(response.body);
    return comp;
  }
  Future<List> getcomments(int id) async {
    var url = server + '/comments.php?id='+id.toString();
    http.Response response = await http.get(url);
    List com = jsonDecode(response.body);
    return com;
  }
  Future<List> getuser(int id) async {
    var url = server + '/user.php?id='+id.toString();
    http.Response response = await http.get(url);
    List user = jsonDecode(response.body);
    return user;
  }
  Future<List> getmycomp(int id) async {
    var url = server + '/mycompetitions.php?id='+id.toString();
    http.Response response = await http.get(url);
    List user = jsonDecode(response.body);
    return user;
  }
  Future<List> getfollowing(int id) async {
    var url = server + '/following.php?id='+id.toString();
    http.Response response = await http.get(url);
    List user = jsonDecode(response.body);
    return user;
  }
  Future<List> follow(int id,int me) async {
    var url = server + '/follow.php?id='+id.toString()+'&me='+me.toString();
    http.Response response = await http.get(url);
    List user = jsonDecode(response.body);
    return user;
  }
  Future<int> unfollow(int id,int me) async {
    var url = server + '/unfollo.php?id='+id.toString()+'&me='+me.toString();
    http.Response response = await http.get(url);
    var user = jsonDecode(response.body);
    return user;
  }

  Future<List> isLiked(int user,int chapter) async {
    var url = server + '/liked.php?user='+user.toString()+'&chapter='+chapter.toString();
    http.Response response = await http.get(url);
    List res = jsonDecode(response.body);
    return res;
  }

  Future<List> getchapters(int id,int number) async {
    var url = server + '/chapters.php?id='+id.toString()+'&number='+number.toString();
    http.Response response = await http.get(url);
    List ch = jsonDecode(response.body);
    return ch;
  }

  Future<List> search(int opt , String name) async {
    var url = server + '/search.php?case='+opt.toString()+'&name='+name;
    http.Response response = await http.get(url);
    List res = jsonDecode(response.body);
    return res;
  }

  Future<int> addBook(String name ,int cat ,String desc,String image ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int id= pref.getInt("id");
   
    var url = server + '/book.php?users_id='+id.toString()+'&name='+name+'&categories_id='+cat.toString()+'&image='+image+'&description='+desc;
    http.Response response = await http.get(url);
    var book= jsonDecode(response.body);
    return book;
  }

  Future<void> addChapter(int id , String title ,int nb ,String content ,int state) async {
    var url = server + '/chapter.php?number='+nb.toString()+'&content='+content+'&books_id='+id.toString()+'&title='+title+'&publish='+state.toString();
    http.Response response = await http.get(url);
    var book= jsonDecode(response.body);
   // return book;
  }
  Future<void> updateChapter(int id , String title  ,String content ) async {
    var url = server + '/update_chapter.php?content='+content+'&books_id='+id.toString()+'&title='+title;
    http.Response response = await http.get(url);
  //  var book= jsonDecode(response.body);
    //return book;
  }

  Future<void> updatebook(int id , int cas  ,String content ) async {
    var url = server + '/update_book.php?content='+content+'&books_id='+id.toString()+'&case='+cas.toString();
    http.Response response = await http.get(url);
    //var book= jsonDecode(response.body);
    //return book;
  }

  Future<void> addCompeete(int id , String title ,int comp ,String content) async {
    var url = server + '/compeete.php?users_id='+id.toString()+'&content='+content+'&competitions_id='+comp.toString()+'&title='+title;
    http.Response response = await http.get(url);
   // List c= jsonDecode(response.body);
   // return c;
  }

  Future<List> addUser( String name ) async {
    var url = server + '/newuser.php?name='+name;
    http.Response response = await http.get(url);
    List u= jsonDecode(response.body);
    return u;
  }
  Future<List> login( String user,String password ) async {
    var url = server + '/login.php?user='+user+'&pass='+password;
    http.Response response = await http.get(url);
    List u= jsonDecode(response.body);
    return u;
  }
  Future<int> signup( String user,String password ,String email) async {
    var url = server + '/signup.php?user='+user+'&pass='+password+'&email='+email;
   http.Response response = await http.get(url);
    var u= jsonDecode(response.body);
    return u;
  }
  Future<String> like(int user,int chapter ,int cas ) async {
    var url = server + '/likes.php?user='+user.toString()+'&chapter='+chapter.toString()+'&case='+cas.toString();
    http.Response response = await http.get(url);
    var u= response.body;
    return u;
  }
  Future<int> addComment( String content ,int user ,int chapter ) async {
    var url = server + '/comment.php?comment='+content+'&user='+user.toString()+'&chapter='+chapter.toString();
    http.Response response = await http.get(url);
    var c= jsonDecode(response.body);
    return c;
  }

  Future<int> addreading( int book ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int id= pref.getInt("id");
    var url = server + '/read.php?book='+book.toString()+'&chapter=1&user='+id.toString();
    http.Response response = await http.get(url);
    var u= jsonDecode(response.body);
    return u;
  }
  

}