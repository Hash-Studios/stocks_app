import 'package:flutter/material.dart';
import 'bsecodes.dart';
import 'info_page.dart';

class Stocks extends StatefulWidget {
  @override
  _StocksState createState() => _StocksState();
}

class _StocksState extends State<Stocks> {
  TextEditingController editingController = TextEditingController();
  final duplicateItems = bse_names;
  var items = List<String>();

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              filterSearchResults(value);
            },
            controller: editingController,
            decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)))),
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, position) {
              return ListTile(
                title: Text(items[position]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Info(
                            bse_codes[bse_names.indexOf(items[position])]
                                .toString()
                                .replaceAll("{", "")
                                .replaceAll("}", "")
                                .replaceAll(" EOD Prices", "")
                                .replaceAll("-", "")
                                .split(': ')[0]
                                .toString(),
                            bse_codes[bse_names.indexOf(items[position])]
                                .toString()
                                .replaceAll("{", "")
                                .replaceAll("}", "")
                                .split(': ')[1]
                                .toString());
                      },
                    ),
                  );
                  print(bse_codes[bse_names.indexOf(items[position])]
                      .toString()
                      .replaceAll("{", "")
                      .replaceAll("}", "")
                      .split(': ')[1]
                      .toString());
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
