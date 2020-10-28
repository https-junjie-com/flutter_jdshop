/*
 * @Author: your name
 * @Date: 2020-10-09 11:00:37
 * @LastEditTime: 2020-10-26 14:49:32
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter_jdshop/lib/main.dart
 */
import 'package:flutter/material.dart';
import 'pages/routers/router.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: Tabs(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: onGenerateRoute,
      initialRoute: '/',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }
}
