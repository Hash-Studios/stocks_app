import 'package:flutter/material.dart';
import 'stocks_page.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _children = [
    Stocks(),
    Container(
      color: Colors.pink[100],
      child: Text('Your Stocks'),
    ),
    Container(
      color: Colors.pink[100],
      child: Text('Notifications'),
    ),
    Container(
      color: Colors.pink[100],
      child: Text('Profile'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[IconButton(icon: Icon(Icons.more_vert,color: Colors.white,), onPressed: null)],
        backgroundColor: Colors.pink[300],
        title: Text(widget.title,style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            activeIcon: new Icon(Icons.show_chart, color: Colors.pink),
            icon: new Icon(Icons.show_chart, color: Colors.grey),
            title: new Text(
              'Stocks',
              style: TextStyle(color: Colors.pink),
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: new Icon(Icons.add_box, color: Colors.pink),
            icon: new Icon(Icons.add_box, color: Colors.grey),
            title: new Text(
              'Your Stocks',
              style: TextStyle(color: Colors.pink),
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: new Icon(Icons.notifications, color: Colors.pink),
            icon: new Icon(Icons.notifications, color: Colors.grey),
            title: new Text(
              'Notifications',
              style: TextStyle(color: Colors.pink),
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: new Icon(Icons.person, color: Colors.pink),
            icon: new Icon(Icons.person, color: Colors.grey),
            title: new Text(
              'Profile',
              style: TextStyle(color: Colors.pink),
            ),
          )
        ],
      ),
    );
  }
}
