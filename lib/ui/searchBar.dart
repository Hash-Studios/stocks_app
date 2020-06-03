import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SearchBar extends StatefulWidget {
  // Search Input Text Controllers
  TextEditingController editingController;
  List<String> duplicateItems;
  List<String> items;

  SearchBar(this.editingController, this.duplicateItems, this.items);
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  // Search Filter Function
  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(widget.duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        widget.items.clear();
        widget.items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        widget.items.clear();
        widget.items.addAll(widget.duplicateItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        filterSearchResults(value);
      },
      controller: widget.editingController,
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
