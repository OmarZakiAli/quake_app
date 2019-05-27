import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

void main() async {
  List quakes = await getData();
  int wtf = 0;
  DateFormat dateFormat;
  DateTime dateTime;
  runApp(MaterialApp(
    title: "quakes",
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "earth quakes",
          style: TextStyle(color: Colors.pink, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int position) {
          if (position.isOdd) {
            return Divider(
              color: Colors.green,
            );
          }

          wtf = position ~/ 2;
          dateTime = DateTime.fromMillisecondsSinceEpoch(
              quakes[wtf]["properties"]["time"]);
          dateFormat = DateFormat.yMMMMd("en_US");

          return ListTile(
            onTap: () {
              _showdialog(quakes[wtf]["properties"]["title"], context);
            },
            title: Text("${quakes[wtf]["properties"]["title"]}"),
            leading: CircleAvatar(
              child: Text("${quakes[wtf]["properties"]["mag"]}"),
            ),
            subtitle: Text("${dateFormat.format(dateTime).toString()}"),
          );
        },
        itemCount: quakes.length,
      ),
    ),
  ));
}

void _showdialog(String s, BuildContext context) {
  var allert = AlertDialog(
    title: Text("wtf"),
    content: Text(
      "$s",
      style: TextStyle(fontSize: 24, color: Colors.red),
    ),
    actions: <Widget>[
      FlatButton(onPressed: () => Navigator.pop(context), child: Text("ok"))
    ],
  );

  showDialog(context: context, child: allert);
}

Future<List> getData() async {
  http.Response response = await http.get(
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson");
  return json.decode(response.body)["features"];
}
