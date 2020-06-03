import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_color/random_color.dart';
import 'package:stocks_app/screens/stocks_page.dart';
import 'package:stocks_app/ui/grid_graph.dart';
import 'package:stocks_app/screens/info_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_app/data/bseCodesData.dart';
import 'package:hive/hive.dart';

// ->Globals

// Hive Vars
var _fav = Hive.box('fav_stocks');

/// Thumbnail colors
RandomColor _randomColor = RandomColor();
Color color1 = _randomColor.randomColor(
    colorSaturation: ColorSaturation.highSaturation,
    colorHue: ColorHue.blue,
    colorBrightness: ColorBrightness.light);
Color color2 = _randomColor.randomColor(
    colorSaturation: ColorSaturation.highSaturation,
    colorHue: ColorHue.blue,
    colorBrightness: ColorBrightness.light);

class StockTile extends StatefulWidget {
  final Key key;
  List<String> items;
  int position;
  List<bool> dataFetched;
  Map dataAll;
  Map lastDataAll;
  Map<String, List<GridSeries>> graphs;
  bool favLoaded;

  StockTile(this.key, this.items, this.position, this.dataFetched, this.dataAll,
      this.lastDataAll, this.graphs, this.favLoaded);
  @override
  _StockTileState createState() => _StockTileState();
}

class _StockTileState extends State<StockTile> {
  // Initials Generator For Stocks Name
  String getInitials(String nameString) {
    if (nameString.isEmpty) return " ";

    List<String> nameArray =
        nameString.replaceAll(new RegExp(r"\s+\b|\b\s"), " ").split(" ");
    String initials = ((nameArray[0])[0] != null ? (nameArray[0])[0] : " ") +
        (nameArray.length == 1 ? " " : (nameArray[nameArray.length - 1])[0]);

    return initials;
  }

  // String to TitleCase Function
  String titleCase(String text) {
    var texxt = text.toLowerCase();
    if (texxt.length <= 1) return texxt.toUpperCase();
    var words = texxt.split(' ');
    var capitalized = words.map((word) {
      var first = word.substring(0, 1).toUpperCase();
      var rest = word.substring(1);
      return '$first$rest';
    });
    return capitalized.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      child: Stack(
        children: <Widget>[
          Card(
            color: Colors.blue[50],
            elevation: 0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 310.h,
                    width: 335.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: Container(
                            decoration: widget.dataFetched[bse_names
                                    .indexOf(widget.items[widget.position])]
                                ? BoxDecoration(color: Colors.white)
                                : BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [color1, color2])),
                            child: SizedBox(width: 335.w, height: 310.h),
                          ),
                        ),
                        widget.dataFetched[bse_names
                                .indexOf(widget.items[widget.position])]
                            ? Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  getInitials(widget.items[widget.position]),
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.black87),
                                ),
                              )
                            : Text(
                                getInitials(widget.items[widget.position]),
                                style: TextStyle(
                                    fontSize: 25, color: Colors.black87),
                              ),
                        widget.dataFetched[bse_names
                                .indexOf(widget.items[widget.position])]
                            ? GridChart(
                                dataChart: widget.graphs[
                                    "stock${bse_names.indexOf(widget.items[widget.position])}"],
                              )
                            : CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white12),
                              ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 270,
                        child: Text(
                          titleCase(widget.items[widget.position])
                              .replaceAll(" Ltd.", "")
                              .replaceAll(" Ltd", "")
                              .replaceAll(".ltd.", ""),
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
                      Text(
                        widget.items[widget.position],
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w300,
                            fontSize: 12),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            widget.dataFetched[bse_names
                                    .indexOf(widget.items[widget.position])]
                                ? widget
                                    .dataAll[
                                        "stock${bse_names.indexOf(widget.items[widget.position])}"]
                                    .close
                                    .toString()
                                : '',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                          Text(' '),
                          Text(
                            widget.dataFetched[bse_names
                                    .indexOf(widget.items[widget.position])]
                                ? " ${(widget.dataAll["stock${bse_names.indexOf(widget.items[widget.position])}"].close - widget.lastDataAll["stock${bse_names.indexOf(widget.items[widget.position])}"].close).toStringAsFixed(2)} "
                                : '',
                            style: TextStyle(
                                backgroundColor: widget.dataFetched[bse_names
                                        .indexOf(widget.items[widget.position])]
                                    ? widget
                                                .dataAll[
                                                    "stock${bse_names.indexOf(widget.items[widget.position])}"]
                                                .close >=
                                            widget
                                                .lastDataAll[
                                                    "stock${bse_names.indexOf(widget.items[widget.position])}"]
                                                .close
                                        ? Colors.green
                                        : Colors.red
                                    : Colors.white,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    return Info(
                        bse_codes[bse_names
                                .indexOf(widget.items[widget.position])]
                            .toString()
                            .replaceAll("{", "")
                            .replaceAll("}", "")
                            .replaceAll(" EOD Prices", "")
                            .replaceAll("-", "")
                            .split(': ')[0]
                            .toString(),
                        bse_codes[bse_names
                                .indexOf(widget.items[widget.position])]
                            .toString()
                            .replaceAll("{", "")
                            .replaceAll("}", "")
                            .split(': ')[1]
                            .toString());
                  },
                ),
              );
            },
            child: SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: Text(' '),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () {
                  // print("Hello");
                  favLoaded
                      ? _fav.get(bse_codes[bse_names
                                      .indexOf(widget.items[widget.position])]
                                  .toString()
                                  .replaceAll("{", "")
                                  .replaceAll("}", "")
                                  .split(': ')[1]
                                  .toString()) ==
                              true
                          ? _fav.delete(bse_codes[bse_names
                                  .indexOf(widget.items[widget.position])]
                              .toString()
                              .replaceAll("{", "")
                              .replaceAll("}", "")
                              .split(': ')[1]
                              .toString())
                          : _fav.put(
                              bse_codes[bse_names
                                      .indexOf(widget.items[widget.position])]
                                  .toString()
                                  .replaceAll("{", "")
                                  .replaceAll("}", "")
                                  .split(': ')[1]
                                  .toString(),
                              true)
                      : print('favLoaded is False');
                  setState(() {});
                },
                icon: Icon(
                  favLoaded
                      ? _fav.get(bse_codes[bse_names
                                      .indexOf(widget.items[widget.position])]
                                  .toString()
                                  .replaceAll("{", "")
                                  .replaceAll("}", "")
                                  .split(': ')[1]
                                  .toString()) ==
                              true
                          ? Icons.favorite
                          : Icons.favorite_border
                      : Icons.favorite_border,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
