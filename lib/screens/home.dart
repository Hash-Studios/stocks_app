import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stocks_app/screens/favourites.dart';
import 'stocks_page.dart';
import 'settings.dart';
import 'package:stocks_app/ui/custompopupmenu.dart';

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
  CustomPopupMenu _selectedChoices = choices[0];

  void _select(CustomPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
    });
  }

  Future<bool> onWillPop() async {
    if (_selectedChoices == choices[0]) {
      return true;
    }
    setState(() {
      _selectedChoices = choices[0];
    });
    return false;
  }

  final List<Widget> _children = [
    Stocks(),
    Favourites(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<CustomPopupMenu>(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ),
            elevation: 2,
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
          )
        ],
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: GoogleFonts.roboto(
              color: Colors.black87, fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ),
      body: WillPopScope(
          onWillPop: onWillPop,
          child: _selectedChoices == choices[0]
              ? _children[_currentIndex]
              : _selectedChoices == choices[1] ? _children[1] : _children[2]),
    );
  }
}
