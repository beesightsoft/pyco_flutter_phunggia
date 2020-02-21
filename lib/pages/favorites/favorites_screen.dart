import 'dart:convert';

import 'package:bflutter/bflutter.dart';
import 'package:bflutter_poc/models/remote/person.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 248, 249, 253),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Favorites",
          style: TextStyle(color: Color.fromARGB(255, 29, 39, 64), fontWeight: FontWeight.w600),
        ),
      ),
      body: FavoritesList(),
    );
  }
}

class FavoritesList extends StatefulWidget {
  @override
  _FavoritesListState createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  List<Person> favList = List();

  @override
  void initState() {
    super.initState();
    getDataFromCache();
  }

  void getDataFromCache() async {
    final list = (await BCache.instance.query('users'));
    list.forEach((d) {
      final Person p = Person.fromJson(jsonDecode(d.body));
      favList.add(p);
    });
    setState(() {
      print(favList.length.toString());
    });
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Widget favoriteItem(Person p) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(p.user.picture),
            radius: 30.0,
            backgroundColor: Colors.white,
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              capitalize(p.user.name.first) + ' ' + capitalize(p.user.name.last),
              style: TextStyle(fontSize: 20, fontFamily: 'SF-Pro-Text-Regular', color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: favList.length,
          itemBuilder: (BuildContext context, int index) {
            return favoriteItem(favList[index]);
          }),
    );
  }
}
