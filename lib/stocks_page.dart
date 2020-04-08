import 'package:flutter/material.dart';
import 'bsecodes.dart';
import 'info_page.dart';

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
              .replaceAll(" EOD Prices", "")
              .replaceAll("-", "")
              .split(': ')[0]
              .toString()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Info(
                      bse_codes[position]
                          .toString()
                          .replaceAll("{", "")
                          .replaceAll("}", "")
                          .replaceAll(" EOD Prices", "")
                          .replaceAll("-", "")
                          .split(': ')[0]
                          .toString(),
                      bse_codes[position]
                          .toString()
                          .replaceAll("{", "")
                          .replaceAll("}", "")
                          .split(': ')[1]
                          .toString());
                },
              ),
            );
            print(bse_codes[position]
                .toString()
                .replaceAll("{", "")
                .replaceAll("}", "")
                .split(': ')[1]
                .toString());
          },
        );
      },
      itemCount: bse_codes.length,
    );
  }
}
