import 'dart:convert';

import 'package:bflutter/bflutter.dart';
import 'package:bflutter_poc/models/remote/person.dart';
import 'package:bflutter_poc/pages/favorites/favorites_screen.dart';
import 'package:bflutter_poc/pages/people/people_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PeopleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 248, 249, 253),
        elevation: 0,
        title: Text(
          "BSS Demo",
          style: TextStyle(color: Color.fromARGB(255, 29, 39, 64), fontWeight: FontWeight.w600),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.redAccent),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: Carousel(),
    );
  }
}

class Carousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  var bloc = PeopleBloc();

  @override
  void initState() {
    super.initState();
    _onResume();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: bloc.getRandomPeopleInfo.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (!snapshot.hasData) {
                  return Expanded(
                    child: Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
                List<Person> people = snapshot.data;
                return CardList(people.reversed.toList(), bloc.getCarouselInfo);
              },
            ),
          ],
        ),
      ),
    );
  }

  _onResume() {
    bloc.getCarouselInfo();
  }
}

class CardList extends StatefulWidget {
  final List<Person> cards;
  final Function loadMoreCard;

  CardList(this.cards, this.loadMoreCard);

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  List<Widget> cardList = List();
  List<Person> cards = List();

  @override
  void didUpdateWidget(CardList oldWidget) {
    setState(() {
      List<Person> temp = widget.cards;
      temp.add(cards.last);
      cards = temp;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    cards = widget.cards;
  }

  void _removeCard(index){
    setState(() {
      cards.removeAt(index);
      cardList.removeLast();
      if (cards.length < 3) {
        widget.loadMoreCard();
      }
      if (cards.length == 0) {

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    cardList.clear();
    cards.asMap().forEach((index, person) {
      cardList.add(Container(
        child: Draggable(
            onDragEnd: (details) async {
              if(details.offset.dx > 150 ){
                //Swipe right
                await BCache.instance.insert(Piece(lot: 'users', body: jsonEncode(person)));
                _removeCard(index);
              } else if (details.offset.dx < -150) {
                //Swipe left
                _removeCard(index);
              }
            },
            childWhenDragging: Container(),
            child: PersonInfo(person),
            feedback: PersonInfo(person),
      ),
      ));
    });

    return Center(
      child: Stack(
        children: cardList,
      ),
    );
  }
}

class PersonInfo extends StatefulWidget {
  final Person person;

  @override
  _PersonInfoState createState() => _PersonInfoState();

  PersonInfo(this.person);
}

enum tabs {
  NAME,
  LOCATION,
  CONTACT,
}

class _PersonInfoState extends State<PersonInfo> {
  var isShowing;

  @override
  void initState() {
    super.initState();
    setState(() {
      isShowing = tabs.NAME;
    });
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Widget buttonsRow() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 48.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              setState(() {
                isShowing = tabs.NAME;
              });
            },
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: isShowing == tabs.NAME ? Colors.blue : Colors.grey),
          ),
          Padding(padding: EdgeInsets.only(right: 8.0)),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              setState(() {
                isShowing = tabs.LOCATION;
              });
            },
            backgroundColor: Colors.white,
            child: Icon(Icons.my_location,
                color: isShowing == tabs.LOCATION ? Colors.red : Colors.grey),
          ),
          Padding(padding: EdgeInsets.only(right: 8.0)),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              setState(() {
                isShowing = tabs.CONTACT;
              });
            },
            backgroundColor: Colors.white,
            child: Icon(Icons.phone, color: isShowing == tabs.CONTACT ? Colors.green : Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget name() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'My name is',
            style: TextStyle(fontSize: 20, fontFamily: 'SF-Pro-Text-Regular', color: Colors.grey),
          ),
          Text(
              capitalize(widget.person.user.name.first) +
                  ' ' +
                  capitalize(widget.person.user.name.last),
              style: TextStyle(fontSize: 24, fontFamily: 'SF-Pro-Text-Bold'))
        ],
      ),
    );
  }

  Widget location() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'My address is',
            style: TextStyle(fontSize: 20, fontFamily: 'SF-Pro-Text-Regular', color: Colors.grey),
          ),
          Text(
              capitalize(widget.person.user.location.street) +
                  ', ' +
                  capitalize(widget.person.user.location.city) +
                  ', ' +
                  capitalize(widget.person.user.location.state),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontFamily: 'SF-Pro-Text-Bold'))
        ],
      ),
    );
  }

  Widget contact() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'My contact is',
            style: TextStyle(fontSize: 20, fontFamily: 'SF-Pro-Text-Regular', color: Colors.grey),
          ),
          Text(widget.person.user.phone,
              style: TextStyle(fontSize: 24, fontFamily: 'SF-Pro-Text-Bold'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 490,
      width: 360,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Card(
        elevation: 2,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                      color: Color.fromRGBO(249, 249, 249, 1.0),
                    ),
                    height: 145,
                  ),
                  Divider(
                    height: 1.0,
                    color: Colors.grey,
                  ),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
                      color: Colors.white,
                    ),
                  ))
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(90.0)),
                      border: Border.all(color: Colors.grey, width: 1.0)),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(widget.person.user.picture),
                    radius: 80.0,
                    backgroundColor: Colors.white,
                  ),
                ),
                Container(
                  height: 100,
                  child: isShowing == tabs.NAME
                      ? name()
                      : isShowing == tabs.LOCATION ? location() : contact(),
                ),
                buttonsRow()
              ],
            )
          ],
        ),
      ),
    );
  }
}
