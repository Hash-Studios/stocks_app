import 'package:flutter/material.dart';
import 'bsecodes.dart';

class Stocks extends StatefulWidget {
  @override
  _StocksState createState() => _StocksState();
}

class _StocksState extends State<Stocks> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, position) {
        return ListTile(
          title: Text(bse_codes[position]
              .toString()
              .replaceAll("{", "")
              .replaceAll("}", "")
              .replaceAll(" ", "")
              .split(':')[0]
              .toString()),
          onTap: () {
            print(bse_codes[position]
                .toString()
                .replaceAll("{", "")
                .replaceAll("}", "")
                .replaceAll(" ", "")
                .split(':')[1]
                .toString());
          },
        );
      },
      itemCount: bse_codes.length,
    );
  }
}
