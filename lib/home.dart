import 'package:flutter/material.dart';
import 'stocks_page.dart';
import 'settings.dart';

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});
 
  String title;
  IconData icon;
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Stocks', icon: Icons.show_chart),
  CustomPopupMenu(title: 'Favourites', icon: Icons.favorite),
  CustomPopupMenu(title: 'Settings', icon: Icons.settings),
];

class _HomeState extends State<Home> {
  
  int _currentIndex = 0;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  CustomPopupMenu _selectedChoices = choices[0];
  void _select(CustomPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
    });
  }

  final List<Widget> _children = [
    Stocks(),
    Container(
      color: Colors.pink[100],
      child: Text('Favourite Stocks'),
    ),
    Settings()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[PopupMenuButton<CustomPopupMenu>(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.more_vert,color: Colors.grey,),
            ),
            elevation: 2,
            onCanceled: () {
              print('You have not chossed anything');
            },
            tooltip: 'Menu',
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((CustomPopupMenu choice) {
                return PopupMenuItem<CustomPopupMenu>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          )],
        backgroundColor: Colors.white,
        title: Text(widget.title,style: TextStyle(color: Colors.black87,fontSize: 35,fontWeight: FontWeight.bold),),
      ),
      body:  _selectedChoices == choices[0] ? _children[_currentIndex] : _selectedChoices == choices[1] ? _children[1] : _children[2],
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: onTabTapped,
      //   currentIndex: _currentIndex,
      //   items: [
      //     BottomNavigationBarItem(
      //       activeIcon: new Icon(Icons.show_chart, color: Colors.pink),
      //       icon: new Icon(Icons.show_chart, color: Colors.grey),
      //       title: new Text(
      //         'Stocks',
      //         style: TextStyle(color: Colors.pink),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       activeIcon: new Icon(Icons.add_box, color: Colors.pink),
      //       icon: new Icon(Icons.add_box, color: Colors.grey),
      //       title: new Text(
      //         'Your Stocks',
      //         style: TextStyle(color: Colors.pink),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       activeIcon: new Icon(Icons.notifications, color: Colors.pink),
      //       icon: new Icon(Icons.notifications, color: Colors.grey),
      //       title: new Text(
      //         'Notifications',
      //         style: TextStyle(color: Colors.pink),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       activeIcon: new Icon(Icons.person, color: Colors.pink),
      //       icon: new Icon(Icons.person, color: Colors.grey),
      //       title: new Text(
      //         'Profile',
      //         style: TextStyle(color: Colors.pink),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}